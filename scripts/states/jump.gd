extends MoveState

export var jump_speed = 250
export var max_jump_height = 38
export var max_gravity_modifier = 2

var jump_start_y
var jump_end_y


func enter():
	jump_start_y = knight.position.y
	jump_end_y = null
	.enter()
	knight.velocity.y = -jump_speed

func handle_input(event):
	var new_state = .handle_input(event)
	if new_state:
		return new_state

	if Input.is_action_just_released("jump"):
		jump_end_y = min(knight.position.y, jump_start_y)

func physics_process(delta):
	var actual_max_height = max_jump_height
	if jump_end_y:
		actual_max_height = abs(jump_end_y - jump_start_y)
	
	var jump_height = jump_start_y - knight.position.y
	if jump_height >= actual_max_height:
		knight.velocity.y += knight.gravity * max_gravity_modifier
	else:
		knight.velocity.y += knight.gravity

	.physics_process(delta)

	if knight.velocity.y >= 0:
		return state_map["Fall"]

	if knight.is_on_floor():
		if knight.velocity.x == 0:
			return state_map["Idle"]
		return state_map["Walk"]
