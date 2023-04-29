extends BaseState

var done = false

func handle_action(action):
	return

func enter():
	done = false
	.enter()
	knight.sprite.connect("animation_finished", self, "complete_lunge", [], CONNECT_ONESHOT)
	knight.lunge()

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
	
	if done:
		return state_map["Idle"]

func complete_lunge():
	done = true
	knight.complete_lunge()
