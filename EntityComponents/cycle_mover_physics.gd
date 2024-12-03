class_name CycleMoverPhysics extends Node

@export var rotation_angle: float = 0
@export var rotation_time: float = 0
@export var rotation_loop: bool = true
@export var rotation_boomerang: bool = false
@export var translation_distance: Vector2 = Vector2.ZERO
@export var translation_time: float = 0
@export var translation_loop: bool = true
@export var translation_boomerang: bool = false

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

var original_angle: float
var original_position: Vector2
var is_moving: bool = true

# Movement tracking variables
var rot_elapsed: float = 0
var pos_elapsed: float = 0
var rot_direction: int = 1
var pos_direction: int = 1

func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.restored.connect(on_restored)
	Events.hero_respawned_at_checkpoint.connect(reset_behavior)

	original_angle = get_parent().rotation_degrees
	original_position = get_parent().position

func _physics_process(delta):
	if not is_moving:
		return
		
	if rotation_time > 0:
		handle_rotation(delta)
	
	if translation_time > 0:
		handle_translation(delta)

func handle_rotation(delta):
	rot_elapsed += delta
	
	if rot_elapsed >= rotation_time:
		if rotation_boomerang:
			rot_direction *= -1
		elif rotation_loop:
			rot_elapsed = 0
		else:
			rot_elapsed = rotation_time
			
		if not rotation_loop and not rotation_boomerang:
			return
	
	var progress = rot_elapsed / rotation_time
	if rotation_boomerang:
		progress = min(progress, 1.0)
	
	var target_rotation = original_angle + (rotation_angle * progress * rot_direction)
	get_parent().rotation_degrees = target_rotation

func handle_translation(delta):
	pos_elapsed += delta
	
	if pos_elapsed >= translation_time:
		if translation_boomerang:
			pos_direction *= -1
		elif translation_loop:
			pos_elapsed = 0
		else:
			pos_elapsed = translation_time
			
		if not translation_loop and not translation_boomerang:
			return
	
	var progress = pos_elapsed / translation_time
	if translation_boomerang:
		progress = min(progress, 1.0)
	
	var current_offset = translation_distance * progress * pos_direction
	get_parent().position = original_position + current_offset

func stop_movement():
	is_moving = false

func reset_behavior():
	is_moving = true
	rot_elapsed = 0
	pos_elapsed = 0
	rot_direction = 1
	pos_direction = 1
	get_parent().rotation_degrees = original_angle
	get_parent().position = original_position
	get_parent().reset_physics_interpolation()

func on_died():
	stop_movement()

func on_restored():
	reset_behavior()
