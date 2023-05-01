extends Knight

export var warning_time = 0.5
export var min_move_interval = 0.2
export var max_move_interval = 0.6

var move_cooldown = min_move_interval
var next_action


func spawn(pos):
	.spawn(pos)
	states.handle_action(Actions.ENTER)

func _process(delta):
	._process(delta)

	if not is_spawned or is_defeated or (opponent and opponent.is_defeated) or not states.current_state is Idle:
		return

	if move_cooldown > 0:
		move_cooldown -= delta
		if move_cooldown < warning_time and next_action == Actions.LUNGE:
			shader_animator.play("warning")
		return
	states.handle_action(next_action)

	var action_weights = {
		Actions.ADVANCE: 50,
		Actions.RETREAT: 5,
		Actions.LUNGE: 0,
		Actions.SWORD_DOWN: 0 if sword_position == SwordPositions.DOWN else 10,
		Actions.SWORD_UP: 0 if sword_position == SwordPositions.UP else 10,
		Actions.BLOCK: 0,
	}

	var cautious = bool(strip_status["torso"] or strip_status["legs"])

	if opponent:
		action_weights[Actions.ADVANCE] = 5
		action_weights[Actions.RETREAT] = 50 if cautious else 30

		if opponent.sword_position != sword_position:
			action_weights[Actions.LUNGE] = 50
		else:
			action_weights[Actions.LUNGE] = 25

		if opponent.sword_position == SwordPositions.DOWN and sword_position == SwordPositions.DOWN:
			action_weights[Actions.SWORD_UP] = 20 if cautious else 30
			action_weights[Actions.BLOCK] = 25 if strip_status["legs"] else 10
		if opponent.sword_position == SwordPositions.UP and sword_position == SwordPositions.UP:
			action_weights[Actions.SWORD_DOWN] = 20 if cautious else 30
			action_weights[Actions.BLOCK] = 25 if strip_status["torso"] else 10

		if sword_position == SwordPositions.UP and opponent.strip_status["torso"]:
			action_weights[Actions.SWORD_DOWN] += 5
		if sword_position == SwordPositions.DOWN and opponent.strip_status["legs"]:
			action_weights[Actions.SWORD_UP] += 5

	if test_move(get_transform(), Vector2(20, 0)):
		action_weights[Actions.ADVANCE] = 0

	if test_move(get_transform(), Vector2(20, 0)):
		action_weights[Actions.RETREAT] = 0
		action_weights[Actions.LUNGE] += 10

	if lunge_countdown > 0:
		action_weights[Actions.LUNGE] = 0

	next_action = select_action(action_weights)

	move_cooldown = rand_range(min_move_interval, max_move_interval)
	
	if next_action == Actions.LUNGE:
		move_cooldown = warning_time

func select_action(action_weights):
	var total_action_weight = 0
	for action in action_weights:
		total_action_weight += action_weights[action]
	var roll = randi() % total_action_weight

	for action in action_weights:
		roll -= action_weights[action]
		if roll <= 0:
			return action
