extends CanvasLayer

var next_scene

onready var color_rect = $ColorRect
onready var knight = $AnimationPlayer


func _ready():
	knight.play("Fade In")

func transition_to(scene_path):
	get_tree().paused = true
	next_scene = scene_path
	knight.play("Fade Out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out" and next_scene:
		get_tree().change_scene(next_scene)
		get_tree().paused = false
		knight.play("Fade In")
		next_scene = null
