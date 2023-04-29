extends Knight


func _process(delta):
	._process(delta)
	if is_defeated or (opponent and opponent.is_defeated):
		return

	if Input.is_action_pressed("left"):
		states.handle_action(Actions.ADVANCE)
	if Input.is_action_pressed("right"):
		states.handle_action(Actions.RETREAT)
	if Input.is_action_just_pressed("up"):
		states.handle_action(Actions.SWORD_UP)
	if Input.is_action_just_pressed("down"):
		states.handle_action(Actions.SWORD_DOWN)
	if Input.is_action_just_pressed("attack"):
		states.handle_action(Actions.LUNGE)
