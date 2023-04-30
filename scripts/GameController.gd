extends Node2D

export var spawn_run_distance = 100

var pause_menu = preload("res://scenes/PauseMenu.tscn")
var game_over_menu = preload("res://scenes/GameOverMenu.tscn")
var knight_obj = preload("res://scenes/Knight.tscn")
var score = 0
var player_spawn_offset
var opponent_spawn_offset

onready var player = $PlayerKnight
onready var ui = $CanvasLayer/UI
onready var camera = $Camera2D
onready var score_label = $CanvasLayer/UI/ScoreContainer/Score
onready var enter_bound = $Camera2D/Bounds/BoundsL/CollisionShape2D


func _ready():
	player_spawn_offset = player.position - camera.position
	opponent_spawn_offset = player_spawn_offset * Vector2(-1, 1)
	player.connect("defeated", self, "game_over")
	player.connect("big_hit", self, "big_hit")
	player.spawn(player.position)
	spawn_knight()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func spawn_knight():
	var knight = knight_obj.instance()
	var spawn_point = camera.position + opponent_spawn_offset
	knight.position = spawn_point - Vector2(spawn_run_distance, 0)
	add_child(knight)
	knight.spawn(spawn_point)
	knight.connect("defeated", self, "handle_defeat", [knight])
	knight.connect("big_hit", self, "big_hit")
	knight.connect("spawned", self, "complete_spawn")
	knight.connect("exited", self, "complete_exit", [knight])

func complete_spawn():
	enter_bound.disabled = false
	player.suspend_actions = false

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
