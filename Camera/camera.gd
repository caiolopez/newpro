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

@export var hero: Node2D ## What body will the camera follow, primarely. E.g. The main character.
@export var state_machine: StateMachine ## The state machine that governs this camera controller. Drag-and-drop the state-machine object to this field.
@export var lerp_ratio: Vector2 = Vector2(0.1,0.1) ## The main smoothing factor.
@export var catch_up_vel: Vector2 = Vector2(200,10) ## The minimum velocity the body has to move for framing compensation to kick in and attempt to center it to screen.
@export var lookahead_activation_vel: Vector2 = Vector2(10,0) ## The minimum body velocity that activates the lookahead behavior.
@export var lookahead_amount: Vector2 = Vector2(50,50) ## The distance the camera frames in advance when performing lookahead.
var current_lerp_ratio: Vector2
var current_lookahead: Vector2
var target: Vector2


func _ready():
	state_machine.start() # starts state machine

func _process(delta):
	# debug
	get_node('CameraMarker').global_position = target

func lock_camera(origin, axes: Constants.Axes, lock_position: Vector2, reset_lerp: bool) -> void:
	lockers.append(Locker.new(origin, axes, lock_position, reset_lerp))

func unlock_camera(origin, axes: Constants.Axes, reset_lerp: bool) -> void:
	for locker in lockers:
		if locker.origin.get_instance_id() == origin.get_instance_id():
			lockers.erase(locker)
	
func lerp_vector2(v1: Vector2, v2: Vector2, ratio: Vector2) -> Vector2:
	return Vector2(
		lerp(v1.x, v2.x, ratio.x),
		lerp(v1.y, v2.y, ratio.y)
	)
	
