extends KinematicBody2D
 
var input_direction = 0
var direction = 0
 
var speed_x = 0
var speed_y = 0
var velocity = Vector2()
 
const MAX_SPEED = 700
const ACCELERATION = 2600
const DECELERATION = 5000

const JUMP_FORCE = 1000
const GRAVITY =2800
const MAX_FALL_SPEED = 1400

var jump_count = 0
const MAX_JUMP_COUNT = 2
 
func _ready():
    set_process(true)
    set_process_input(true)
 
 
func _input(event):
	if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("jump"):
		speed_y = -JUMP_FORCE
		jump_count += 1
 
 
func _process(delta):
    # INPUT
    if input_direction:
        direction = input_direction
        
   
    if Input.is_action_pressed("move_left"):
        input_direction = -1
    elif Input.is_action_pressed("move_right"):
        input_direction = 1
    else:
        input_direction = 0
   
    # MOVEMENT
    if input_direction == - direction:
        speed_x /= 3
    if input_direction:
        speed_x += ACCELERATION * delta
    else:
        speed_x -= DECELERATION * delta
    speed_x = clamp(speed_x, 0, MAX_SPEED)
   
    speed_y += GRAVITY * delta

    if speed_y > MAX_FALL_SPEED:
	    speed_y = MAX_FALL_SPEED
	

    velocity.x = speed_x * delta * direction
    velocity.y = speed_y * delta
    var movement_remainder = move(velocity)

    if is_colliding():
	    var normal = get_collision_normal()
	    var final_movement = normal.slide(movement_remainder)
	    speed_y = normal.slide(Vector2(0, speed_y)).y
	    move(final_movement)
		
	    if normal == Vector2(0, -1):
	    	jump_count = 0
		
	    print("colision")
