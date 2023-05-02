extends Control

onready var music_bus = AudioServer.get_bus_index("Music")
onready var sounds_bus = AudioServer.get_bus_index("Sound")

onready var toggle_music_button = $ColorRect/VBoxContainer/ToggleMusicButton
onready var toggle_sound_button = $ColorRect/VBoxContainer/ToggleSoundButton


func _ready():
	update_setting_labels()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()

func _on_ToggleSoundButton_pressed():
	AudioServer.set_bus_mute(sounds_bus, not AudioServer.is_bus_mute(sounds_bus))
	update_setting_labels()

func _on_ToggleMusicButton_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	update_setting_labels()

func _on_BackButton_pressed():
	queue_free()

func update_setting_labels():
	if AudioServer.is_bus_mute(music_bus):
		toggle_music_button.text = "Music On"
	else:
		toggle_music_button.text = "Music Off"

	if AudioServer.is_bus_mute(sounds_bus):
		toggle_sound_button.text = "Sound Effects On"
	else:
		toggle_sound_button.text = "Sound Effects Off"
