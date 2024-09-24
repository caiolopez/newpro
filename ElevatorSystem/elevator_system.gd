class_name ElevatorSystem extends Node

## Usage: Requires ElevatorButtons as children.

enum Property {position, rotation}
enum State {ORIGIN, DESTINATION, MOVING_TO_ORIGIN, MOVING_TO_DESTINATION}

@export var elevator_node: Node2D = null ## The Node2D that will be tweened, aka the actual elevator
@export var property_to_tween: Property = Property.position
@export var end_position: Vector2 ## This value will be added to initial position
@export var end_rotation: float ## This value will be added to initial rotation
@export var curve: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var easing: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var savable: bool = false ## If true and reached end, will save its status upon checkpoint. Note: will not save state if hasn't gone all the way to end.
@export_range(0.001, 200) var duration: float = 5.0
@onready var starting_position: Vector2 = elevator_node.position if elevator_node else Vector2.ZERO
@onready var starting_rotation: float = elevator_node.rotation if elevator_node else 0.0
var elevator_button_list: Array[ElevatorButton] = []
var current_state: State = State.ORIGIN
var tween: Tween
var _is_saved: bool = false

signal tween_ended
signal was_reset

func _ready():
	Events.hero_reached_checkpoint.connect(_commit_status)
	Events.hero_respawned_at_checkpoint.connect(_reset_status)
	for child in get_children():
		if child is ElevatorButton:
			elevator_button_list.append(child)

func tween_to_start():
	_tween_to(starting_position, starting_rotation)
	current_state = State.MOVING_TO_ORIGIN

func tween_to_end():
	_tween_to(starting_position + end_position, starting_rotation + end_rotation)
	current_state = State.MOVING_TO_DESTINATION

func _set_to_end():
	if tween and tween.is_running():
		tween.stop()
	elevator_node.position = starting_position + end_position
	elevator_node.rotation = starting_rotation + end_rotation
	current_state = State.DESTINATION

func _tween_to(pos: Vector2, rot: float):
	var d = (elevator_node.position.distance_to(pos) / starting_position.distance_to(starting_position + end_position)) * duration
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	if property_to_tween == Property.position:
		tween.parallel().tween_property(elevator_node, "position", pos, d).set_trans(curve).set_ease(easing)
	elif property_to_tween == Property.rotation:
		tween.tween_property(elevator_node, "rotation_degrees", rot, d).set_trans(curve).set_ease(easing)
	tween.tween_callback(func():
		tween_ended.emit()
		current_state = State.ORIGIN if elevator_node.position.is_equal_approx(starting_position) else State.DESTINATION
	)

func _set_to_start():
	if tween and tween.is_running():
		tween.stop()
	elevator_node.position = starting_position
	elevator_node.rotation = starting_rotation
	current_state = State.ORIGIN

func _reset_status() -> void:
	if _is_saved: _set_to_end()
	else: _set_to_start()
	was_reset.emit()

func _commit_status() -> void:
	if not savable: return
	if current_state in [State.DESTINATION, State.MOVING_TO_ORIGIN]:
		_is_saved = true
		SaveManager.log_entity_change(self, &"elevator_at_destination")

func force_loaded_state() -> void:
	_is_saved = true
	_reset_status()

func send_elevator_to(where: StringName):
	if elevator_node == null:
		push_warning("No elevator is linked to ", self.name, ". Nothing will happen.")
		return
	if where == &"origin":
		tween_to_start()
	else:
		tween_to_end()
