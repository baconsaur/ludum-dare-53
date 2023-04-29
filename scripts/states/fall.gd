extends MoveState


func handle_input(_event):
	return

func physics_process(delta):
	knight.velocity.y += knight.gravity
	
	var new_state = .physics_process(delta)
	if new_state:
		return new_state
	
	if knight.is_on_floor():
		return state_map["Idle"]
