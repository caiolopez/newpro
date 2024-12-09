class_name Bullet extends Area2D

var is_foe: bool
var bullet_type: Constants.BulletTypes
var DMG_AMOUNT: int = 1
var WATER_DRAG = 0.8
var AIR_DRAG = 0
var current_dark_color: Color
var current_light_color: Color
var current_muzzle: Node
var velocity: Vector2
var current_drag: float
var current_gravity: float
var acceleration: Vector2
var is_underwater_ammo: bool
var time_before_visible: float = 0.05
var time_elapsed: float = 0.0
var dull: bool = false
var handled: bool = true
var active: bool = false
var free_out_of_screen: bool = true
var time_before_freeing_out_of_screen: float = 1

func _ready() -> void:
	$IsInWaterNotifier.water_state_changed.connect(on_water_status_changed)
	$VisibleOnScreenNotifier2D.screen_exited.connect(func():
		if free_out_of_screen:
			BulletManager.return_bullet(self))

	body_entered.connect(func(body):
		if body.is_in_group("kills_bullets") and self.active:
			kill_bullet()
	)

	current_drag = AIR_DRAG
	current_gravity = 0

	await get_tree().process_frame
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		BulletManager.return_bullet(self)

func activate():
	current_drag = AIR_DRAG
	current_gravity = 0
	dull = false
	handled = false
	active = true
	set_up_colors_and_animation()
	color_muzzle(current_muzzle)
	reset_physics_interpolation() # Important.
	time_elapsed = 0.0
	$AnimatedSprite2D.visible = false

func deactivate():
	active = false
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.stop()

func _physics_process(delta):
	if not active: return
	var drag: Vector2
	drag = -velocity * current_drag
	acceleration = drag + current_gravity * Vector2.DOWN
	velocity += acceleration * delta
	global_position += delta*velocity
	
	
	time_elapsed += delta
	if time_elapsed >= time_before_visible:
		$AnimatedSprite2D.visible = true
	
	if not $VisibleOnScreenNotifier2D.is_on_screen()\
	and not free_out_of_screen\
	and time_elapsed > time_before_freeing_out_of_screen:
		BulletManager.return_bullet(self)

func on_water_status_changed(is_in_water: bool, water: Water):
	if is_in_water != (bullet_type == Constants.BulletTypes.UNDERWATER):
		current_drag = WATER_DRAG
		current_gravity = gravity
		dull = true

	set_up_colors_and_animation()

	if water:
		if abs(global_position.y - water.get_surface_global_position()) <= 16:
			PropManager.place_prop(Vector2(global_position.x, water.get_surface_global_position()), &"splash", water.bw_shader_setter.get_color())

func set_up_colors_and_animation():
	var a: String
	match bullet_type:
		Constants.BulletTypes.REGULAR:
			a = "regular"
		Constants.BulletTypes.FIRE:
			a = "fire"
		Constants.BulletTypes.UNDERWATER:
			a = "underwater"
		Constants.BulletTypes.LIVING:
			a = "living"
	if dull:
		a += "_dull"

	get_node("AnimatedSprite2D").play(a)
	Utils.randomize_animation_frame(get_node("AnimatedSprite2D"))
	
	var color_constant: StringName = ("BULLET_" + a.to_upper() + "_COLORS")
	if Constants.get(color_constant):
		current_dark_color = Constants.get(color_constant)[0]
		current_light_color = Constants.get(color_constant)[1]
	
	$BwShaderSetter.set_color(current_dark_color, current_light_color)

func color_muzzle(muzzle: Node2D):
	if muzzle:
		muzzle.get_node("BwShaderSetter").set_color(current_dark_color, current_light_color)

func kill_bullet():
	handled = true
	AudioManager.hooks.bullet_die_sfx()
	var color_pair: Array[Color] = [current_dark_color, current_light_color]
	PropManager.place_prop(global_position, &"bullet_dies", color_pair)
	BulletManager.return_bullet(self)
