extends Node2D

export var player_spawn_point = Vector2()
export var opponent_spawn_point = Vector2()

var pause_menu = preload("res://scenes/PauseMenu.tscn")
var game_over_menu = preload("res://scenes/GameOverMenu.tscn")
var knight_obj = preload("res://scenes/Knight.tscn")
var score = 0

onready var player = $PlayerKnight
onready var ui = $CanvasLayer/UI
onready var camera = $Camera2D
onready var score_label = $CanvasLayer/UI/ScoreContainer/Score


func _ready():
	player.connect("defeated", self, "game_over")
	player.connect("big_hit", self, "big_hit")
	spawn_knight()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func spawn_knight():
	var knight = knight_obj.instance()
	knight.position = opponent_spawn_point
	add_child(knight)
	knight.connect("defeated", self, "handle_defeat", [knight])
	knight.connect("big_hit", self, "big_hit")

func handle_defeat(knight):
	score += 1
	score_label.text = str(score)
	
	knight.queue_free()
	if player.is_defeated:
		return
	
	yield(get_tree().create_timer(1.0), "timeout")
	player.position = player_spawn_point
	spawn_knight()

func big_hit():
	camera.shake()

func pause():
	var pause_instance = pause_menu.instance()
	ui.add_child(pause_instance)

func game_over():
	var game_over_instance = game_over_menu.instance()
	ui.add_child(game_over_instance)
