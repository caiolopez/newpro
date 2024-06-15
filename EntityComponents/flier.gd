class_name Flier extends Node2D

@export var SPEED: float = 800
@export var ACCEL: float = 1000
@export var DECEL: float = 1000
@export var ACTIVATION_RADIUS: float = 1600.0
@export var MIN_DIST_FROM_TARGET: float = 800.0
@export var DEAD_ZONE: float = 200.0
@onready var target_entity: Node2D = null
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var parent: Node2D = get_parent()
@onready var parent_og_global_pos: Vector2 = get_parent().global_position
var velocity: Vector2 = Vector2.ZERO
var currently_dead: bool = false
var parent_has_move_and_slide: bool = false
var inertia_only: bool = false ## If true, parent entity will stop adding velocity towards target entity, and will only be subjected to deceleration.


func _ready():
	if "target" in parent:
		target_entity = parent.target
	if not get_tree().get_nodes_in_group("heroes").is_empty()\
	and not target_entity:
		target_entity = get_tree().get_nodes_in_group("heroes")[0]

	if parent.has_method("move_and_slide"):
		parent_has_move_and_slide = true

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)
	
	Events.respawned_at_checkpoint.connect(reset_behavior)


func _physics_process(delta):
	if not currently_dead:
		step_lateral_mov(delta)


func on_died():
	currently_dead = true


func on_resurrected():
	reset_behavior()


func reset_behavior():
	currently_dead = false
	parent.global_position = parent_og_global_pos


func step_lateral_mov(delta: float):
	var move: bool = false
	var move_dir: Vector2 = Vector2.ZERO
	var target_distance = target_entity.global_position - Vector2(global_position.x, global_position.y - 128)

	if is_target_within_activation_radius():
		if target_distance.length() > MIN_DIST_FROM_TARGET + DEAD_ZONE:
			move = true
			move_dir = target_distance.normalized()
		elif target_distance.length() < MIN_DIST_FROM_TARGET:
			move = true
			move_dir = -target_distance.normalized()

	if move\
	and not inertia_only:
		velocity += ACCEL * move_dir * delta
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * DECEL * delta
			if velocity.length() < DECEL * delta:
				velocity = Vector2()

	if velocity.length() > SPEED:
		velocity = velocity.normalized() * SPEED

	if parent_has_move_and_slide:
		parent.velocity = velocity
		parent.move_and_slide()
	else:
		parent.global_position += velocity * delta

func distance_from_target() -> float:
	var d = target_entity.global_position
	return d.distance_to(global_position)


func is_target_within_activation_radius() -> bool:
	var d = distance_from_target()
	if d <= ACTIVATION_RADIUS: return true
	else: return false
