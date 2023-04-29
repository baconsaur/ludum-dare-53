class_name Defeat
extends BaseState

var done = false


func enter():
	.enter()
	yield(get_tree().create_timer(1.0), "timeout")
	done = true

func process(_delta):
	if not done:
		return
	
	knight.emit_signal("defeated")
