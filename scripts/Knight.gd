class_name Knight
extends KinematicBody2D

var velocity = Vector2.ZERO
var gravity = 15

onready var states = $StateMachine
onready var sprite = $AnimatedSprite
onready var debug_label = $Label


func _ready():
	states.init(self)

func _process(delta):
	debug_label.text = states.current_state.name
	
func _physics_process(delta):
	states.physics_process(delta)

func _unhandled_key_input(event):
	states.handle_input(event)
