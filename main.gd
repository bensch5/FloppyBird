extends Node2D

enum GameState {
	STARTING_SCREEN,
	IN_GAME,
	GAME_OVER,
}

const Player = preload("uid://dwj8suudo4gky")
@export var player_scene: PackedScene
@export var pipe_scene: PackedScene
@export var game_speed = 300
var player
var pipe
var state: GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	state = GameState.STARTING_SCREEN
	player = player_scene.instantiate()
	player.game_over.connect(_on_game_over)
	player.start($StartPosition.position)
	add_child(player)

	$HUD/GameOverMenu/RestartButton.pressed.connect(
		func():
			if state == GameState.GAME_OVER:
				restart_game()
	)


func _process(delta):
	match state:
		GameState.STARTING_SCREEN:
			$HUD/TapToPlay.show()
			move_ground(delta)
			if Input.is_action_pressed("jump"): # Game starts with jump input.
				new_game()
		GameState.IN_GAME:
			game_speed += 0.2
			move_ground(delta)
		GameState.GAME_OVER:
			# TODO: check for input to restart
			pass

# Move ground to the left every frame to create the illusion of horizontal player movement.
func move_ground(delta):
	var move = delta * game_speed
	get_node("Boundary/GroundSprite").position.x -= move
	$VisibleOnScreenNotifier2D.position.x -= move


# Create a loop for the ground by moving the sprite to the right whenever the notifier exits the screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	var move = 1632
	get_node("Boundary/GroundSprite").position.x += move
	$VisibleOnScreenNotifier2D.position.x += move


func new_game():
	state = GameState.IN_GAME
	player.state = GameState.IN_GAME
	$HUD/TapToPlay.hide()
	$HUD/ScoreCounter.show()
	
	# spawn in pipes
	for i in range(4):
		pipe = pipe_scene.instantiate()
		player.game_over.connect(pipe.stop_game)
		randomize()
		var x_offset = i*500 + DisplayServer.window_get_size().x + 400
		var pos = Vector2(x_offset, randf_range(500, 800))
		pipe.start(pos)
		add_child(pipe)


func restart_game():
	get_tree().reload_current_scene()


func _on_game_over():
	if state != GameState.GAME_OVER:
		state = GameState.GAME_OVER
		$HUD/ScoreCounter.hide()
		player.state = GameState.GAME_OVER
		$HUD.show_game_over_menu()
