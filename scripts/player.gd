extends KinematicBody2D

enum STATES {
	MOVING,
	JUMPING,
	FALLING,
	DASHING
}


onready var velocity = Vector2(0,0)
onready var accspd = 5 * Global.spd_modifier
onready var deaccspd = 5  * Global.spd_modifier
onready var maxspd = 250 * Global.spd_modifier
onready var myspd = 0

onready var can_dash = true
onready var dash_cooldown = 3
onready var dash_time = 1

onready var can_jump = false
onready var jumping = false
onready var jump_time = 1.5
onready var jump_spd = 40


func _physics_process(delta):
	# HORIZONTAL MOVEMENT
	# get the horizontal input
	var move = int(Input.is_action_pressed("plr_move_right")) - int(Input.is_action_pressed("plr_move_left"))
	
	# if moving, accelerate
	if move != 0:
		velocity.x += accspd * move
		
		# decelerate to max spd
		if $Timers/DashTime.time_left == 0 and abs(velocity.x) > maxspd:
			velocity.x -= deaccspd * sign(velocity.x)
		
		# handle dashing
		if Input.is_action_pressed("plr_boost") && can_dash:
			on_dash()
			velocity.x = maxspd * move
		
	# decelerate if not moving
	else:
		# check if velocity needs to snap to 0
		if abs(velocity.x) <= deaccspd:
			velocity.x = 0
		#otherwise just subtract deacceleration speed
		else:
			velocity.x -= deaccspd * sign(velocity.x)
	
	
	# VERTICAL MOVEMENT
	# check if on floor
	var on_floor = $FloorDetector.is_colliding()
	
	
	# start jump if on floor and pressed
	if on_floor and Input.is_action_just_pressed("plr_jump"):
		on_jump()
	# if already jumping
	elif jumping:
		if !Input.is_action_just_pressed("plr_jump"):
			$Timers/JumpTime.time_left = 0
	# if not on the floor, just fall
	elif !on_floor:
		velocity.y += Global.GRAVITY
	
	# move and get new velocity
	velocity = move_and_slide(velocity)


# sets can dash to be true
func _on_DashTimer_timeout():
	can_dash = true


# called whenever dashing happens
func on_dash():
	$Timers/DashCooldown.wait_time = dash_cooldown
	$Timers/DashCooldown.start()
	$Timers/DashTime.wait_time = dash_time
	$Timers/DashTime.start()
	can_dash = false


# called whenever the player jumps
func on_jump():
	jumping = true
	can_jump = false
	
	$Timers/JumpTime.time_left = jump_time
	$Timers/JumpTime.start()


func _on_JumpTime_timeout():
	jumping = false
