extends Node2D

@export var player_scene: PackedScene
@export var pipe_scene: PackedScene

@export var game_speed = 300

enum GameState {
	STARTING_SCREEN,
	IN_GAME,
	GAME_OVER,
}

var player
var pipe
var state: GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	state = GameState.STARTING_SCREEN
	player = player_scene.instantiate()
	player.freeze = true
	player.game_over.connect(_on_game_over)
	player.start($StartPosition.position)
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GameState.STARTING_SCREEN:
			if Input.is_action_pressed("jump"): # Game starts with jump input.
				new_game()
		GameState.IN_GAME:
			# Move ground to the left every frame to create the illusion of horizontal player movement.
			var move = delta * game_speed
			get_node("Boundary/GroundSprite").position.x -= move
			$VisibleOnScreenNotifier2D.position.x -= move
		GameState.GAME_OVER:
			pass


# Create a loop for the ground by moving the sprite to the right whenever the notifier exits the screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	var move = 1632
	get_node("Boundary/GroundSprite").position.x += move
	$VisibleOnScreenNotifier2D.position.x += move


func new_game():
	state = GameState.IN_GAME
	player.freeze = false
	$HUD/TapToPlay.hide()
	$HUD/ScoreCounter.show()
	
	for i in range(4):
		pipe = pipe_scene.instantiate()
		player.game_over.connect(pipe.stop_game)
		randomize()
		var x_offset = i*500 + DisplayServer.window_get_size().x + 400
		var pos = Vector2(x_offset, randf_range(500, 800))
		pipe.start(pos)
		add_child(pipe)


func _on_game_over():
	state = GameState.GAME_OVER
	# show game over screen
