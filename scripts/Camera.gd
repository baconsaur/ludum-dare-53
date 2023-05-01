extends Camera2D

export var shake_time = 0.175
export var shake_factor = 2.5

var shake_countdown = 0
var shake_start = Vector2.ZERO


func _process(delta):
	if shake_countdown <= 0:
		return

	shake_countdown -= delta
	if shake_countdown <= 0:
		position = shake_start
	else:
		position += Vector2(
			rand_range(-shake_factor, shake_factor), rand_range(-shake_factor, shake_factor)
		)

func shake():
	shake_start = position
	shake_countdown = shake_time
