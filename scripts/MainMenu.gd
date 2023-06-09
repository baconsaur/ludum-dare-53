extends Control

export var game_scene = "res://scenes/Game.tscn"
export var options_menu = preload("res://scenes/OptionsMenu.tscn")

onready var menu_container = $CanvasLayer
onready var menu_items = $CanvasLayer/MarginContainer/ColorRect


func _on_StartButton_pressed():
	TransitionManager.transition_to(game_scene)

func _on_OptionsButton_pressed():
	var options_instance = options_menu.instance()
	menu_container.add_child(options_instance)
	menu_items.hide()
	options_instance.connect("tree_exited", menu_items, "show")
