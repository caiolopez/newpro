class_name Hero extends CharacterBody2D

@export var regular_shot_speed: float = 1000 ## The speed the normal shot moves. For blundershot setup, use Shooter component.
@export var SPEED: float = 600.0 ## The moving speed of the hero.
@export var JUMP_VELOCITY: float  = -1000.0 ## The speed the hero jumps when grounded.
@export var VAULT_VELOCITY: float = -200.0 ## The speed the hero jumps when performing the vault. Vaulting is an assist that aims at standardize velocity.y when the hero climbs a wall all the way up.
@export var HEADBUTT_THRESHOLD_VEL: float = -300.0 ## The minimum upward velocity required for the headbutt assist to take place and snap the Hero.
@export var WALLJUMP_VELOCITY = Vector2(1600, -600) ## The speed the hero walljumps away from a wall.
@export var CLIMB_VELOCITY: float = -1000 ## The speed the hero jumps upward when jumping to the same side of the wall (Megaman-style walljump).
@export var GLIDE_VELOCITY: float = 300 ## The speed at which the hero slowly descends when airborne and holding Jump.
@export var GLIDE_X_DRAG: float = -3000 ## The rate at which it decelerates to normal SPEED after walljump.
@export var BLUNDER_AIRBORNE_VELOCITY = Vector2(-2000, 0) ## The strength of the recoil when blundershooting on air.
@export var BLUNDER_GROUNDED_VELOCITY = Vector2(-2000, 0) ## The strength of the recoil when blundershooting on ground.
@export var BLUNDER_UNDERWATER_VELOCITY = Vector2(-800, 0) ## The strength of the recoil when blundershooting on ground.
@export var BLUNDER_AIRBORNE_DURATION: float = 0.2 ## The duration of the recoil when blundershooting on air.
@export var BLUNDER_GROUNDED_DURATION: float = 0.05 ## The duration of the recoil when blundershooting on ground.
@export var BLUNDER_UNDERWATER_DURATION: float = 0.15 ## The duration of the recoil when blundershooting on water.
@export var BLUNDER_JUMP_VELOCITY: float = -1200 ## The speed the hero jumps after blundershooting airborne.
@export var BLUNDER_JUMP_WATER_BOUNCE_VELOCITY: float = -1000 ## The speed the hero jumps after tapping jump while blunderjumping on water surface. Like Kiddy Kong.
@export var GRAVITY: float = 2000 ## The standard downward force, in absolute values.
@export var FAST_FALL_GRAVITY: float = 3000 ## The downward force, in absolute values, used in falling. Should be higher than GRAVITY, in order to make the Hero fall faster.
@export var UNDERWATER_GRAVITY: float = 500 ## The downward force, in absolute values, for when the Hero is diving.
@export var MAX_FALL_VEL_Y: float = 2000.0 ## The maximum downward speed when falling.
@export var BUOYANCY: float = 100 ## The upward acceleration when underwater. Only affects state Floating.
@export var ASCENDING_VELOCITY: float = -300.0 ## The Y speed at which the hero swims upwards when holding jump while underwater. CAN_DIVE must be set to true.
@export var MAX_DESCENT_VEL_Y: float = 300 ## The maximum downward speed when diving (CAN_DIVE must be set to true).
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
@onready var original_position: Vector2 = global_position
@onready var shoulder_rc: RayCast2D = $ShoulderRC
@onready var pelvis_rc: RayCast2D = $PelvisRC
@onready var next_grd_height_rc: RayCast2D = $NextGrdHeightRC
@onready var headbutt_assist_rc : RayCast2D = $HeadbuttAssistRC
@onready var ass_rc: RayCast2D = $AssRC
@onready var dmg_taker: DmgTaker = $DmgTaker
@onready var shooter: Shooter = $Shooter
const is_foe: bool = false ## Flag necessary for components that are shared between Hero and enemies.
var can_dive: bool = false ## Whether the hero has the ability to dive into water instead of floating.
var current_checkpoint_path: NodePath
var current_blunder_jump_angle: float
var was_on_wall: bool ## For variable change caculation
var was_on_floor: bool ## For variable change caculation
var was_pushing_wall: bool ## For variable change caculation
var was_in_water: bool ## For variable change caculation
var was_auto_snapping: bool
var on_wall_value_just_changed: bool
var is_just_on_floor: bool
var is_just_pushing_wall: bool
var just_stopped_pushing_wall: bool
var facing_direction = 1
var is_in_water: bool = false
var is_just_in_water: bool
var just_left_water: bool
var last_water_surface: float

func _ready():
	Events.hero_got_collectible.connect(handle_powerups)
	Events.hero_hit_teleporter.connect(_on_hero_hit_teleporter)
	ComboParser.combo_performed.connect(func(combo): if combo == "Die": die())
	$IsInWaterNotifier_GUN.water_state_changed.connect(on_water_status_changed_on_gun)

	set_safe_margin(0.08)
	state_machine.start()

func _process(_delta):
	check_value_change()
	
	if dmg_taker.current_hp == 0: die()
	if $InnardsRC.is_colliding(): die()
	if is_in_water\
	and state_machine.current_state.water_prone\
	and global_position.y > last_water_surface:
		state_machine.set_state("StateFloating")

func _physics_process(_delta):
	if is_on_floor():
		RegionManager.call_deferred("infer_current_region_from_last_floor")

func step_grav(delta, downward_accel: float = GRAVITY):
	if not is_on_floor():
		velocity.y += downward_accel * delta
		velocity.y = minf(velocity.y, MAX_FALL_VEL_Y)

