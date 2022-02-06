extends RigidBody2D
class_name Enemy

export var starting_force = 0
export var max_health = 1

export var base_score = 100
export var bonus_multiplier = 100

onready var health = max_health

func _ready():
	# add starting force
	var x = rand_range(-1, 1)
	var y = rand_range(-1, 1)
	var dir = Vector2(x, y).normalized()
	
	add_central_force(dir * starting_force)


func _process(_delta):
	if health <= 0:
		Global.score += round(base_score + (bonus_multiplier * $BonusTimer.time_left))
		Global.enemies_alive -= 1
		print("New score is: " + str(Global.score))
		queue_free()

func _on_Enemy_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		health -= body.applied_force.length() * Global.DAMAGE_FACTOR
		print(str(self) + " Updated health: " + str(health))
	elif body.name == "Walls":
		applied_force = Vector2.ZERO
		var x = rand_range(-1, 1)
		var y = rand_range(-1, 1)
		var dir = Vector2(x, y).normalized()
		add_central_force(dir * rand_range(250, 600))
		
