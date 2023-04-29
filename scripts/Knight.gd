class_name Knight
extends KinematicBody2D

signal defeated

enum Actions {
	ADVANCE,
	RETREAT,
	LUNGE,
	SWORD_UP,
	SWORD_DOWN,
	HIT,
	DEFEATED,
	KNOCKBACK,
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
var torso_stripped = false
var legs_stripped = false
var start_y = 0
var can_damage = false
var opponent = null

onready var states = $StateMachine
onready var sprite = $BodySprite
onready var debug_label = $Label
onready var test_sword = $SwordLunge/TestSword
onready var anim_player = $AnimationPlayer
onready var shirt = $Torso/Shirt
onready var pants = $Legs/Pants

onready var clash_sound = $ClashSound
onready var clink_sound = $ClinkSound
onready var slice_sound = $SliceSound

func _ready():
	start_y = position.y
	states.init(self)

func _process(delta):
	if position.y != start_y:
		position.y = start_y
	if lunge_countdown > 0:
		lunge_countdown -= delta
	debug_label.text = states.current_state.name + " " + get_sword_position()

func _physics_process(delta):
	states.process(delta)

func get_sword_position():
	return position_map[sword_position]

func sword_up():
	sword_position = SwordPositions.UP
#	sword_collider.position = up_idle_position

func sword_down():
	sword_position = SwordPositions.DOWN
#	sword_collider.position = down_idle_position

func lunge():
	can_damage = true
	lunge_countdown = lunge_cooldown

func complete_lunge():
	can_damage = false

func fail_lunge():
	if opponent:
		opponent.knock_back()
		if opponent.sword_position == sword_position:
			clash_sound.play()
		else:
			clink_sound.play()

func knock_back():
	states.handle_action(Actions.KNOCKBACK)

func defeat():
	states.handle_action(Actions.DEFEATED)

func _on_Torso_body_entered(body):
	if not body.is_in_group("Knight") or body == self or not body.can_damage:
		return
	states.handle_action(Actions.HIT)
	
	if torso_stripped:
		return

	shirt.play("damaged")
	slice_sound.play()
	torso_stripped = true
	if legs_stripped:
		defeat()

func _on_Legs_body_entered(body):
	if not body.is_in_group("Knight") or body == self or not body.can_damage:
		return
	states.handle_action(Actions.HIT)
	
	if legs_stripped:
		return

	pants.play("damaged")
	slice_sound.play()
	legs_stripped = true
	if torso_stripped:
		defeat()

func _on_PersonalBubble_area_entered(area):
	opponent = area.get_parent()

func _on_PersonalBubble_area_exited(area):
	opponent = null
