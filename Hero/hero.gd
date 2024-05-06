extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var GLIDE_VELOCITY = 50.0
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
var facing_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_state

func _ready():
	state_machine.start()

func _physics_process(delta):
	pass

func step_grav(delta):
	if not is_on_floor(): velocity.y += gravity * delta
	
func step_lateral_mov(delta):
	if Input.is_action_pressed("move_left"):
		facing_direction = -1
		velocity.x = facing_direction * SPEED

	elif Input.is_action_pressed("move_right"):
		facing_direction = 1
		velocity.x = facing_direction * SPEED
		
	else: velocity.x = 0

func is_pushing_wall() -> bool:
	is_on_wall()
	return true
