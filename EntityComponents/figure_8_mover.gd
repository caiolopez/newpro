class_name Figure8Mover extends Node

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var parent: Node2D = get_parent()
@export var width: float = 100.0  ## Width of the figure-8
@export var height: float = 50.0  ## Height of the figure-8
@export var speed: float = 2.0    ## Speed of the motion
@export var infinity_simbol: bool = false  ## If true, makes a vertical 8 instead of infinity symbol
@export var seeded_random_start: bool = true  ## If true, randomizes the starting period of the motion

var original_position: Vector2

var time: float = 0.0
var is_moving: bool = true

func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(_on_died)
		dmg_taker.restored.connect(_on_restored)
	Events.hero_respawned_at_checkpoint.connect(_reset_behavior)

	original_position = get_parent().position
	_randomize_time()

func _process(delta: float):
	if is_moving:
		time += delta * speed
		var x: float
		var y: float
		if infinity_simbol:
			x = width * sin(time)
			y = height * sin(time * 2)
		else:
			x = width * sin(time * 2)
			y = height * sin(time)
		parent.position = original_position + Vector2(x, y)

func _stop_movement():
	is_moving = false

func _reset_behavior():
	_stop_movement()	
	get_parent().position = original_position
	time = 0.0
	_randomize_time()
	is_moving = true
	parent.reset_physics_interpolation()

func _on_died():
	_stop_movement()

func _on_restored():
	_reset_behavior()

func _randomize_time():
	if seeded_random_start:
		var hashed = hash(parent.name)
		time = fposmod(float(hashed), TAU)
