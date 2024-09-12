class_name StateMachine extends Node

@export var auto_start:bool = false
@export var does_print: bool = true

var states:Array[_State]
var current_state_index:int = -1
var current_state:_State:
	get:
		return states[current_state_index] if current_state_index >= 0 and current_state_index < states.size() else null
	set(value):
		var index:int = -1
		
		for i in states.size():
			var state = states[i]
			if state.get_instance_id() == value.get_instance_id():
				index = i
				break
		
		if index < 0: push_error("Trying to set state that doesn't belong to state machine")
		else: current_state_index = index
var last_state: _State = null

func _ready() -> void:
	get_states()
	if states.size() == 0: return push_error("_State Machine with no States")
	if auto_start: start()

func _process(delta):
	if current_state: current_state.process(delta)

func _physics_process(delta):
	if current_state: current_state.physics_process(delta)

func start() -> void:
	last_state = null
	set_state(states[0])

func start_if_stopped() -> void:
	if current_state == null:
		start()

func get_states() -> void:
	states = []
	for child in get_children().filter(func(entry): return entry is _State):
		states.append(child as _State)

func get_state_by_name(_name:String) -> _State:
	for state in states:
		if state.name == _name: return state
	
	return null

func set_state(state) -> void:
	if state == null:
		if current_state:
			last_state = current_state
			current_state.exit()
		return

	if state is _State:
		if current_state:
			last_state = current_state
			current_state.exit()
		current_state = state
		current_state.enter(self)
		return

	if state is String:
		set_state(get_state_by_name(state))
		return

func is_current_state(_name:StringName) -> bool:
	return current_state.name == _name
