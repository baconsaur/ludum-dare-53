class_name WalkState
extends MoveState


func handle_input(event):
	var new_state = .handle_input(event)
	if new_state:
		return new_state

	if Input.is_action_just_pressed("crouch"):
		return state_map["Crouch"]

func physics_process(delta):
	knight.velocity.y += knight.gravity
	
	var new_state = .physics_process(delta)
	if new_state:
		return new_state
	
	if knight.velocity.x == 0:
		return state_map["Idle"]
	
	if Input.is_action_pressed("crouch"):
		return state_map["Crawl"]
