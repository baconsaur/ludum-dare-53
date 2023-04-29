extends Knight

export var min_move_interval = 0.3
export var max_move_interval = 0.8

var move_cooldown = min_move_interval


func _ready():
	randomize()

func _process(delta):
	._process(delta)

	if move_cooldown > 0:
		move_cooldown -= delta
		return
		
	var action_weights = {
		Actions.ADVANCE: 50,
		Actions.RETREAT: 5,
		Actions.LUNGE: 0,
		Actions.SWORD_DOWN: 0 if sword_position == SwordPositions.DOWN else 10,
		Actions.SWORD_UP: 0 if sword_position == SwordPositions.UP else 10,
	}
	
	var cautious = legs_stripped or torso_stripped
	
	if opponent:
		action_weights[Actions.ADVANCE] = 5
		action_weights[Actions.RETREAT] = 50 if cautious else 30

		if opponent.sword_position != sword_position:
			action_weights[Actions.LUNGE] = 50
		else:
			action_weights[Actions.LUNGE] = 25

		if opponent.sword_position == SwordPositions.DOWN and sword_position == SwordPositions.DOWN:
			action_weights[Actions.SWORD_UP] = 20 if cautious else 30
		if opponent.sword_position == SwordPositions.UP and sword_position == SwordPositions.UP:
			action_weights[Actions.SWORD_DOWN] = 20 if cautious else 30
	

	states.handle_action(select_action(action_weights))
	move_cooldown = rand_range(min_move_interval, max_move_interval)

func select_action(action_weights):
	var total_action_weight = 0
	for action in action_weights:
		total_action_weight += action_weights[action]
	var roll = randi() % total_action_weight

	for action in action_weights:
		roll -= action_weights[action]
		if roll <= 0:
			return action
