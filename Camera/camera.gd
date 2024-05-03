extends Camera2D

class Locker:
	var origin
	var axes: Constants.Axes
	var lock_position: Vector2

	func _init(_origin, _axes: Constants.Axes, _lock_position: Vector2):
		origin = _origin
		axes = _axes
		lock_position = _lock_position

var lockers: Array[Locker] = []

@export var hero: Node2D ## What body will the camera follow, primarely. E.g. The main character.
@export var state_machine: StateMachine ## The state machine that governs this camera controller. Drag-and-drop the state-machine object to this field.
@export var lookahead_activation_vel: Vector2 = Vector2(10,0) ## The minimum body velocity that activates the lookahead behavior.
@export var lookahead_amount: Vector2 = Vector2(50,50) ## The distance the camera frames in advance when performing lookahead.
var target: Vector2
var target_tween = create_tween()
var camera_tween = create_tween()

func _ready():
	pass

func _process(delta):
	# debug
	get_node('CameraMarker').global_position = target
	
		
	var hero_vel = hero.get_velocity()
	var hero_dir = hero.facing_direction
	var la_amount = lookahead_amount
	
	camera_tween.tween_property(self, "position:x", hero.position.x, 1.0)

	
func lock_camera(origin, axes: Constants.Axes, lock_position: Vector2) -> void:
	lockers.append(Locker.new(origin, axes, lock_position))

func unlock_camera(origin, axes: Constants.Axes) -> void:
	for locker in lockers:
		if locker.origin.get_instance_id() == origin.get_instance_id():
			lockers.erase(locker)
	
func lerp_vector2(v1: Vector2, v2: Vector2, ratio: Vector2) -> Vector2:
	return Vector2(
		lerp(v1.x, v2.x, ratio.x),
		lerp(v1.y, v2.y, ratio.y)
	)
	
