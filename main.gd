extends Node2D

@export var player_scene: PackedScene
@export var pipe_scene: PackedScene
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !game_started and Input.is_action_pressed("start_game"):
		new_game()

func new_game():
	game_started = true
	var player = player_scene.instantiate()
	# player.game_over.connect(_on_game_over.bind(player))
	player.start($StartPosition.position)
	add_child(player)
	
	for i in range(4):
		var pipe = pipe_scene.instantiate()
		randomize()
		var x_offset = i*500 + DisplayServer.window_get_size().x
		var position = Vector2(x_offset, randf_range(500, 900))
		pipe.start(position)
		add_child(pipe)


func _on_game_over():
	print("test")
