extends MoveState


func handle_input(event):
	var new_state = .handle_input(event)
	if new_state:
		return new_state

	if Input.is_action_just_released("crouch"):
		if Input.get_axis("left", "right") != 0:
			return state_map["Walk"]
		return state_map["Idle"]

func physics_process(delta):
	knight.velocity.y += knight.gravity
	
	var new_state = .physics_process(delta)
	if new_state:
		return new_state
	
	if knight.velocity.x == 0:
		return state_map["Crouch"]
