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
@export var lerp_speed: Vector2 = Vector2(0.1, 0.1) ## The main smoothing factor. The lag before the camera starts to follow the Hero.
@export var lerp_lerp_speed: Vector2 = Vector2(0.01,0.01) ## How fast will the camera catch up with the Hero's speed.
@export var catch_up_vel: Vector2 = Vector2(200,10) ## The minimum velocity the body has to move for framing compensation to kick in and attempt to center it to screen.
@export var lookahead_activation_vel: Vector2 = Vector2(10,0) ## The minimum body velocity that activates the lookahead behavior. NOTE: Hard-coded to not work going up.
@export var lookahead_amount: Vector2 = Vector2(50,50) ## The distance the camera frames in advance when performing lookahead.
var current_lerp_speed: Vector2
var current_lookahead: Vector2
var target: Vector2
var hero_last_velocity: Vector2
var shake_amount: float = 0
var shake_duration: float = 0


func _ready():
	state_machine.start()
	Events.hero_entered_camera_locker.connect(lock_camera)
	Events.hero_exited_camera_locker.connect(unlock_camera)
	
	Events.camera_shake.connect(shake)
	Events.camera_stop_shake.connect(stop_shake)

func _process(delta):
	# debug
	get_node('TargetMarker').global_position = target
	if get_node('TargetMarker').global_position.distance_squared_to(get_node('CameraMarker').global_position) < 10:
		get_node('TargetMarker').modulate = Color(1,0,0,1)
	else: get_node('TargetMarker').modulate = Color(1,1,1,1)

func lock_camera(origin, axes: Constants.Axes, lock_position: Vector2, ) -> void:
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

func is_hero_just_reduced_velocity(threshold, axes: Constants.Axes) -> bool:
	var is_breaking = false
	if axes == Constants.Axes.x:
		is_breaking = abs(hero_last_velocity.x) > abs(hero.velocity.x) + threshold
	if axes == Constants.Axes.y:	
		is_breaking = abs(hero_last_velocity.y) > abs(hero.velocity.y) + threshold
	hero_last_velocity = Vector2(hero.velocity.x, hero.velocity.y)
	print(is_breaking)
	return is_breaking


func step_shake(delta, current_pos: Vector2):
	if shake_duration > 0:
		shake_duration -= delta
		position = current_pos + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		if shake_duration <= 0:
			shake_duration = 0
			position = current_pos


func shake(duration: float = 0.2, amount: float = 10):
	shake_amount = amount
	shake_duration = duration


func stop_shake():
	shake_duration = 0
