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

@export var lerp_speed: Vector2 = Vector2(3.0, 3.0) ## The main smoothing factor. The lag before the camera starts to follow the Hero.
@export var catch_up_speed: Vector2 = Vector2(0.01, 0.01) ## How fast will the camera catch up with the Hero's speed.
@export var lookahead_activation_vel: Vector2 = Vector2(10,2000) ## The minimum body velocity that activates the lookahead behavior. NOTE: Hard-coded to not work going up.
@export var lookahead_amount: Vector2 = Vector2(200,200) ## The distance the camera frames in advance when performing lookahead.
@export var show_gizmo: bool = false ## When set to true, camera position and camera target position are drawn.
@onready var state_machine: StateMachine = $StateMachine
@onready var hero: Node2D = Utils.find_hero()
var current_lerp_speed: Vector2
var current_lookahead: Vector2
var target: Vector2
var hero_last_velocity: Vector2
var shake_amount: float = 0
var shake_duration: float = 0
var hero_real_vel: Vector2
var hero_vel: Vector2
var hero_dir: int
var la_timer: Timer
var last_hero_dir: int


func _ready():
	state_machine.start()
	Events.hero_entered_camera_locker.connect(lock_camera)
	Events.hero_exited_camera_locker.connect(unlock_camera)
	
	Events.camera_set_glpos.connect(func(glpos): global_position = glpos)
	Events.camera_shake.connect(shake)
	Events.camera_stop_shake.connect(stop_shake)


func _process(_delta):
	if show_gizmo:
		get_node("TargetMarker").visible = true
		get_node("TargetMarker").visible = true
		debug_gizmos()
	else:
		get_node("TargetMarker").visible = false
		get_node("CameraMarker").visible = false

	hero_real_vel = hero.get_real_velocity()
	hero_vel = hero.velocity
	hero_dir = hero.facing_direction


func lock_camera(origin, axes: Constants.Axes, lock_position: Vector2) -> void:
	lockers.append(Locker.new(origin, axes, lock_position))


func unlock_camera(origin, _axes: Constants.Axes) -> void:
	for locker in lockers:
		if locker.origin.get_instance_id() == origin.get_instance_id():
			lockers.erase(locker)

	if lockers.is_empty()\
	and state_machine.current_state.name == "CStateFollowLookaheadX":
		current_lookahead.x = 0
		state_machine.set_state("CStateFollowHero")


func lerp_vector2(v1: Vector2, v2: Vector2, speed: Vector2, delta: float) -> Vector2:
	return Vector2(
		lerp(v1.x, v2.x, Utils.dt_lerp(speed.x, delta)),
		lerp(v1.y, v2.y, Utils.dt_lerp(speed.y, delta))
	)


func is_hero_just_reduced_velocity(threshold, axes: Constants.Axes) -> bool:
	var is_breaking = false
	if axes == Constants.Axes.x:
		is_breaking = abs(hero_last_velocity.x) > abs(hero.velocity.x) + threshold
	if axes == Constants.Axes.y:	
		is_breaking = abs(hero_last_velocity.y) > abs(hero.velocity.y) + threshold
	hero_last_velocity = Vector2(hero.velocity.x, hero.velocity.y)
	return is_breaking


func step_shake(delta: float, current_pos: Vector2):
	if shake_duration > 0:
		shake_duration -= delta
		position = current_pos + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		if shake_duration <= 0:
			shake_duration = 0
			position = current_pos


func step_lookahead_y(delta: float):
	if hero_vel.y > 0:
		current_lookahead.y = lerp(0.0, lookahead_amount.y, minf(abs(hero_vel.y), lookahead_activation_vel.y) / lookahead_activation_vel.y)
	else: current_lookahead.y = lerp(current_lookahead.y, 0.0, clampf(10 * delta, 0, 1))


func shake(duration: float = 0.2, amount: float = 10):
	shake_amount = amount
	shake_duration = duration


func stop_shake():
	shake_duration = 0


func step_catch_up(delta: float):
	if abs(hero_real_vel.x) < lerp_speed.x\
	or last_hero_dir != hero_dir:
		current_lerp_speed.x = lerp_speed.x
	else: current_lerp_speed.x = lerp(current_lerp_speed.x, abs(hero_real_vel.x) * lerp_speed.x, Utils.dt_lerp(catch_up_speed.x, delta))

	if abs(hero_real_vel.y) < lerp_speed.y:
		current_lerp_speed.y = lerp_speed.y
	else: current_lerp_speed.y = lerp(current_lerp_speed.y, abs(hero_real_vel.y) * lerp_speed.y, Utils.dt_lerp(catch_up_speed.y, delta))
	last_hero_dir = hero_dir


func step_camera_lockers():
	for top_locker in lockers:
		if top_locker.axes == Constants.Axes.x:
			target.x = top_locker.lock_position.x 
			current_lerp_speed.x = lerp_speed.x
		elif top_locker.axes == Constants.Axes.y:
			target.y = top_locker.lock_position.y
			current_lerp_speed.y = lerp_speed.y
		elif top_locker.axes == Constants.Axes.both:
			target = top_locker.lock_position
			current_lerp_speed = lerp_speed


func step_camera_position(delta: float):
	target = hero.global_position + current_lookahead
	step_camera_lockers()
	position = lerp_vector2(position, target, current_lerp_speed, delta)


func debug_gizmos():
	get_node("TargetMarker").global_position = target
	if get_node("TargetMarker").global_position.distance_squared_to(get_node("CameraMarker").global_position) < 10:
		get_node("TargetMarker").modulate = Color(1,0,0,1)
	else: get_node("TargetMarker").modulate = Color(1,1,1,1)
		
