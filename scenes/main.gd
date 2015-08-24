
extends Node2D

var counter = 0
var human = preload("res://scenes/person_blue.xscn")
const AMOUNT_HUMANS = 50
var is_game_running = false

func _ready():	
	set_process_input(true)
	set_process(true)
	#get_node("human").set_process(false)
	#spawn_human(AMOUNT_HUMANS)
	
func _process(delta):
	if (!is_game_running):
		#get_tree().set_pause(true)
		set_process(false)
		
func _input(event):
	if  (event.is_action("ui_accept") && !is_game_running):
		is_game_running = true
		set_process(true)
		get_node("Title").hide()
		get_node("instructions").hide()
		spawn_human(AMOUNT_HUMANS)

func spawn_human(amount):
	while(counter != amount):
		var human_instance = human.instance()
		human_instance.set_scale(Vector2(0.25, 0.25))
		
		#human_instance.set_z(get_node("player").get_z() - 1)
		human_instance.set_pos(get_random_vector())
		add_child(human_instance)
		move_child(human_instance, 1)
		counter +=1
	
func get_random_vector():
	#get window height x width 
	randomize()
	var random_x = randi() % 800 #get_viewport_rect().size.x
	var random_y = randi() % 480 #get_viewport_rect().size.y
	return Vector2(random_x, random_y)