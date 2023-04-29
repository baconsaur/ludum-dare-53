class_name MoveState
extends BaseState

export var acceleration = 10
export var friction = 20
export var max_velocity = 100


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		return state_map["Jump"]

func physics_process(delta):
	var direction = Input.get_axis("left", "right")

	if direction and direction * knight.velocity.x < 0:
		knight.velocity.x *= -1
	elif direction:
		knight.velocity.x = move_toward(knight.velocity.x, direction * max_velocity, acceleration)
	else:
		knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)
