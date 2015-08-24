
extends KinematicBody2D

const CHANGE_DIR_TIME= 200 #milliseconds seconds
const WALK_SPEED = 10
var counter = 0
var velocity = Vector2(10,10)
var rand_dir
var purple_texture = preload("res://animation/person_purple.png")
var blue_texture = preload("res://animation/person_blue.png")
var yellow_texture = preload("res://animation/person_yellow.png")
var bunked_counter = 0;

func _ready():
	rand_dir = get_parent().get_node("bunker").get_global_pos()
	add_collision_exception_with(get_parent().get_node("player"))
	randomize_texture()
	set_process(true)
	
func _process(delta):
	counter += 1
	#print(get_viewport().get_mouse_pos())

	#if (counter == CHANGE_DIR_TIME):
		#rand_dir = get_random_direction()
		#print("RANDOM DIR: ", rand_dir)
		#print("PERSON POSITION: ", get_pos())
		#print(motion)
		#counter = 0
	
	if (rand_dir.x < get_pos().x):
		velocity.x = -WALK_SPEED
	else:
		velocity.x = WALK_SPEED
			
	if (rand_dir.y < get_pos().y):
		velocity.y = -WALK_SPEED
	else:
		velocity.y = WALK_SPEED
		
	var motion = velocity * delta
	motion = move(motion) 
	
	if (is_colliding() && get_collider().get_name() == "bunker"):
		get_collider().add_bunked()
		queue_free()
		
func get_random_direction():
	#get window height x width 
	randomize()
	var random_x = randi() % 800 #get_viewport_rect().size.x
	var random_y = randi() % 480 #get_viewport_rect().size.y
	return Vector2(random_x, random_y)
	
func randomize_texture():
	randomize()
	var random = randi() % 3
	if (random == 1):
		get_node("Sprite").set_texture(blue_texture)
	elif (random == 2):
		get_node("Sprite").set_texture(purple_texture)
	else:
		get_node("Sprite").set_texture(yellow_texture)
		