func step_lateral_mov(delta, speed: float = SPEED):
	var dir_just_changed = false
	if Input.is_action_pressed("move_left") == Input.is_action_pressed("move_right"):
		velocity.x = 0
		return
	
	if Input.is_action_pressed("move_left"):
		dir_just_changed = facing_direction == 1
		facing_direction = -1
	if Input.is_action_pressed("move_right"):
		dir_just_changed = facing_direction == -1
		facing_direction = 1

	if dir_just_changed:
		velocity.x = 0
		$Gfx/Muzzle.hide()

	velocity.x += GLIDE_X_DRAG * facing_direction * delta
	velocity.x = maxf(abs(velocity.x), speed) * facing_direction

	ass_rc.update_direction()
	shoulder_rc.update_direction()
	pelvis_rc.update_direction()
	next_grd_height_rc.update_position()
	headbutt_assist_rc.update_direction()
	headbutt_assist_rc.update_position()

func is_pushing_wall() -> bool:
	var pushing_wall = false
	var push_left = facing_direction == -1 and Input.is_action_pressed("move_left")
	var push_right = facing_direction == 1 and Input.is_action_pressed("move_right")
	if is_on_wall() and (push_left or push_right):
			pushing_wall = facing_direction == -round(get_wall_normal().x)
	return pushing_wall

func is_move_dir_away_from_last_wall() -> bool:
	var mov_away
	mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_pressed("move_left"))\
	or (round(get_wall_normal().x) == 1 and Input.is_action_pressed("move_right"))
	return mov_away

func is_move_dir_just_away_from_last_wall() -> bool:
	var mov_away
	mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_just_pressed("move_left"))\
	or (round(get_wall_normal().x) == 1 and Input.is_action_just_pressed("move_right"))
	return mov_away

func is_input_blunder_shoot() -> bool:
	if not DebugTools.blunder_on_single_button:
		return Input.is_action_pressed("duck") and Input.is_action_just_pressed("shoot")
	else: return Input.is_action_pressed("triangle")

func step_walljump() -> void:
	if $StateMachine/TimerBufferWallJump.is_stopped() or not Utils.is_pushing_sides(): return
	if ass_rc.is_colliding():
		state_machine.set_state("StateWallJumping")

func check_value_change():
	is_just_on_floor = is_on_floor() and not was_on_floor
	was_on_floor = is_on_floor()
	
	is_just_in_water = is_in_water and not was_in_water
	just_left_water = not is_in_water and was_in_water
	was_in_water = is_in_water
	
	on_wall_value_just_changed = is_on_wall() != was_on_wall
	was_on_wall = is_on_wall()
	
	is_just_pushing_wall = is_pushing_wall() and not was_pushing_wall
	just_stopped_pushing_wall = not is_pushing_wall() and was_pushing_wall
	was_pushing_wall = is_pushing_wall()

func is_head_above_water() -> bool:
	if global_position.y < last_water_surface + 92:
		return true
	else:
		return false

func _on_hero_hit_teleporter(destination: Vector2):
	if not state_machine.current_state.death_prone:
		return
	$StateMachine/StateTeleporting.destination = destination
	state_machine.set_state("StateTeleporting")

func update_current_checkpoint_path(new_checkpoint_path: NodePath):
	current_checkpoint_path = new_checkpoint_path
	SaveManager.log_hero_change("current_checkpoint_path", current_checkpoint_path)

func step_shooting(inverted: bool = false, wet: bool = false) -> void:
	if is_input_blunder_shoot()\
	and $StateMachine/TimerBlunderShootCooldown.is_stopped():
		$Gfx/Muzzle.visible = true
		$Gfx/Muzzle.play("blunder")
		if wet: state_machine.set_state("StateWetBlunderShooting")
		else: state_machine.set_state("StateBlunderShooting")
		shooter.shoot()
		return

	if Input.is_action_just_pressed("shoot"):
		$Gfx/Muzzle.visible = true
		$Gfx/Muzzle.play("default")
		shooter.shoot_ad_hoc(regular_shot_speed, 0, false, inverted)

func color_muzzle(dark: Color, light: Color) -> void:
	$Gfx/Muzzle/BwShaderSetter.set_color(dark, light)

func die():
	if state_machine.current_state.death_prone:
		state_machine.set_state("StateDeathSnapshot")

func insta_spawn():
	state_machine.set_state("StateSpawning")

func on_water_status_changed(_is_in_water: bool, water: Water):
	self.is_in_water = _is_in_water
	last_water_surface = water.get_surface_global_position()

func on_water_status_changed_on_gun(_is_in_water: bool, _water: Water):
	shooter.is_in_water = _is_in_water

func repel_ass(delta, repulsion_velocity: float = 50000):
	velocity.x = repulsion_velocity * facing_direction * delta

func handle_powerups(type: StringName):
	match type:
		"NONE":
			return
		"INCENDIARY_AMMO":
			shooter.bullet_type = Constants.BulletType.FIRE
			SaveManager.log_hero_change("got_incendiary_ammo", true)
		"UNDERWATER_AMMO":
			shooter.shoots_underwater_ammo = true
			SaveManager.log_hero_change("got_underwater_ammo", true)
		"AQUALUNG":
			can_dive = true
			SaveManager.log_hero_change("got_aqualung", true)
		"TELEPORTER":
			AppManager.teleporters_are_active = true
			SaveManager.log_hero_change("got_teleporter", true)
		
