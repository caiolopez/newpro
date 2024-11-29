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
var gfx_controller_node: GfxController = null
var is_in_water: bool = false
var last_water_surface: float
var face_hero_node: FaceHero
var movement_direction: int = 1
var pit_rc: RayCast2D
var pit_rc_og_pos: Vector2
var is_stunned: bool = false

func _ready():
	find_pit_rc()

	if get_parent().has_node("FaceHero"):
		face_hero_node = get_parent().get_node("FaceHero")

	for child in get_parent().get_children():
		if child is GfxController:
			gfx_controller_node = child
			break

	if "target" in parent:
		target_entity = parent.target
	else:
		if AppManager.hero:
			target_entity = AppManager.hero
		else:
			AppManager.hero_ready.connect(func():
				target_entity = AppManager.hero
				)
	
	state_machine.start()

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.suffered.connect(on_suffered)
		dmg_taker.restored.connect(on_restored)

	area_entered.connect(on_area_entered)
	$TimerStun.timeout.connect(func(): is_stunned = false)

func reset_behavior():
	parent.global_position = parent_og_global_pos
	state_machine.set_state("WStateIdle")

func on_died():
	state_machine.set_state("WStateDead")

func on_suffered(_hp):
	if stunnable:
		is_stunned = true
		$TimerStun.start()

func on_restored():
	reset_behavior()

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

	if gfx_controller_node:
		gfx_controller_node.update_direction(movement_direction)
		if parent.get_real_velocity().x == 0:
			gfx_controller_node.set_movement_halted(true)
		else:
			gfx_controller_node.set_movement_halted(false)
			
	if dir_changed and face_hero_node:
		if not face_hero_node.face_hero:
			face_hero_node.update.emit(movement_direction)

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
	and not area.is_foe\
	and "jump_prone" in state_machine.current_state\
	and parent.is_on_floor():
		state_machine.set_state("WStateJumpingBullet")

func on_water_status_changed(_is_in_water: bool, water: Water):
	self.is_in_water = _is_in_water
	last_water_surface = water.get_surface_global_position()
