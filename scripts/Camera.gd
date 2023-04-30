extends Camera2D

export var shake_time = 0.1
export var shake_factor = 0.5

var shake_countdown = 0


func _process(delta):
	if shake_countdown <= 0:
		return

	shake_countdown -= delta
	if shake_countdown <= 0:
		position = Vector2.ZERO
	else:
		position += Vector2(
			rand_range(-shake_factor, shake_factor), rand_range(-shake_factor, shake_factor)
		)

func shake():
	shake_countdown = shake_time
