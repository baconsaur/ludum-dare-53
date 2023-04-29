extends Node2D

var pause_menu = preload("res://scenes/PauseMenu.tscn")
var game_over_menu = preload("res://scenes/GameOverMenu.tscn")
onready var ui = $CanvasLayer/UI


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func pause():
	var pause_instance = pause_menu.instance()
	ui.add_child(pause_instance)

func game_over():
	var game_over_instance = game_over_menu.instance()
	ui.add_child(game_over_instance)
