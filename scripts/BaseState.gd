class_name BaseState
extends Node

export var animation_name: String

var state_map = {}
var knight: Knight


func enter():
	play_animation()

func handle_action(action):
	if action == Knight.Actions.HIT:
		return state_map["Hit"]

	if action == Knight.Actions.SWORD_UP:
		knight.sword_up()
		play_animation()
	elif action == Knight.Actions.SWORD_DOWN:
		knight.sword_down()
		play_animation()

func process(_delta):
	return

func exit():
	pass

func play_animation():
	knight.sprite.play(animation_name + "_" + knight.get_sword_position())
