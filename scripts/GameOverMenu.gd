extends MarginContainer

export var game_scene = "res://scenes/Game.tscn"
export var main_menu_scene = "res://scenes/MainMenu.tscn"

func _ready():
	get_tree().paused = true

func _on_ReplayButton_pressed():
	TransitionManager.transition_to(game_scene)

func _on_MainMenuButton_pressed():
	TransitionManager.transition_to(main_menu_scene)
