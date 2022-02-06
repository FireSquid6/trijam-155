extends RigidBody2D

const ACCELERATION = 400
const DECELERATION = 800
const MAX_FORCE = 1500
const FORCE_OFFSET_LENGTH = 5

onready var lastmouse = Vector2.ZERO

func _process(_delta):
	Global.player_ref = self


func _physics_process(delta):
	var mousepos = get_global_mouse_position()
	var dir = (mousepos - position).normalized()
	
	# apply forces
	if Input.is_action_pressed("plr_accelerate"):
		add_force(dir * FORCE_OFFSET_LENGTH, dir * ACCELERATION)
		
		var torque_force = (lastmouse - mousepos).length()
		add_torque(torque_force * 0.1)
	
	# clamp force
	applied_force = applied_force.clamped(MAX_FORCE)
	
	# get lastmouse
	lastmouse = mousepos
