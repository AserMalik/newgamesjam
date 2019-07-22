extends KinematicBody2D

export (int) var speed = 200
export (float) var rotation_speed = 1.5

var player_weight = 10
var velocity = Vector2(0,0)

var item_inventory = [0,1,2]
var item_weight = [1,2,3]

var rotation_dir = 0
var onPress_rotation_dir = 0

func get_items_weight():
	var sum = 0;
	for i in range(0,item_inventory.size()):
		sum += item_weight[i]
	return sum

var momentumX = (player_weight+get_items_weight())*velocity[0] #at start of action, player and items share velocity
var momentumY = (player_weight+get_items_weight())*velocity[1] #use these to calc new speed

var final_momentumX = 0;
var final_momentumY = 0;


func get_input():
	rotation_dir = 0
	velocity = Vector2()
	
	if Input.is_action_pressed('right'):
		rotation_dir += 1
		print (rotation)
	if Input.is_action_pressed('left'):
		rotation_dir -= 1
		print (rotation)
	#if Input.is_action_pressed('down'):
		#velocity = Vector2(0, speed).rotated(rotation)
	if Input.is_action_just_pressed('main_action'):
		item_inventory.pop_front() #throw item
		onPress_rotation_dir = rotation
		
		# velocity[0] = find the thrown objects x and y velocity first, then plug into equation
		velocity = Vector2(0, -speed).rotated(onPress_rotation_dir)
	if Input.is_action_just_released("main_action"):

		print (get_items_weight())

func _physics_process(delta):
    get_input()
    rotation += rotation_dir * rotation_speed * delta
    velocity = move_and_collide(velocity)