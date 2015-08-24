
extends KinematicBody2D

# member variables here, example:
var mouse_position
var is_animation_playing = false
const GRAVITY = 200.0
const WALK_SPEED = 200
var bullet = preload("res://scenes/bullet.xscn")
var velocity = Vector2()
var bullet_instance
var bullet_pos
var bullet_count = 0
var bullet_array = []
var current_target_location
var kill_counter = 0

func _ready():
	add_collision_exception_with(get_parent().get_node("bg/water"))
	add_collision_exception_with(get_parent().get_node("bg/wall_top"))
	add_collision_exception_with(get_parent().get_node("bg/bunker"))

	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	var motion = velocity * delta
	
	if (Input.is_action_pressed("ui_left")):
		velocity.x = - WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =   WALK_SPEED
	else:
		velocity.x = 0
		
	if (Input.is_action_pressed("ui_up")):
		velocity.y = - WALK_SPEED
	elif (Input.is_action_pressed("ui_down")):
		velocity.y =   WALK_SPEED
	else:
		velocity.y = 0

	var motion = velocity * delta
	motion = move( motion ) 
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide( motion ) 
		velocity = n.slide( velocity )
		move( motion )
	
	if (Input.is_action_pressed("ui_accept") && !is_animation_playing):
		current_target_location = get_node("target").get_global_pos().y
		is_animation_playing = true
		bullet_count+=1
		get_node("AnimatedSprite/AnimationPlayer").play("inking")

		bullet_instance = bullet.instance()
		bullet_instance.set_name("bullet_instance"+str(bullet_count))
		bullet_array.push_back(bullet_instance)
		bullet_pos = get_pos() + get_node("ink_shoot").get_pos()
		bullet_instance.set_pos(bullet_pos)
		get_parent().add_child(bullet_instance)
		bullet_instance.add_collision_exception_with(self)
		bullet_instance.add_collision_exception_with(get_parent().get_node("bg/water"))
		bullet_instance.add_collision_exception_with(get_parent().get_node("bg/wall_top"))
		bullet_instance.add_collision_exception_with(get_parent().get_node("bunker"))
		
	if (bullet_instance):
		var bullet_motion = Vector2(-20, 200) * delta
		bullet_motion = bullet_instance.move(bullet_motion)
		if (bullet_instance.is_colliding() && !bullet_instance.is_playing_animation):
			#print(get_node("target").get_global_pos())
			#print(bullet_instance.get_pos())
			bullet_instance.get_node("AnimatedSprite/AnimationPlayer").play("splatter")
			bullet_instance.is_playing_animation = true
	
		if (bullet_instance.is_colliding()): #&& get_collider().get_name().begins_with("person")):
			#print(get_collider())
			kill_counter += 1
			get_node("Label").set_text("Killed: " + str(kill_counter))
			bullet_instance.get_collider().queue_free()
		
		
		if (bullet_instance.get_pos().y > current_target_location):
			#print("BULLET POS: ", bullet_instance.get_pos(), "TARGET POS: ", get_node("target").get_global_pos())
			#print("SMALLER")
			#bullet_instance.get_node("AnimatedSprite/AnimationPlayer").play("splatter")
			destroy_all_bullets()
			
func free_space_bar():
	"""
	This function is used in the animation func track to access the track point ctrl+click
	"""
	is_animation_playing = false;

func destroy_all_bullets():
	for b in bullet_array:
		get_parent().remove_child(b)
	bullet_array.clear()