
extends KinematicBody2D

var is_playing_animation = false

func _ready():
	pass
	
func destroy():
	get_node("../player").destroy_all_bullets()
	