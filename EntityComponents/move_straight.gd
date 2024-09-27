class_name MoveStraight extends Node2D

@export var SPEED: float = 800
@export var ACCEL: float = 100
@export var DECEL: float = 100
@export var ACTIVATION_RADIUS: float = 1600.0
@export var update_every_frame: bool = true
@export var static_target_pos: Vector2 ## A fixed global coordinate on the map. Note: Only if update_every_frame == false.
@onready var target_entity: Node2D = null
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var parent: Node2D = get_parent()
@onready var parent_og_global_pos: Vector2 = get_parent().global_position
var velocity: Vector2 = Vector2.ZERO
var static_self_pos: Vector2 = Vector2.ZERO
var currently_dead: bool = false
var PARENT_HAS_MOVE_AND_SLIDE: bool = false
var inertia_only: bool = false ## If true, parent entity will stop adding velocity towards target entity, and will only be subjected to deceleration.


func _ready():
	if "target" in parent:
		target_entity = parent.target
	else:
		target_entity = AppManager.hero

	if parent.has_method("move_and_slide"):
		PARENT_HAS_MOVE_AND_SLIDE = true

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)
	
	Events.hero_respawned_at_checkpoint.connect(reset_behavior)


func _physics_process(delta):
	if not currently_dead:
		step_mov(delta)


func on_died():
	currently_dead = true


func on_resurrected():
	reset_behavior()


func reset_behavior():
	velocity = Vector2.ZERO
	currently_dead = false
	parent.global_position = parent_og_global_pos
	inertia_only = false


func step_mov(delta: float):
	if not inertia_only:
		if update_every_frame:
			velocity += global_position.direction_to(target_entity.global_position) * ACCEL * delta
		else:
			velocity += static_self_pos.direction_to(static_target_pos) * ACCEL * delta
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * DECEL * delta
			if velocity.length() < DECEL * delta:
				velocity = Vector2.ZERO

	velocity = velocity.limit_length(SPEED)

	if PARENT_HAS_MOVE_AND_SLIDE:
		parent.velocity = velocity
		parent.move_and_slide()
	else: 
		parent.global_position += velocity * delta


func set_static_target_pos_to_curr_target_pos():
	velocity = Vector2.ZERO
	static_self_pos = global_position
	static_target_pos = target_entity.global_position
