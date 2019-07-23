extends KinematicBody2D

export (int) var speed = 200
export (float) var rotation_speed = 1.5
export (int) var scale_factor = 5

var player_weight = 10
var velocity = Vector2(0,0)

var item_inventory = [0,1,2,3,4,5]
var item_weight = [5,10,15,20,25,30]

func get_items_weight():
	var sum = 0;
	for i in range(0,item_inventory.size()):
		sum += item_weight[i]
	return sum

var rotation_dir = 0
var onPress_rotation_dir = 0

var momentumX = (player_weight+get_items_weight())*velocity[0] #at start of action, player and items share velocity
var momentumY = (player_weight+get_items_weight())*velocity[1] #use these to calc new speed

var item_thrown_angleX = 0;
var item_thrown_angleY = 0;

var item_thrown_speed = 0;

func get_input():
	rotation_dir = 0
	
	if Input.is_action_pressed('right'):
		rotation_dir += 1
		print (rotation)
	if Input.is_action_pressed('left'):
		rotation_dir -= 1
		print (rotation)
	if Input.is_action_just_pressed('main_action'):
		onPress_rotation_dir = rotation

		item_thrown_speed = 25
		item_thrown_angleX = sin(rotation)*(-1)
		item_thrown_angleY = cos(rotation)*(-1)

		print ("pre: ", velocity[0], " ", velocity[1])
		print ("item popped: ", item_inventory[0], " ", item_weight[0])

		velocity[0] = (momentumX - (item_weight[0]*item_thrown_angleX*scale_factor))/player_weight
		velocity[1] = (momentumY - (item_weight[0]*item_thrown_angleY*scale_factor))/player_weight
		
		item_inventory.pop_front()
		item_weight.pop_front()
		
		print ("post: ", velocity[0], " ", velocity[1])

		velocity = Vector2(velocity[0], velocity[1]).rotated(onPress_rotation_dir)
	#if Input.is_action_just_released("main_action"):
		#print (get_items_weight())

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_collide(velocity)