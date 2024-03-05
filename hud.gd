extends CanvasLayer

var current_score: int


# Called when the node enters the scene tree for the first time.
func _ready():
	current_score = 0
	SignalBus.player_passed_pipe.connect(
		func ():
			current_score += 1	
			$ScoreCounter.text = str(current_score)
			print($ScoreCounter)
			print("current score: ", current_score)
			print("ScoreCounter.text: ", $ScoreCounter.text)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
