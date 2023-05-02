extends Camera2D

export var scroll_speed = 20

func _process(delta):
	position.x += delta * scroll_speed
