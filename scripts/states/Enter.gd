class_name Enter
extends BaseState

export var velocity = 200
export var friction = 15


func enter():
	.enter()
	knight.velocity.x = velocity

func process(delta):
	if knight.position.x >= knight.spawn_position.x:
		knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)

	if knight.velocity.is_equal_approx(Vector2.ZERO):
		knight.is_spawned = true
		knight.can_be_damaged = true
		knight.emit_signal("spawned")
		return state_map["Idle"]
