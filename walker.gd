class_name Walker extends Node

@export var SPEED: float = 200
@export var GRAVITY: float = 2000
@export var MAX_FALL_VEL_Y: float = 2000.0
@export var ACCEL: float = 300
@export var JUMP_VELOCITY: float = -1000
@export var MININUM_DIST_FROM_TARGET: float = 0.0 # TODO
@export var ACTIVATION_RADIUS: float = 800.0
@export var DEAD_ZONE: float = 10.0
@export var avoids_pits: bool = true # TODO
@export var climbs_walls: bool = false
@export var CLIMBING_SPEED: float = 600.0
@export var jumps_to_grab_target: bool = false
@export var jump_to_grab_window: Vector2 = Vector2(100.0, 400.0)
@export var jumps_at_walls: bool = false
@export var sinks_on_water: bool = true # TODO
@onready var target_entity: Node2D = null
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var parent: CharacterBody2D = get_parent()
var facing_direction: int


func _ready():
	if "walker_target" in parent:
		target_entity = parent.walker_target
	if not get_tree().get_nodes_in_group("heroes").is_empty()\
	and not target_entity:
		target_entity = get_tree().get_nodes_in_group("heroes")[0]
	state_machine.start()
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)


func on_died():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func on_resurrected():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("enabled", true)


func step_grav(delta, downward_accel: float = GRAVITY):
	if not parent.is_on_floor():
		parent.velocity.y += downward_accel * delta
		parent.velocity.y = minf(parent.velocity.y, MAX_FALL_VEL_Y)


func step_lateral_mov(delta):
	var dir_just_changed = false
	
	if target_entity.global_position.x < parent.global_position.x + targeting_offset():
		dir_just_changed = facing_direction == 1
		facing_direction = -1
	else:
		dir_just_changed = facing_direction == -1
		facing_direction = 1

	if dir_just_changed:
		parent.velocity.x = 0

	parent.velocity.x += ACCEL * facing_direction * delta
	parent.velocity.x = maxf(abs(parent.velocity.x), SPEED) * facing_direction


func targeting_offset() -> float:
	var offset: float = 0
	if "facing_direction" in target_entity:
		offset = 70 * -target_entity.facing_direction
	return offset


func distance_from_target() -> float:
	var d = target_entity.global_position
	return d.distance_to(parent.global_position)


func is_target_within_grab_jump_window() -> bool:
	var diff = Utils.subtract_vector2(target_entity.global_position, parent.global_position)
	var x = abs(diff.x) < jump_to_grab_window.x
	var y = abs(diff.y) < jump_to_grab_window.y
	return x and y


func is_target_within_activation_ring() -> bool:
	var d = distance_from_target()
	if d <= ACTIVATION_RADIUS\
	and d > DEAD_ZONE: return true
	else: return false


func is_target_within_activation_radius() -> bool:
	var d = distance_from_target()
	if d <= ACTIVATION_RADIUS: return true
	else: return false
