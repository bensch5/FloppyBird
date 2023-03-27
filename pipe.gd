extends StaticBody2D

@export var movement_speed = 300


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * movement_speed

func start(pos):
	position = pos


func _on_visible_on_screen_notifier_2d_screen_exited():
	position.x += DisplayServer.window_get_size().x + 400 #$Sprite.get_rect().size.x
	randomize()
	position.y = randf_range(500, 900)
