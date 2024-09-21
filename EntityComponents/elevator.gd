class_name Elevator extends Node

enum Property {position, rotation}

@export var property_to_tween: Property = Property.position
@export var end_position: Vector2 ## This value will be added to initial position
@export var end_rotation: float ## This value will be added to initial rotation
@export var curve: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var easing: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export_range(0.001, 200) var duration: float = 5.0
@onready var starting_position: Vector2 = get_parent().position
@onready var starting_rotation: float = get_parent().rotation
var tween: Tween
signal tween_ended

func _ready():
	Events.hero_respawned_at_checkpoint.connect(reset)

func tween_to_start():
	tween_to(starting_position, starting_rotation)

func tween_to_end():
	tween_to(starting_position + end_position, starting_rotation + end_rotation)

func set_to_end():
	if tween and tween.is_running():
		tween.stop()
	get_parent().position = end_position
	get_parent().rotation = end_rotation

func tween_to(pos: Vector2, rot: float):
	var d = (get_parent().position.distance_to(pos) / starting_position.distance_to( starting_position + end_position)) * duration
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	if property_to_tween == Property.position:
		tween.parallel().tween_property(get_parent(), "position", pos, d).set_trans(curve).set_ease(easing)
	elif property_to_tween == Property.rotation:
		tween.tween_property(get_parent(), "rotation_degrees", rot, d).set_trans(curve).set_ease(easing)
	tween.tween_callback(func():tween_ended.emit())

func reset():
	if tween and tween.is_running():
		tween.stop()
	get_parent().position = starting_position
	get_parent().rotation = starting_rotation
