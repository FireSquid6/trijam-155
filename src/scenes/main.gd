extends Node2D

onready var difficulty = 1

var rng = RandomNumberGenerator.new()
var max_difficulty
var spawnpoints = []
var enemy_list = [preload("res://instances/enemies/heptagon.tscn"), 
	preload("res://instances/enemies/hexagon.tscn"),
	preload("res://instances/enemies/triangle.tscn")]
onready var TimeLeftLabel = get_node("TimeLeft")
onready var ScoreLabel = get_node("Score")

func _ready():
	# start the timer
	$Timer.start()
	
	# set score to 0
	Global.score = 0
	
	# get all of the spawnpoint positions
	rng.randomize()
	max_difficulty = $Spawnpoints.get_child_count()
	var children = $Spawnpoints.get_children()
	
	for child in children:
		spawnpoints.append(child.position)


func _process(delta):
	# start new wave if enemies are all dead
	if Global.enemies_alive == 0:
		start_wave(difficulty, spawnpoints)
		difficulty += 1
	
	# update labels
	ScoreLabel.text = "Score: " + str(Global.score)
	TimeLeftLabel.text = "Time Left: " + str(round($Timer.time_left))


func start_wave(difficulty, points = []):
	points.shuffle()
	Global.enemies_alive = 0
	
	for i in range(0, difficulty):
		var enemy = enemy_list[rng.randi_range(0, 2)].instance()
		$Enemies.add_child(enemy)
		
		enemy.position = points[i]
		Global.enemies_alive += 1


func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/game_over.tscn")
