class_name Defeat
extends BaseState

var defeat_time = 1
var done = false


func enter():
	knight.shader_animator.play("default")
	.enter()
	defeat_time = 1
	done = false

func handle_action(_action):
	return

func process(delta):
	if done:
		return
	if defeat_time > 0:
		defeat_time -= delta
		return
		
	done = true
	knight.emit_signal("defeated")
	return state_map["Exit"]
