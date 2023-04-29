extends BaseState

var done = false
var success = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_test")

func handle_action(action):
	return

func enter():
	done = false
	.enter()
	success = run_test()

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
	
	if not done:
		return

	if success:
		return state_map["Lunge"]

	knight.fail_lunge()
	return state_map["Knockback"]

func run_test():
	if knight.opponent and knight.sword_position == knight.opponent.sword_position:
		return false

	for body in knight.test_sword.get_overlapping_bodies():
		if body.is_in_group("Knight"):
			return false
	return true

func complete_test(_anim_name):
	done = true
