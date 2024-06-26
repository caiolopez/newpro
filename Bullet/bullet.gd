class_name Bullet extends Area2D

var is_foe: bool
var is_fire: bool
var DMG_AMOUNT: int = 1
var WATER_DRAG = 0.8
var AIR_DRAG = 0
var velocity: Vector2
var current_drag: float
var current_gravity: float
var acceleration: Vector2
var is_underwater_ammo: bool
var notifier: VisibleOnScreenNotifier2D


func _ready():
	notifier = $VisibleOnScreenNotifier2D
	current_drag = AIR_DRAG
	current_gravity = 0
	await get_tree().process_frame # TODO: Come up with a way to prevent those bullets from being instantiated instead.
	if not notifier.is_on_screen():
		BulletManager.free_bullet(self)


func _process(_delta):
	pass


func _physics_process(delta):
	var drag: Vector2
	drag = -velocity * current_drag
	acceleration = drag + current_gravity * Vector2.DOWN
	velocity += acceleration * delta
	global_position += delta*velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	BulletManager.free_bullet(self)


func _on_body_entered(body):
	if body.is_in_group("kills_bullets"):
		BulletManager.free_bullet(self)


func _on_area_entered(area):
	if is_instance_of(area, Water):
		current_drag = WATER_DRAG
		current_gravity = gravity


func _on_area_exited(area):
	if is_instance_of(area, Water):
		current_drag = AIR_DRAG
		current_gravity = 0


func kill_bullet():
	BulletManager.free_bullet(self)
