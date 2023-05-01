class_name Block
extends BaseState

var done = false
var can_counter = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_block")

func handle_action(action):
	if action == Knight.Actions.DEFEATED:
		return state_map["Defeat"]

	if action == Knight.Actions.HIT:
		return state_map["Hit"]
	
	if action == Knight.Actions.KNOCKBACK:
		knight.clash_sound.play()
		knight.clash_particles.emitting = true
		can_counter = true

func enter():
	can_counter = false
	done = false
	.enter()

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
	
	if can_counter:
		knight.opponent.take_counter()
		return state_map["TestLunge"]
	
	if done:
		return state_map["Idle"]

func complete_block(anim_name):
	if "block" in anim_name:
		done = true

func exit():
	.exit()
	knight.lunge_countdown = knight.lunge_cooldown / 2
