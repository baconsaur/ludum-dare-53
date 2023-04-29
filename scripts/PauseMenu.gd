extends Control

export var main_menu_scene = "res://scenes/MainMenu.tscn"
export var options_menu = preload("res://scenes/OptionsMenu.tscn")


func _ready():
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		unpause()

func _on_ResumeButton_pressed():
	unpause()

func _on_MenuButton_pressed():
	TransitionManager.transition_to(main_menu_scene)

func _on_OptionsButton_pressed():
	var options_instance = options_menu.instance()
	get_parent().add_child(options_instance)
	hide()
	options_instance.connect("tree_exited", self, "show")

func unpause():
	get_tree().paused = false
	queue_free()
