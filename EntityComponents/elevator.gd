class_name Elevator extends Node

enum Property {position, rotation}
enum State {ORIGIN, DESTINATION, MOVING_TO_ORIGIN, MOVING_TO_DESTINATION}

@export var property_to_tween: Property = Property.position
@export var end_position: Vector2 ## This value will be added to initial position
@export var end_rotation: float ## This value will be added to initial rotation
@export var curve: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var easing: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export_range(0.001, 200) var duration: float = 5.0
@onready var starting_position: Vector2 = get_parent().position
@onready var starting_rotation: float = get_parent().rotation
var current_state: State = State.ORIGIN
var tween: Tween
var is_saved: bool = false

signal tween_ended
signal was_reset

func _ready():
	Events.hero_reached_checkpoint.connect(commit_status)
	Events.hero_respawned_at_checkpoint.connect(reset_status)

func tween_to_start():
	tween_to(starting_position, starting_rotation)
	current_state = State.MOVING_TO_ORIGIN

func tween_to_end():
	tween_to(starting_position + end_position, starting_rotation + end_rotation)
	current_state = State.MOVING_TO_DESTINATION

func set_to_end():
	if tween and tween.is_running():
		tween.stop()
	get_parent().position = starting_position + end_position
	get_parent().rotation = starting_rotation + end_rotation
	current_state = State.DESTINATION

func tween_to(pos: Vector2, rot: float):
	var d = (get_parent().position.distance_to(pos) / starting_position.distance_to(starting_position + end_position)) * duration
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	if property_to_tween == Property.position:
		tween.parallel().tween_property(get_parent(), "position", pos, d).set_trans(curve).set_ease(easing)
	elif property_to_tween == Property.rotation:
		tween.tween_property(get_parent(), "rotation_degrees", rot, d).set_trans(curve).set_ease(easing)
	tween.tween_callback(func():
		tween_ended.emit()
		current_state = State.ORIGIN if get_parent().position.is_equal_approx(starting_position) else State.DESTINATION
	)

func set_to_start():
	if tween and tween.is_running():
		tween.stop()
	get_parent().position = starting_position
	get_parent().rotation = starting_rotation
	current_state = State.ORIGIN

func reset_status() -> void:
	if is_saved: set_to_end()
	else: set_to_start()
	was_reset.emit()

func commit_status() -> void:
	if current_state in [State.DESTINATION, State.MOVING_TO_ORIGIN]:
		is_saved = true
		SaveManager.log_entity_change(self, &"elevator_at_destination")

func force_loaded_state() -> void:
	is_saved = true
	reset_status()
