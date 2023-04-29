class_name BaseState
extends Node

export var animation_name: String

var state_map = {}
var knight: Knight


func enter():
	knight.sprite.play(animation_name)

func handle_input(_event):
	return

func process(_delta):
	return

func physics_process(_delta):
	return

func exit():
	pass
