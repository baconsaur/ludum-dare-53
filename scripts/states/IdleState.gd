class_name IdleState
extends BaseState

export var friction = 20

func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		return state_map["Jump"]

func physics_process(_delta):
	knight.velocity.y += knight.gravity
	knight.velocity.x = move_toward(knight.velocity.x, 0, friction)
	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)
	
	if not knight.is_on_floor():
		return state_map["Fall"]
