class_name GeoCrawler extends Node2D

@export var SPEED: float = 400
@export var clockwise: bool = true
@export var stunnable: bool = true
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var parent: Node2D = get_parent()
@onready var parent_og_global_pos: Vector2 = get_parent().global_position
var is_stunned: bool = false
var face_hero_node: FaceHero
var velocity: Vector2
var was_col: bool = false
var diff: Vector2
var rot: float = 90
var currently_dead: bool = false


func _ready():
	global_position = parent.global_position
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.suffered.connect(on_suffered)
		dmg_taker.resurrected.connect(on_resurrected)
	
	
	if get_parent().has_node("FaceHero"):
		face_hero_node = get_parent().get_node("FaceHero")
	
	
	velocity = Vector2(SPEED, 0.0)
	setup_movement()

	$DownRC.force_raycast_update()
	$FrontRC.force_raycast_update()
	
	Events.hero_respawned_at_checkpoint.connect(reset_behavior)

func update_direction():
	var changed: bool
	changed = was_col != $DownRC.is_colliding()
	was_col = $DownRC.is_colliding()
	if not changed:
		return

	if not $DownRC.is_colliding():
		self.rotation_degrees += rot
		velocity = velocity.rotated(deg_to_rad(rot))

		if $FrontRC.is_colliding():
			diff = to_local($FrontRC.get_collision_point())\
				- Vector2($FrontRC.position.y, -$FrontRC.position.x)\
				* (1 if clockwise else -1)
			move_local_y(diff.y)
	
	if face_hero_node:
		if not face_hero_node.face_hero:
			face_hero_node.update.emit((1 if clockwise else -1), rotation)
	


func setup_movement():
	if clockwise: return
	velocity = Vector2(velocity.x * -1, 0.0)
	$DownRC.position.x *= -1
	$FrontRC.position.x *= -1
	$FrontRC.target_position.x *= -1
	rot *= -1


func _physics_process(delta):
	if not $TimerStun.is_stopped() or currently_dead:
		return
	update_direction()
	global_position += velocity * delta
	parent.global_position = global_position


func on_died():
	currently_dead = true


func on_suffered(_hp):
	if stunnable:
		is_stunned = true
		$TimerStun.start()


func on_resurrected():
	reset_behavior()


func reset_behavior():
	currently_dead = false
	rotation = 0
	velocity = Vector2(SPEED, 0.0)
	face_hero_node.update.emit((1 if clockwise else -1), 0)
	global_position = parent_og_global_pos
