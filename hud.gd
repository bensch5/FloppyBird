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


func show_game_over_menu():
	var new_highscores = insert_new_score(current_score)
	var score_table = "[center][table=2]"
	for key in new_highscores:
		var val = new_highscores[key]
		score_table = score_table + "[cell]{0}   [/cell]".format([key])
		score_table = score_table + "[cell]{0}[/cell]".format([val])
	score_table += "[/table][/center]"
	$GameOverMenu/Highscores.text = score_table
	$GameOverMenu/Score.text = "Score: %d" % current_score
	$GameOverMenu.show()
	

const SAVE_PATH = "user://highscores.save"


func insert_new_score(score):
	var highscores := load_highscores()
	highscores[Time.get_datetime_string_from_system()] = score
	save_highscores(highscores)
	return highscores


func load_highscores() -> Dictionary:
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	json.parse(file.get_line())
	file.close()
	return json.get_data() as Dictionary


func save_highscores(highscores: Dictionary):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(highscores))
