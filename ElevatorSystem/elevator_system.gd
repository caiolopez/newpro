class_name ElevatorSystem extends Node

## Usage: Requires ElevatorButtons as children.

enum State {ORIGIN, DESTINATION, MOVING_TO_ORIGIN, MOVING_TO_DESTINATION}

@export var elevator_node: Node2D = null ## The Node2D that will be moved, aka the actual elevator
@export var end_position: Vector2 ## This value will be added to initial position
@export var max_speed: float = 100.0 ## Maximum speed of the elevator
@export var acceleration: float = 50.0 ## Acceleration rate
@export var deceleration: float = 100.0 ## Deceleration rate
@export var savable: bool = false ## If true and reached end, will save its status upon checkpoint. Note: will not save state if hasn't gone all the way to end.
@onready var starting_position: Vector2 = elevator_node.position if elevator_node else Vector2.ZERO
var elevator_button_list: Array[ElevatorButton] = []
var current_state: State = State.ORIGIN
var current_velocity: float = 0.0
var target_position: Vector2
var _is_saved: bool = false

func _ready():
	Events.hero_reached_checkpoint.connect(_commit_status)
	Events.hero_respawned_at_checkpoint.connect(_reset_status)
	for child in get_children():
		if child is ElevatorButton: 
			elevator_button_list.append(child)
	if elevator_node and elevator_node is Water:
		elevator_node.is_movable = true
	target_position = starting_position

func _physics_process(delta):
	if elevator_node == null or current_state in [State.ORIGIN, State.DESTINATION]:
		return
	
	var direction = (target_position - elevator_node.position).normalized()
	var distance_to_target = elevator_node.position.distance_to(target_position)

	if distance_to_target > 0.1:
		if distance_to_target < current_velocity * current_velocity / (2 * deceleration):
			current_velocity = max(current_velocity - deceleration * delta, 0)
		else:
			current_velocity = min(current_velocity + acceleration * delta, max_speed)

		elevator_node.position += direction * current_velocity * delta

		if current_state == State.MOVING_TO_ORIGIN:
			current_state = State.MOVING_TO_ORIGIN
		elif current_state == State.MOVING_TO_DESTINATION:
			current_state = State.MOVING_TO_DESTINATION
	else:
		elevator_node.position = target_position
		current_velocity = 0
		if current_state == State.MOVING_TO_ORIGIN:
			current_state = State.ORIGIN
		elif current_state == State.MOVING_TO_DESTINATION:
			current_state = State.DESTINATION
		_set_all_buttons_to_inactive()

func move_to_start():
	target_position = starting_position
	current_state = State.MOVING_TO_ORIGIN

func move_to_end():
	target_position = starting_position + end_position
	current_state = State.MOVING_TO_DESTINATION

func _set_to_end():
	elevator_node.position = starting_position + end_position
	current_state = State.DESTINATION
	current_velocity = 0

func _set_to_start():
	elevator_node.position = starting_position
	current_state = State.ORIGIN
	current_velocity = 0

func _reset_status() -> void:
	if _is_saved: _set_to_end()
	else: _set_to_start()
	_set_all_buttons_to_inactive()

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
		move_to_start()
		_toggle_all_buttons_of_type(ElevatorButton.button_type.ORIGIN)
	else:
		move_to_end()
		_toggle_all_buttons_of_type(ElevatorButton.button_type.DESTINATION)
	
func _toggle_all_buttons_of_type(button_type: ElevatorButton.button_type, toggle: bool = true):
	for button in elevator_button_list:
			if button.type == button_type:
				button.set_active()
			elif toggle:
				button.set_inactive()

func _set_all_buttons_to_inactive():
	for button in elevator_button_list:
		button.set_inactive()
