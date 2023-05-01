class_name Stunned
extends BaseState

export var max_stun_time = 1

var stun_countdown = max_stun_time


func enter():
	.enter()
	stun_countdown = max_stun_time

func handle_action(action):
	if action == Knight.Actions.HIT:
		knight.big_hit()
		return state_map["Hit"]

func process(delta):
	if stun_countdown > 0:
		stun_countdown -= delta
		if stun_countdown <= 0:
			return state_map["Idle"]
