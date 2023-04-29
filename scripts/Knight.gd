class_name Knight
extends KinematicBody2D

enum Actions {
	ADVANCE,
	RETREAT,
	LUNGE,
	SWORD_UP,
	SWORD_DOWN,
	HIT,
	DEFEATED,
}

enum SwordPositions {
	UP,
	DOWN,
}

export var lunge_cooldown = 2
export var up_idle_position = Vector2(9, -2)
export var down_idle_position = Vector2(9, 7)
export var up_lunge_position = Vector2(14, -3)
export var down_lunge_position = Vector2(14, 9)

var sword_position = SwordPositions.UP
var position_map = {
	SwordPositions.UP: "up",
	SwordPositions.DOWN: "down",
}
var velocity = Vector2.ZERO
var lunge_countdown = 0
var torso_stripped = false
var legs_stripped = false

onready var states = $StateMachine
onready var sprite = $AnimatedSprite
onready var debug_label = $Label
onready var sword_collider = $Sword

func _ready():
	states.init(self)

func _process(delta):
	if lunge_countdown > 0:
		lunge_countdown -= delta
	debug_label.text = states.current_state.name + " " + get_sword_position()

func _physics_process(delta):
	states.process(delta)

func get_sword_position():
	return position_map[sword_position]

func sword_up():
	sword_position = SwordPositions.UP
	sword_collider.position = up_idle_position

func sword_down():
	sword_position = SwordPositions.DOWN
	sword_collider.position = down_idle_position

func lunge():
	if sword_position == SwordPositions.UP:
		sword_collider.position = up_lunge_position
	elif sword_position == SwordPositions.DOWN:
		sword_collider.position = down_lunge_position
	lunge_countdown = lunge_cooldown

func complete_lunge():
	if sword_position == SwordPositions.UP:
		sword_collider.position = up_idle_position
	elif sword_position == SwordPositions.DOWN:
		sword_collider.position = down_idle_position

func take_hit():
	if torso_stripped and legs_stripped:
		defeat()
	else:
		states.handle_action(Actions.HIT)

func defeat():
	# TODO
	queue_free()

func _on_Torso_body_entered(body):
	if torso_stripped or body == self:
		return

	torso_stripped = true
	take_hit()

func _on_Legs_body_entered(body):
	if legs_stripped or body == self:
		return

	legs_stripped = true
	take_hit()
