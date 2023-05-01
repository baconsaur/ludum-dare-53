class_name Player
extends Knight


func spawn(pos):
	.spawn(pos)
	can_be_damaged = true
	suspend_actions = true

func _process(delta):
	._process(delta)
	if is_defeated or (opponent and opponent.is_defeated) or suspend_actions:
		return

	var action = null
	if Input.is_action_pressed("left"):
		action = Actions.ADVANCE
	elif Input.is_action_pressed("right"):
		action = Actions.RETREAT
	elif Input.is_action_just_pressed("up"):
		action = Actions.SWORD_UP
	elif Input.is_action_just_pressed("down"):
		action = Actions.SWORD_DOWN
	elif Input.is_action_just_pressed("attack"):
		action = Actions.LUNGE
	elif Input.is_action_just_pressed("block"):
		action = Actions.BLOCK

	if action != null:
		emit_signal("action", action)
		states.handle_action(action)
