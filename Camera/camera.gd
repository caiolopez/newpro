extends Camera2D

class Locker:
	var origin
	var axes: Constants.Axes
	var lock_position: Vector2
	var reset_lerp: bool

	func _init(_origin, _axes: Constants.Axes, _lock_position: Vector2, _reset_lerp: bool):
		origin = _origin
		axes = _axes
		lock_position = _lock_position
		reset_lerp = _reset_lerp

var lockers: Array[Locker] = []

@export var hero: Node2D
@export var state_machine: StateMachine
@export var lerp_ratio: Vector2
var current_lerp_ratio: Vector2
var current_lookahead: Vector2
var target: Vector2


func _ready():
	state_machine.start() # starts state machine
	
func lock_camera(origin, axes: Constants.Axes, lock_position: Vector2, reset_lerp: bool) -> void:
	lockers.append(Locker.new(origin, axes, lock_position, reset_lerp))

func unlock_camera(origin, axes: Constants.Axes, reset_lerp: bool) -> void:
	for locker in lockers:
		if locker.origin.get_instance_id() == origin.get_instance_id():
			lockers.erase(locker)
	
