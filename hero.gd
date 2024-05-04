extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var facing_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_state

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor(): velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed('jump') and is_on_floor(): velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released('jump') and velocity.y < 0: velocity.y = 0

	# Change hero facing direction and move
	if Input.is_action_pressed("move_left"):
		facing_direction = -1
		velocity.x = facing_direction * SPEED
	
	elif Input.is_action_pressed("move_right"):
		facing_direction = 1
		velocity.x = facing_direction * SPEED
		
	else: velocity.x = 0

	move_and_slide()
