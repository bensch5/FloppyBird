extends CanvasLayer

const SAVE_PATH = "user://highscores.save"

var current_score: int
var current_time: String


# Called when the node enters the scene tree for the first time.
func _ready():
	current_score = 0
	SignalBus.player_passed_pipe.connect(
		func ():
			current_score += 1
			$ScoreCounter.text = str(current_score)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func show_game_over_menu():
	$ShadeRect.show()
	var new_highscores = insert_new_score(current_score)
	$GameOverMenu/Highscores.text = create_highscore_table(new_highscores)
	$GameOverMenu/Score.text = "Score: %d" % current_score
	$GameOverMenu.show()


func create_highscore_table(highscores):
	var score_table = "[center][table=3]"
	var pairs = []
	for key in highscores:
		pairs.append([key, highscores[key]])
	pairs.sort_custom(func (a, b): return a[1] > b[1])
	for pair in pairs.slice(0, 10):
		var time_string = create_time_string(pair[0]) 
		var score_string = pair[1]
		# turn current score green
		if pair[0] == current_time:
			var make_green = func(val): return "[color=green]{0}[/color]".format([val])
			time_string = make_green.call(time_string)
			score_string = make_green.call(score_string)
		score_table += "[cell]{0}[/cell][cell]\t\t[/cell][cell]{1}[/cell]".format([time_string, score_string])
	score_table += "[/table][/center]"
	return score_table


func create_time_string(time: String):
	var to_two_digits = func(s): return s if s.length() == 2 else "0" + s
	var dict = Time.get_datetime_dict_from_datetime_string(time, false)
	var day = to_two_digits.call(str(dict.day))
	var month = to_two_digits.call(str(dict.month))
	var year = str(dict.year).substr(2,4)
	var hour = to_two_digits.call(str(dict.hour))
	var minute = to_two_digits.call(str(dict.minute))
	return "{0}/{1}/{2} {3}:{4}".format([day, month, year, hour, minute])


func insert_new_score(score):
	var highscores := load_highscores()
	var time = Time.get_datetime_string_from_system()
	current_time = time
	highscores[time] = score
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
