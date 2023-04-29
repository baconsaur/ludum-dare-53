class_name Move
extends BaseState

export var velocity = 200
export var friction = 15

func enter():
	.enter()
	
	if knight.test_move(knight.get_transform(), Vector2(velocity * 2, 0)):
		knight.velocity.x = velocity
	else:
		print("nope")

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state

	knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)

	if knight.velocity.is_equal_approx(Vector2.ZERO):
		return state_map["Idle"]
