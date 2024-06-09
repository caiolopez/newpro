class_name Walker extends Area2D

@export var SPEED: float = 600
@export var GRAVITY: float = 2000
@export var FAST_FALL_GRAVITY: float = 3000
@export var MAX_FALL_VEL_Y: float = 2000.0
@export var ACCEL: float = 1000
@export var DECEL: float = 1000
@export var JUMP_VELOCITY: float = -1000
@export var ACTIVATION_RADIUS: float = 800.0
@export var MININUM_DIST_FROM_TARGET: float = 400.0
@export var DEAD_ZONE: float = 100.0
@export var avoids_pits: bool = true
@export var stunnable: bool = true
@export var climbs_walls: bool = false
@export var CLIMBING_SPEED: float = 600.0
@export var faces_hero: bool = true
@export_group("Jumping")
@export var jumps_at_walls: bool = false
@export var jumps_bullets: bool = true
@export var jumps_to_grab_target: bool = false
@export var jump_to_grab_window: Vector2 = Vector2(100.0, 400.0)
@export_group("Water")
@export var sinks_on_water: bool = false
@export var BUOYANCY: float = 100.0
@export var UNDERWATER_GRAVITY: float = 500
@export var MAX_DESCENT_VEL_Y: float = 300
@export var ASCENDING_VELOCITY: float = -300.0
@export_group("")
@onready var target_entity: Node2D = null
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var parent: CharacterBody2D = get_parent()
@onready var parent_og_global_pos: Vector2 = get_parent().global_position
var is_in_water: bool = false
var last_water_surface: float
var facing_direction_node: Node2D
var movement_direction: int
var pit_rc: RayCast2D
var pit_rc_og_pos: Vector2
var is_stunned: bool = false


func _ready():
	find_pit_rc()

	if parent.has_node("FacingDirection"):
		facing_direction_node = parent.get_node("FacingDirection")

	if "walker_target" in parent:
		target_entity = parent.walker_target
	if not get_tree().get_nodes_in_group("heroes").is_empty()\
	and not target_entity:
		target_entity = get_tree().get_nodes_in_group("heroes")[0]
	state_machine.start()

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.suffered.connect(on_suffered)
		dmg_taker.resurrected.connect(on_resurrected)

	area_entered.connect(on_area_entered)
	$TimerStun.timeout.connect(func(): is_stunned = false)


func on_died():
	state_machine.set_state("WStateDead")


func on_suffered():
	if stunnable:
		is_stunned = true
		$TimerStun.start()


func on_resurrected():
	parent.global_position = parent_og_global_pos
	state_machine.set_state("WStateIdle")


func step_grav(delta, downward_accel: float = GRAVITY):
	if not parent.is_on_floor():
		parent.velocity.y += downward_accel * delta
		parent.velocity.y = minf(parent.velocity.y, MAX_FALL_VEL_Y)


func step_lateral_mov(delta: float, force_forward: bool = true):
	var move: bool = false
	var dir_changed: bool
	var target_distance = target_entity.global_position.x - parent.global_position.x

	if abs(target_distance) < ACTIVATION_RADIUS\
	and not is_stunned:
		if abs(target_distance) > MININUM_DIST_FROM_TARGET + DEAD_ZONE:
			move = true
			if target_distance < 0:
				dir_changed = movement_direction == 1
				movement_direction = -1
			else:
				dir_changed = movement_direction == -1
				movement_direction = 1
		elif abs(target_distance) < MININUM_DIST_FROM_TARGET:
			move = true
			if target_distance > 0:
				dir_changed = movement_direction == 1
				movement_direction = -1
			else:
				dir_changed = movement_direction == -1
				movement_direction = 1

	if force_forward and move:
		parent.velocity.x += ACCEL * movement_direction * delta
	else:
		if abs(parent.velocity.x) > 0:
			parent.velocity.x -= DECEL * movement_direction * delta
			if sign(parent.velocity.x) != movement_direction:
				parent.velocity.x = 0

	parent.velocity.x = minf(abs(parent.velocity.x), SPEED) * movement_direction
	update_pit_rc_pos()

	if dir_changed and facing_direction_node:
		if not facing_direction_node.face_hero:
			facing_direction_node.update.emit(movement_direction)


func distance_from_target() -> float:
	var d = target_entity.global_position
	return d.distance_to(parent.global_position)


func is_target_within_grab_jump_window() -> bool:
	var diff = Utils.subtract_vector2(target_entity.global_position, parent.global_position)
	var x = abs(diff.x) < jump_to_grab_window.x
	var y = abs(diff.y) < jump_to_grab_window.y
	return x and y


func is_target_within_activation_radius() -> bool:
	var d = distance_from_target()
	if d <= ACTIVATION_RADIUS: return true
	else: return false


func find_pit_rc():
	if parent.has_node("PitRC"):
		pit_rc = get_parent().get_node("PitRC")
		pit_rc_og_pos = pit_rc.position
	elif avoids_pits:
		push_error("The avoid_pits behavior requires a RayCast2D named PitRC as the entity's child.")


func update_pit_rc_pos():
	if pit_rc:
		pit_rc.position.x = movement_direction * pit_rc_og_pos.x


func on_area_entered(area):
	if jumps_bullets\
	and area is Bullet\
	and "jump_prone" in state_machine.current_state\
	and parent.is_on_floor():
		state_machine.set_state("WStateJumpingBullet")
