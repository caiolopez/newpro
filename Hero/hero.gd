extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
var facing_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_state

func _ready():
	state_machine.start()

func _physics_process(delta):
	pass
