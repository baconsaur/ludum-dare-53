class_name Lunge
extends BaseState

var done = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_lunge")

func handle_action(action):
	return

func enter():
	done = false
	.enter()
	knight.lunge()

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
	
	if done:
		return state_map["Idle"]

func complete_lunge(anim_name):
	if "lunge" in anim_name:
		done = true
		knight.complete_lunge()
