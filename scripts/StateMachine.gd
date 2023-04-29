class_name StateMachine
extends Node

export var starting_state : NodePath

var current_state: BaseState


func init(knight):
	var children = get_children()
	
	var state_map = {}
	for child in children:
		state_map[child.name] = child

	for child in children:
		child.knight = knight
		child.state_map = state_map
	
	change_state(get_node(starting_state))

func physics_process(delta):
	change_state(current_state.physics_process(delta))

func handle_input(event):
	change_state(current_state.handle_input(event))

func change_state(new_state):
	if not new_state:
		return

	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
