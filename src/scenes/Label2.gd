extends Label


func _ready():
	text = "Your score was: " + str(Global.score)
