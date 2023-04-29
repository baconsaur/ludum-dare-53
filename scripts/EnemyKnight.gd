extends Knight

export var move_interval = 1

var move_cooldown = move_interval


func _ready():
	._ready()
	randomize()

func _process(delta):
	._process(delta)
	
	if move_cooldown > 0:
		move_cooldown -= delta
		return
	
	var move_choices = [Actions.ADVANCE, Actions.RETREAT, Actions.SWORD_UP, Actions.SWORD_DOWN, Actions.LUNGE]

	states.handle_action(move_choices[randi() % len(move_choices)])
	move_cooldown = move_interval
