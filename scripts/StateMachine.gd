class_name StateMachine
extends Node

export var buffer_time = 0.25
export var starting_state : NodePath

var current_state: BaseState
var action_buffer = null
var buffer_countdown = 0

func init(knight):
	var children = get_children()
	
	var state_map = {}
	for child in children:
		state_map[child.name] = child

	for child in children:
		child.knight = knight
		child.state_map = state_map
	
	change_state(get_node(starting_state))

func process(delta):
	if buffer_countdown > 0:
		buffer_countdown -= delta
	if buffer_countdown <= 0:
		action_buffer = null
	change_state(current_state.process(delta))

func handle_action(action):
	var next_state = current_state.handle_action(action)
	if action and not next_state:
		if not (action in [Knight.Actions.ADVANCE, Knight.Actions.RETREAT] and current_state is Move):
			action_buffer = action
			buffer_countdown = buffer_time
			
	change_state(next_state)

func change_state(new_state):
	if not new_state:
		return

	if current_state:
		current_state.exit()
	
	current_state = new_state
	
	if current_state is Idle and action_buffer != null:
		handle_action(action_buffer)
		action_buffer = null
	else:
		current_state.enter()
