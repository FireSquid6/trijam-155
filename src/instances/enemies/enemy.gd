extends RigidBody2D


export var starting_force = 0

func _ready():
	# add starting force
	var x = rand_range(-1, 1)
	var y = rand_range(-1, 1)
	var dir = Vector2(x, y).normalized()
	
	add_central_force(dir * starting_force)
