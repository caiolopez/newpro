class_name CycleMover extends Node

@export var rotation_angle: float = 0
@export var rotation_time: float = 0
@export var rotation_loop: bool = true
@export var rotation_boomerang: bool = false
@export var translation_distance: Vector2 = Vector2.ZERO
@export var translation_time: float = 0
@export var translation_loop: bool = true
@export var translation_boomerang: bool = false
var original_angle: float
var original_position: Vector2
var dmg_taker: DmgTaker
var rot_tween: Tween
var trans_tween: Tween

func _ready():
	Events.respawned_at_checkpoint.connect(reset_movement)
	dmg_taker = Utils.find_dmg_taker(self.get_parent())
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
		trans_tween = create_tween()
		trans_tween.tween_property(get_parent(),
		"position",
		original_position + translation_distance,
		translation_time).from_current()
		if translation_boomerang:
			trans_tween.tween_property(get_parent(),
			"position",
			original_position,
			translation_time)
		if translation_loop: trans_tween.set_loops()

func _process(delta):
	print(get_parent().rotation_degrees)
	if dmg_taker != null:
		if dmg_taker.current_hp == 0: stop_movement()


func stop_movement():
	if rot_tween and rot_tween.is_running():
		rot_tween.stop()
	if trans_tween and trans_tween.is_running():
		trans_tween.stop()


func reset_movement():
	stop_movement()
	get_parent().rotation_degrees = original_angle
	if rot_tween: rot_tween.play()
	
	get_parent().position = original_position
	if trans_tween: trans_tween.play()
