class_name Knight
extends KinematicBody2D

signal defeated
signal big_hit
signal spawned
signal exited

enum Actions {
	ADVANCE,
	RETREAT,
	LUNGE,
	SWORD_UP,
	SWORD_DOWN,
	HIT,
	STUN,
	BLOCK,
	DEFEATED,
	KNOCKBACK,
	ENTER,
}

enum SwordPositions {
	UP,
	DOWN,
}

export var lunge_cooldown = 2

var sword_position = SwordPositions.UP
var position_map = {
	SwordPositions.UP: "up",
	SwordPositions.DOWN: "down",
}
var velocity = Vector2.ZERO
var lunge_countdown = 0
var strip_status = {
	"torso": false,
	"legs": false
}
var can_damage = false
var can_be_damaged = false
var opponent = null
var is_defeated = false
var is_spawned = false
var spawn_position
var suspend_actions = false
var exit_position = null
var last_hit = null

onready var states = $StateMachine
onready var sprite = $BodySprite
onready var debug_label = $Label
onready var test_sword = $SwordLunge/TestSword
onready var anim_player = $AnimationPlayer
onready var shirt = $BodySprite/Shirt
onready var pants = $BodySprite/Pants
onready var shader_animator = $BodySprite/ShaderAnimator

onready var clash_sound = $ClashSound
onready var clink_sound = $ClinkSound
onready var slice_sound = $SliceSound
onready var swish_sound = $SwishSound


func _process(delta):
	if position.y != spawn_position.y:
		position.y = spawn_position.y
	if lunge_countdown > 0:
		lunge_countdown -= delta
	debug_label.text = states.current_state.name + " " + get_sword_position()

func _physics_process(delta):
	states.process(delta)

func spawn(pos):
	spawn_position = pos
	randomize()
	states.init(self)

func get_sword_position():
	return position_map[sword_position]

func sword_up():
	sword_position = SwordPositions.UP

func sword_down():
	sword_position = SwordPositions.DOWN

func lunge():
	swish_sound.play()
	can_damage = true

func complete_lunge():
	can_damage = false

func fail_lunge():
	if opponent:
		opponent.knock_back()
		if opponent.sword_position == sword_position:
			clash_sound.play()
		else:
			clink_sound.play()

func take_counter():
	states.handle_action(Actions.STUN)

func big_hit():
	emit_signal("big_hit")

func knock_back():
	states.handle_action(Actions.KNOCKBACK)

func exit(pos):
	exit_position = pos

func _on_Torso_body_entered(body):
	handle_hit(body, "torso")

func _on_Legs_body_entered(body):
	handle_hit(body, "legs")

func handle_hit(body, part):
	last_hit = part
	
	if not body.is_in_group("Knight") or body == self or not body.can_damage or not can_be_damaged:
		return
	
	if not strip_status[part]:
		slice_sound.play()
		strip_status[part] = true

	if strip_status["torso"] and strip_status["legs"]:
		is_defeated = true

	states.handle_action(Actions.HIT)

func _on_PersonalBubble_area_entered(area):
	opponent = area.get_parent()

func _on_PersonalBubble_area_exited(area):
	opponent = null
