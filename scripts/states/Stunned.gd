class_name Stunned
extends BaseState


func handle_action(action):
	if action == Knight.Actions.HIT:
		knight.big_hit()
		return state_map["Hit"]
