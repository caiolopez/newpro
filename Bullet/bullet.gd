class_name Bullet extends Area2D

var is_foe: bool
var bullet_type: Constants.BulletType
var DMG_AMOUNT: int = 1
var WATER_DRAG = 0.8
var AIR_DRAG = 0
var velocity: Vector2
var current_drag: float
var current_gravity: float
var acceleration: Vector2
var is_underwater_ammo: bool
var is_in_water: bool = false
var notifier: VisibleOnScreenNotifier2D
var dark_color: Color
var light_color: Color
var time_before_visible: float = 0.05
var timer_before_visible: Timer


func _ready():
	timer_before_visible = Timer.new()
	add_child(timer_before_visible)
	timer_before_visible.timeout.connect(func(): visible = true)

	notifier = $VisibleOnScreenNotifier2D
	current_drag = AIR_DRAG
	current_gravity = 0
	visible = false
	set_color()
	await get_tree().process_frame # TODO: Come up with a way to prevent those bullets from being instantiated instead.
	if not notifier.is_on_screen():
		BulletManager.release_bullet(self)


func restart():
	timer_before_visible.start(time_before_visible)


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
	BulletManager.release_bullet(self)


func _on_body_entered(body):
	if body.is_in_group("kills_bullets"):
		kill_bullet()


func _on_area_entered(area):
	if is_instance_of(area, Water):
		is_in_water = true
		current_drag = WATER_DRAG
		current_gravity = gravity
		if abs(global_position.y - area.get_surface_global_position()) <= 16:
			PropManager.place_prop(Vector2(global_position.x, area.get_surface_global_position()), &"splash")
		animate()


func _on_area_exited(area):
	if is_instance_of(area, Water):
		is_in_water = false
		current_drag = AIR_DRAG
		current_gravity = 0
		if abs(global_position.y - area.get_surface_global_position()) <= 32:
			PropManager.place_prop(Vector2(global_position.x, area.get_surface_global_position()), &"splash")
		animate()


func animate():
	var a: String
	match bullet_type:
		Constants.BulletType.REGULAR: a = "regular_"
		Constants.BulletType.FIRE: a = "fire_"
	if is_in_water:
		a += "wet"
	else:
		a += "dry"

	get_node("AnimatedSprite2D").play(a)
	Utils.randomize_animation_frame(get_node("AnimatedSprite2D"))


func kill_bullet():
	var new_dies_prop = PropManager.place_prop(global_position, &"bullet_dies")
	if new_dies_prop:
		new_dies_prop.material.set_shader_parameter("replace_black", dark_color)
		new_dies_prop.material.set_shader_parameter("replace_white", light_color)
	BulletManager.release_bullet(self)
