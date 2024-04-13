extends CanvasLayer

var current_score: int


# Called when the node enters the scene tree for the first time.
func _ready():
	current_score = 0
	SignalBus.player_passed_pipe.connect(
		func ():
			current_score += 1	
			$ScoreCounter.text = str(current_score)
			print("current score: ", current_score)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

const SAVE_PATH = "user://highscores.save"


func insert_new_score(score):
	var highscores := load_highscores()
	highscores[Time.get_datetime_string_from_system()] = score
	save_highscores(highscores)


func load_highscores() -> Dictionary:
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	file.close()
	return json.get_data() as Dictionary


func save_highscores(highscores: Dictionary):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(highscores))

