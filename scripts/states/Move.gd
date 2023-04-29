class_name Move
extends BaseState

export var velocity = 200
export var friction = 15

var finished = false

func enter():
	.enter()
	finished = false
	knight.velocity.x = velocity

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state

	knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)

	if knight.velocity.is_equal_approx(Vector2.ZERO):
		return state_map["Idle"]
