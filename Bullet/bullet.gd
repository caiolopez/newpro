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
var bullet_dies_prop_scene = load("res://Props/BulletDiesProp.tscn")
var dark_color: Color
var light_color: Color

func _ready():
	set_color()
	notifier = $VisibleOnScreenNotifier2D
	current_drag = AIR_DRAG
	current_gravity = 0
	await get_tree().process_frame # TODO: Come up with a way to prevent those bullets from being instantiated instead.
	if not notifier.is_on_screen():
		BulletManager.free_bullet(self)


func set_color():
	dark_color = Constants.BULLET_REGULAR_DARK
	light_color = Constants.BULLET_REGULAR_LIGHT
	material.set_shader_parameter("replace_black", dark_color)
	material.set_shader_parameter("replace_white", light_color)


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
		var new_dies_prop = bullet_dies_prop_scene.instantiate()
		new_dies_prop.global_position = global_position
		get_node("/root/GameTree").add_child(new_dies_prop)
		new_dies_prop.material.set_shader_parameter("replace_black", dark_color)
		new_dies_prop.material.set_shader_parameter("replace_white", light_color)
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
