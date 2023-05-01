class_name Enter
extends BaseState

export var velocity = -200


func enter():
	.enter()
	knight.sprite.flip_h = false
	knight.position.x -= 24

func process(delta):
	if not knight.exit_position:
		return

	knight.velocity = knight.move_and_slide(Vector2(velocity, 0), Vector2.UP)
	
	if knight.position.x <= knight.exit_position.x:
		knight.emit_signal("exited")
