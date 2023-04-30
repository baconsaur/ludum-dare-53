class_name Idle
extends BaseState


func handle_action(action):
	var new_state = .handle_action(action)
	if new_state:
		return new_state
	
	match (action):
		Knight.Actions.ADVANCE:
			return state_map["Advance"]
		Knight.Actions.RETREAT:
			return state_map["Retreat"]
		Knight.Actions.LUNGE:
			if knight.lunge_countdown > 0:
				return
			return state_map["TestLunge"]
		Knight.Actions.BLOCK:
			if knight.lunge_countdown > 0:
				return
			return state_map["Block"]

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
