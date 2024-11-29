class_name Bullet extends Area2D

var is_foe: bool
var bullet_type: Constants.BulletType
var DMG_AMOUNT: int = 1
var WATER_DRAG = 0.8
var AIR_DRAG = 0
var current_dark_color: Color
var current_light_color: Color
var velocity: Vector2
var current_drag: float
var current_gravity: float
var acceleration: Vector2
var is_underwater_ammo: bool
var time_before_visible: float = 0.05
var timer_before_visible: Timer
var dull: bool = false
var handled: bool = true

func _ready():
	$IsInWaterNotifier.water_state_changed.connect(on_water_status_changed)
	$VisibleOnScreenNotifier2D.screen_exited.connect(func(): BulletManager.release_bullet(self))

	body_entered.connect(func(body):
		if body.is_in_group("kills_bullets"):
			kill_bullet()
	)

	timer_before_visible = Timer.new()
	add_child(timer_before_visible)
	timer_before_visible.timeout.connect(func(): visible = true)

	current_drag = AIR_DRAG
	current_gravity = 0
	visible = false
	await get_tree().process_frame # TODO: Come up with a way to prevent those bullets from being instantiated instead.
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		BulletManager.release_bullet(self)

func restart():
	timer_before_visible.start(time_before_visible)
	current_drag = AIR_DRAG
	current_gravity = 0
	dull = false
	handled = false
	animate()

func _physics_process(delta):
	var drag: Vector2
	drag = -velocity * current_drag
	acceleration = drag + current_gravity * Vector2.DOWN
	velocity += acceleration * delta
	global_position += delta*velocity

func on_water_status_changed(is_in_water: bool, water: Water):
	if is_in_water != (bullet_type == Constants.BulletType.UNDERWATER):
		current_drag = WATER_DRAG
		current_gravity = gravity
		dull = true

	animate()

	if water:
		if abs(global_position.y - water.get_surface_global_position()) <= 16:
			PropManager.place_prop(Vector2(global_position.x, water.get_surface_global_position()), &"splash", water.bw_shader_setter.get_color())
func animate():
	var a: String
	match bullet_type:
		Constants.BulletType.REGULAR:
			a = "regular"
		Constants.BulletType.FIRE:
			a = "fire"
		Constants.BulletType.UNDERWATER:
			a = "underwater"
		Constants.BulletType.LIVING:
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

func color_owner_muzzle(muzzle: Node2D):
	if muzzle:
		muzzle.get_node("BwShaderSetter").set_color(current_dark_color, current_light_color)

func kill_bullet():
	handled = true
	var color_pair: Array[Color] = [current_dark_color, current_light_color]
	AudioManager.hooks.bullet_die_sfx()
	PropManager.place_prop(global_position, &"bullet_dies", color_pair)
	BulletManager.release_bullet(self)
