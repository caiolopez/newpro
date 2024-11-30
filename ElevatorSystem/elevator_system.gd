class_name ElevatorSystem extends Node

## Usage: Requires ElevatorButtons as children.

enum State {ORIGIN, DESTINATION, MOVING_TO_ORIGIN, MOVING_TO_DESTINATION}

@export var elevator_node: Node2D = null ## The Node2D that will be moved, aka the actual elevator
@export var end_position: Vector2 ## This value will be added to initial position
@export var max_speed: float = 100.0 ## Maximum speed of the elevator
@export var acceleration: float = 100.0 ## Acceleration rate
@export var deceleration: float = 100.0 ## Deceleration rate
@export var savable: bool = false ## If true and reached end, will save its status upon checkpoint. Note: will not save state if hasn't gone all the way to end.
@export_category("Audio")
@export var start_sfx: StringName = &""
@export var start_sfx_volume_adjustment: float = 0.0
@export var stop_sfx: StringName = &""
@export var stop_sfx_volume_adjustment: float = 0.0
@export var set_pitch_to_speed: bool = true ## Causes an optional AudioEmiter attached to Elevator Node to change its pitch with motion, simulating an engine sound.
@onready var starting_position: Vector2 = elevator_node.position if elevator_node else Vector2.ZERO
var audio_emiter: AudioEmiter = null
var elevator_button_list: Array[ElevatorButton] = []
var current_state: State = State.ORIGIN
var current_velocity: Vector2 = Vector2.ZERO
var target_position: Vector2
var is_moving: bool = false
var _is_saved: bool = false

func _ready():
	if elevator_node:
		for child in elevator_node.get_children():
			if child is AudioEmiter:
				audio_emiter = child
				break

	Events.hero_reached_checkpoint.connect(_commit_status)
	Events.hero_respawned_at_checkpoint.connect(_reset_status)

	for child in get_children():
		if child is ElevatorButton: 
			elevator_button_list.append(child)

	if elevator_node:
		for child in elevator_node.get_children():
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
		_sfx_start()
		if distance_to_target < current_velocity.length() * current_velocity.length() / (2 * deceleration):
			current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration * delta)
		else:
			current_velocity = current_velocity.move_toward(direction * max_speed, acceleration * delta)

		var movement = current_velocity * delta
		if movement.length() > distance_to_target:
			movement = direction * distance_to_target
		elevator_node.position += movement

		if current_state == State.MOVING_TO_ORIGIN:
			current_state = State.MOVING_TO_ORIGIN
		elif current_state == State.MOVING_TO_DESTINATION:
			current_state = State.MOVING_TO_DESTINATION
	else:
		if current_velocity.length() > 0:
			AppManager.camera.shake(0.1, 10)
			_sfx_stop()
		elevator_node.position = target_position
		current_velocity = Vector2.ZERO
		if current_state == State.MOVING_TO_ORIGIN:
			current_state = State.ORIGIN
		elif current_state == State.MOVING_TO_DESTINATION:
			current_state = State.DESTINATION
		_set_all_buttons_to_inactive()

	_step_sfx_pitch()

func move_to_start():
	target_position = starting_position
	current_state = State.MOVING_TO_ORIGIN

func move_to_end():
	target_position = starting_position + end_position
	current_state = State.MOVING_TO_DESTINATION

func _set_to_end():
	elevator_node.position = starting_position + end_position
	current_state = State.DESTINATION

func _set_to_start():
	elevator_node.position = starting_position
	current_state = State.ORIGIN

func _reset_status() -> void:
	if _is_saved: _set_to_end()
	else: _set_to_start()
	_set_all_buttons_to_inactive()
	current_velocity = Vector2.ZERO
	is_moving = false
	if audio_emiter:
		audio_emiter.deactivate()

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

func _sfx_start():
	if not is_moving:
		is_moving = true
		if start_sfx: AudioManager.play_sfx(start_sfx, start_sfx_volume_adjustment)
		if audio_emiter: audio_emiter.activate()

func _sfx_stop():
	if is_moving:
		is_moving = false
		if stop_sfx: AudioManager.play_sfx(stop_sfx, stop_sfx_volume_adjustment)
		if audio_emiter: audio_emiter.deactivate()

func _step_sfx_pitch():
	if set_pitch_to_speed\
	and audio_emiter\
	and audio_emiter.currently_active\
	and current_state in [State.MOVING_TO_ORIGIN, State.MOVING_TO_DESTINATION]:
		var normalized_pitch = lerp(0.15, 1.0, current_velocity.length() / max_speed)
		AudioManager.update_positional_sfx_pitch(audio_emiter, normalized_pitch)
