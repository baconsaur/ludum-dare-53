class_name Lunge
extends BaseState

var done = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_lunge")

func handle_action(action):
	if action == Knight.Actions.HIT:
		done = true
		return state_map["Hit"]

func enter():
	done = false
	.enter()
	knight.lunge()
	if knight.opponent and knight.opponent.states.current_state is Stunned:
		knight.opponent.handle_hit(knight, "legs" if knight.sword_position == Knight.SwordPositions.DOWN else "torso")

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state
	
	if done:
		return state_map["Idle"]

func complete_lunge(anim_name):
	if done:
		return

	if "lunge" in anim_name:
		done = true
		knight.complete_lunge()
