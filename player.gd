extends RigidBody2D

signal game_over

@export var jump_height = 1600
var rotat = PI/2
var is_jumping = false
var ctr = 0 # used for player movement during starting screen


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if player is in starting screen
	if freeze:
		ctr += 5
		$Sprite.position.y += sin(delta * ctr)/12
	else:
		$Sprite.position.y = 0
		if Input.is_action_just_pressed("jump"):
			handle_jump()
		rotate_sprite(delta)


func handle_jump():
	linear_velocity.y = 0
	apply_impulse(Vector2(0, -jump_height))
	is_jumping = true


func rotate_sprite(delta):
	if is_jumping and rotat > PI/4:
		rotat = max(PI/4, rotat - rotat * 10 * delta)
	else:
		is_jumping = false
		rotat = min(PI, rotat + rotat * 1.75 * delta)
	
	# Calculation of rotation is offset by PI/2 to not make the sign interfere with the calculation.
	# Needs to be adjusted here by subtracting PI/2.
	$Sprite.rotation = rotat - PI/2
	$Hitbox.rotation = rotat # No subtraction needed since the hitbox is already rotated in its default state.


func start(pos):
	position = pos


func _on_body_entered(_body):
	$Sprite.stop()
	game_over.emit()
