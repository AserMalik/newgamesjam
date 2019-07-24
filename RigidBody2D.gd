extends KinematicBody2D

export (float) var rotation_speed = 1.5
export (int) var scale_factor = 5

var player_weight = 10
var velocity = Vector2(0,0)
var r_velocity = Vector2(0,0)

var item_inventory = [0,6,1,2,3,4,5]
var item_weight = [5,5,10,15,20,25,30]

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

func items_pop_front():
		item_inventory.pop_front()
		item_weight.pop_front()

func calc_new_momentum():
		momentumX = (player_weight+get_items_weight())*velocity[0]
		momentumY = (player_weight+get_items_weight())*velocity[1]

func set_item_speed(power):
	item_thrown_speed = power

func calc_item_thrown_vector_components():
	item_thrown_angleX = sin(onPress_rotation_dir)*(-1)
	item_thrown_angleY = cos(onPress_rotation_dir)
	

func get_input():
	rotation_dir = 0
	if velocity == null:
		velocity = r_velocity

	if Input.is_action_pressed('right'):
		rotation_dir += 0.5
		print (rotation)

	if Input.is_action_pressed('left'):
		rotation_dir -= 0.5
		print (rotation)

	if Input.is_action_just_pressed('main_action'):
		onPress_rotation_dir = rotation
		set_item_speed(25) #placeholder, final should have speed scale with time button held
		calc_item_thrown_vector_components()

		print ("pre: ", velocity[0], " ", velocity[1])
		print ("item popped: ", item_inventory[0], " ", item_weight[0])

		velocity[0] = (momentumX - (item_weight[0]*item_thrown_angleX*scale_factor))/(player_weight+get_items_weight()-item_weight[0])
		velocity[1] = (momentumY - (item_weight[0]*item_thrown_angleY*scale_factor))/(player_weight+get_items_weight()-item_weight[0])

		items_pop_front()
		calc_new_momentum()
		print ("post: ", velocity[0], " ", velocity[1])
		velocity = Vector2(velocity[0], velocity[1])
		r_velocity = velocity
	#if Input.is_action_just_released("main_action"):
		#print (get_items_weight())

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta * 2
	velocity = move_and_collide(velocity)