class_name Hit
extends Move

var done = false


func init(_knight, _state_map):
	.init(_knight, _state_map)
	knight.anim_player.connect("animation_finished", self, "complete_hit")

func enter():
	knight.anim_player.play("hit_up" if knight.last_hit == "legs" else "hit_down")
	done = false
	knight.can_be_damaged = false
	knight.shader_animator.play("invulnerable")
	if knight.test_move(knight.get_transform(), Vector2(velocity * 2, 0)):
		knight.velocity.x = velocity

func handle_action(action):
	return

func process(delta):
	knight.velocity.x = move_toward(knight.velocity.x, 0, friction)

	knight.velocity = knight.move_and_slide(knight.velocity, Vector2.UP)

	if done and knight.velocity.is_equal_approx(Vector2.ZERO):
		if knight.is_defeated:
			return state_map["Defeat"]
		return state_map["Idle"]

func complete_hit(anim_name):
	if not "hit_" in anim_name:
		return
		
	done = true
	if "_up" in anim_name:
		knight.pants.hide()
	elif "_down" in anim_name:
		knight.shirt.hide()

func exit():
	.exit()
	knight.can_be_damaged = true
	knight.shader_animator.play("default")
