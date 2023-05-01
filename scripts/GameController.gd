extends Node2D

export var spawn_run_distance = 100
export var max_tutorial_time = 5

var pause_menu = preload("res://scenes/PauseMenu.tscn")
var game_over_menu = preload("res://scenes/GameOverMenu.tscn")
var knight_obj = preload("res://scenes/Knight.tscn")
var score = 0
var player_spawn_offset
var opponent_spawn_offset
var current_tutorial = null
var tutorial_countdown = max_tutorial_time

onready var player = $PlayerKnight
onready var ui = $CanvasLayer/UI
onready var camera = $Camera2D
onready var score_label = $CanvasLayer/UI/ScoreContainer/Score
onready var enter_bound = $Camera2D/Bounds/BoundsL/CollisionShape2D
onready var tutorial_player = $CanvasLayer/TutorialPlayer


func _ready():
	if not Global.tutorial_seen:
		tutorial_player.connect("animation_finished", self, "handle_tutorial_step")
		tutorial_player.play("show_move_tutorial")
		Global.tutorial_seen = true

	player_spawn_offset = player.position - camera.position
	opponent_spawn_offset = player_spawn_offset * Vector2(-1, 1)
	player.connect("action", self, "handle_player_action", [], CONNECT_DEFERRED)
	player.connect("defeated", self, "game_over")
	player.connect("big_hit", self, "big_hit")
	player.spawn(player.position)
	spawn_knight()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()
	
	if tutorial_countdown > 0:
		tutorial_countdown -= delta
		if tutorial_countdown <= 0:
			dismiss_tutorial()

func spawn_knight():
	var knight = knight_obj.instance()
	var spawn_point = camera.position + opponent_spawn_offset
	knight.position = spawn_point - Vector2(spawn_run_distance, 0)
	add_child(knight)
	knight.top_colors.erase(player.top_color)
	knight.spawn(spawn_point)
	knight.connect("defeated", self, "handle_defeat", [knight])
	knight.connect("big_hit", self, "big_hit")
	knight.connect("spawned", self, "complete_spawn")
	knight.connect("exited", self, "complete_exit", [knight])

func complete_spawn():
	enter_bound.disabled = false
	player.suspend_actions = false

func handle_player_action(action):
	if not current_tutorial:
		return
	
	match (current_tutorial):
		"move":
			if action in [Knight.Actions.ADVANCE, Knight.Actions.RETREAT]:
				dismiss_tutorial()
		"pos":
			if action in [Knight.Actions.SWORD_DOWN, Knight.Actions.SWORD_UP]:
				dismiss_tutorial()
		"fight":
			if action in [Knight.Actions.LUNGE, Knight.Actions.BLOCK]:
				dismiss_tutorial()

func handle_tutorial_step(anim_name):
	if "hide_" in anim_name:
		if current_tutorial == "move":
			tutorial_player.play("show_pos_tutorial")
		elif current_tutorial == "pos":
			tutorial_player.play("show_fight_tutorial")
		
		current_tutorial = null
		return

	if anim_name == "show_move_tutorial":
		current_tutorial = "move"
	elif anim_name == "show_pos_tutorial":
		current_tutorial = "pos"
	elif anim_name == "show_fight_tutorial":
		current_tutorial = "fight"
	
	tutorial_countdown = max_tutorial_time

func dismiss_tutorial():
	if not current_tutorial:
		return

	if current_tutorial == "move":
		tutorial_player.play("hide_move_tutorial")
	elif current_tutorial == "pos":
		tutorial_player.play("hide_pos_tutorial")
	elif current_tutorial == "fight":
		tutorial_player.play("hide_fight_tutorial")

func handle_defeat(knight):
	score += 1
	score_label.text = str(score)
	
	knight.exit(camera.position + opponent_spawn_offset - Vector2(spawn_run_distance, 0))
	if player.is_defeated:
		return

	enter_bound.disabled = true
	player.suspend_actions = true

func complete_exit(knight):
	knight.queue_free()
	
	if player.is_defeated:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position:x", player.position.x - player_spawn_offset.x, 1)
	tween.tween_callback(self, "spawn_knight")

func big_hit():
	camera.shake()

func pause():
	var pause_instance = pause_menu.instance()
	ui.add_child(pause_instance)

func game_over():
	var game_over_instance = game_over_menu.instance()
	ui.add_child(game_over_instance)
