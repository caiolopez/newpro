class_name CycleMover extends Node

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
var rot_tween: Tween
var pos_tween: Tween


func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.restored.connect(on_restored)
	Events.hero_respawned_at_checkpoint.connect(reset_behavior)

	original_angle = get_parent().rotation_degrees
	original_position = get_parent().position

	if rotation_angle and rotation_time != 0.0:
		rot_tween = create_tween()
		rot_tween.tween_property(get_parent(),
		"rotation_degrees",
		original_angle + rotation_angle,
		rotation_time).from_current()
		if rotation_boomerang:
			rot_tween.tween_property(get_parent(),
			"rotation_degrees",
			original_angle,
			rotation_time)
		if rotation_loop: rot_tween.set_loops()

	if translation_time != 0 and translation_distance != Vector2.ZERO:
		pos_tween = create_tween()
		pos_tween.tween_property(get_parent(),
		"position",
		original_position + translation_distance,
		translation_time).from_current()
		if translation_boomerang:
			pos_tween.tween_property(get_parent(),
			"position",
			original_position,
			translation_time)
		if translation_loop: pos_tween.set_loops()


func stop_movement():
	if rot_tween and rot_tween.is_running():
		rot_tween.stop()
	if pos_tween and pos_tween.is_running():
		pos_tween.stop()


func reset_behavior():
	stop_movement()
	get_parent().rotation_degrees = original_angle
	if rot_tween: rot_tween.play()
	
	get_parent().position = original_position
	get_parent().parent.reset_physics_interpolation()
	if pos_tween: pos_tween.play()


func on_died():
	stop_movement()


func on_restored():
	reset_behavior()
