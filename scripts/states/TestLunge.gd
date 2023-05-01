extends BaseState

var done = false
var success = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_test")

func handle_action(action):
	if action == Knight.Actions.HIT:
		return state_map["Hit"]

	if action == Knight.Actions.STUN:
		return state_map["Stunned"]

func enter():
	done = false
	knight.lunge_countdown = knight.lunge_cooldown
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
	if not knight.opponent:
		return false
	
	if knight.opponent.states.current_state is Stunned:
		return true
	
	if knight.sword_position == knight.opponent.sword_position:
		return false

	for body in knight.test_sword.get_overlapping_bodies():
		if body.is_in_group("Knight"):
			return false
	return true

func complete_test(_anim_name):
	done = true

func exit():
	knight.shader_animator.play("default")
	.exit()
