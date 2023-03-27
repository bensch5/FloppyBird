extends StaticBody2D

@export var game_speed = 300
var is_stopped = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_stopped:
		position.x -= delta * game_speed

func start(pos):
	position = pos


func _on_visible_on_screen_notifier_2d_screen_exited():
	position.x += DisplayServer.window_get_size().x + 400 #$Sprite.get_rect().size.x
	randomize()
	position.y = randf_range(500, 800)


func stop_game():
	is_stopped = true
	set_collision_layer_value(1, false)
