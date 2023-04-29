class_name Hit
extends Move

var done = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_hit")

func enter():
	.enter()
	done = false
	knight.can_be_damaged = false

func process(delta):
	var new_state = .process(delta)
	if new_state:
		return new_state

	knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)

	if done and knight.velocity.is_equal_approx(Vector2.ZERO):
		return state_map["Idle"]

func complete_hit(anim_name):
	if "hit_" in anim_name:
		done = true

func exit():
	.exit()
	knight.can_be_damaged = true
