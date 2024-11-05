class_name Hero extends CharacterBody2D

const REGULAR_SHOT_SPEED: float = 1000 ## The speed the normal shot moves. For blundershot setup, use Shooter component.
const SPEED: float = 600.0 ## The moving speed of the hero.
const JUMP_VELOCITY: float  = -970.0 ## The speed the hero jumps when grounded.
const VAULT_VELOCITY: float = -250.0 ## The speed the hero jumps when performing the vault. Vaulting is an assist that aims at standardize velocity.y when the hero climbs a wall all the way up.
const HEADBUTT_THRESHOLD_VEL: float = -300.0 ## The minimum upward velocity required for the headbutt assist to take place and snap the Hero.
const WALLJUMP_VELOCITY = Vector2(1600, -600) ## The speed the hero walljumps away from a wall.
const CLIMB_VELOCITY: float = -1000 ## The speed the hero jumps upward when jumping to the same side of the wall (Megaman-style walljump).
const GLIDE_VELOCITY: float = 300 ## The speed at which the hero slowly descends when airborne and holding Jump.
const GLIDE_X_DRAG: float = -3000 ## The rate at which it decelerates to normal SPEED after walljump.
const BLUNDER_AIRBORNE_VELOCITY = Vector2(-2000, 0) ## The strength of the recoil when blundershooting on air.
const BLUNDER_GROUNDED_VELOCITY = Vector2(-1000, 0) ## The strength of the recoil when blundershooting on ground.
const BLUNDER_UNDERWATER_VELOCITY = Vector2(-800, 0) ## The strength of the recoil when blundershooting on ground.
const BLUNDER_AIRBORNE_DURATION: float = 0.2 ## The duration of the recoil when blundershooting on air.
const BLUNDER_GROUNDED_DURATION: float = 0.1 ## The duration of the recoil when blundershooting on ground.
const BLUNDER_UNDERWATER_DURATION: float = 0.15 ## The duration of the recoil when blundershooting on water.
const BLUNDER_JUMP_VELOCITY: float = -1050 ## The speed the hero jumps after blundershooting airborne.
const BLUNDER_JUMP_WATER_BOUNCE_VELOCITY: float = -1000 ## The speed the hero jumps after tapping jump while blunderjumping on water surface. Like Kiddy Kong.
const GRAVITY: float = 2000 ## The standard downward force, in absolute values.
const FAST_FALL_GRAVITY: float = 3000 ## The downward force, in absolute values, used in falling. Should be higher than GRAVITY, in order to make the Hero fall faster.
const UNDERWATER_GRAVITY: float = 500 ## The downward force, in absolute values, for when the Hero is diving.
const MAX_FALL_VEL_Y: float = 2000.0 ## The maximum downward speed when falling.
const BUOYANCY: float = 100 ## The upward acceleration when underwater. Only affects state Floating.
const ASCENDING_VELOCITY: float = -300.0 ## The Y speed at which the hero swims upwards when holding jump while underwater. CAN_DIVE must be set to true.
const FLOAT_TO_IDLE_HEIGHT_COMPENSATION: float = 80.0 ## The increment in vertical position when transitioning floating to idle.
const MAX_DESCENT_VEL_Y: float = 300 ## The maximum downward speed when diving (CAN_DIVE must be set to true).
@onready var original_position: Vector2 = global_position
@onready var state_machine: StateMachine = $StateMachine
@onready var shoulder_rc: RayCast2D = $ShoulderRC
@onready var pelvis_rc: RayCast2D = $PelvisRC
@onready var next_grd_height_rc: RayCast2D = $NextGrdHeightRC
@onready var headbutt_assist_rc: RayCast2D = $HeadbuttAssistRC
@onready var shoulder_back_rc: RayCast2D = $ShoulderBackRC
@onready var pelvis_back_rc: RayCast2D = $PelvisBackRC
@onready var swim_feet_rc: RayCast2D = $SwimFeetRC
@onready var innards_rc: RayCast2D = $InnardsRC
@onready var dmg_taker: DmgTaker = $DmgTaker
@onready var shooter: Shooter = $Shooter
const is_foe: bool = false ## Flag necessary for components that are shared between Hero and enemies.
var can_dive: bool = false ## Whether the hero has the ability to dive into water instead of floating.
var current_checkpoint_path: NodePath
var current_checkpoint_direction: int = 1
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
var facing_direction: int = 1
var current_water: Water = null
var is_in_water: bool = false
var is_just_in_water: bool
var just_left_water: bool
var last_water_surface: float
var last_water_color: Array[Color]
var last_move_input: StringName = ""

func _ready():
	AppManager.game_started.connect(func(): state_machine.start())
	Events.hero_got_collectible.connect(handle_powerups)
	Events.hero_hit_teleporter.connect(_on_hero_hit_teleporter)
	ComboParser.combo_performed.connect(func(combo): if combo == "Die": die())
	$IsInWaterNotifier_GUN.water_state_changed.connect(on_water_status_changed_on_gun)
	if not AppManager.hero: AppManager.hero = self
	set_safe_margin(0.08)

func _process(_delta):
	check_value_change()
	
	if dmg_taker.current_hp == 0: die()
	if innards_rc.is_colliding(): die()
	if is_in_water\
	and state_machine.current_state.water_prone\
	and global_position.y > last_water_surface:
		state_machine.set_state("StateFloating")
	
	if is_in_water and current_water and current_water.is_movable:
		last_water_surface = current_water.get_surface_global_position()
		last_water_color = current_water.bw_shader_setter.get_color()

func _physics_process(_delta):
	if is_on_floor():
		RegionManager.call_deferred("infer_current_region_from_last_floor")

func step_grav(delta, downward_accel: float = GRAVITY):
	if not is_on_floor():
		velocity.y += downward_accel * delta
		velocity.y = minf(velocity.y, MAX_FALL_VEL_Y)

func step_lateral_mov(delta, speed: float = SPEED):
	var dir_just_changed = false
	
	if Input.is_action_just_pressed("move_left"):
		last_move_input = "move_left"
	elif Input.is_action_just_pressed("move_right"):
		last_move_input = "move_right"
	
	if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		velocity.x = 0
		last_move_input = ""
		return
	
	var move_direction = 0
	if last_move_input == "move_left" and Input.is_action_pressed("move_left"):
		move_direction = -1
	elif last_move_input == "move_right" and Input.is_action_pressed("move_right"):
		move_direction = 1
	elif Input.is_action_pressed("move_left"):
		move_direction = -1
	elif Input.is_action_pressed("move_right"):
		move_direction = 1
	
	if move_direction != 0:
		dir_just_changed = facing_direction != move_direction
		facing_direction = move_direction
	
	if dir_just_changed:
		velocity.x = 0
		$Gfx/Muzzle.hide()

	velocity.x += GLIDE_X_DRAG * facing_direction * delta
	velocity.x = maxf(abs(velocity.x), speed) * facing_direction

	shoulder_rc.update_direction()
	shoulder_back_rc.update_direction()
	pelvis_rc.update_direction()
	pelvis_back_rc.update_direction()
	swim_feet_rc.update_direction()
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

func is_pushing_overhanging_wall() -> bool:
	if not is_pushing_wall(): return false
	return get_wall_normal().y > 0

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
	if not AppManager.dedicated_blunder_button:
		return Input.is_action_pressed("duck") and Input.is_action_just_pressed("shoot")
	else: return Input.is_action_just_pressed("blundershoot")

func step_walljump() -> void:
	if $StateMachine/TimerBufferWallJump.is_stopped() or not Utils.is_pushing_sides(): return
	if pelvis_back_rc.is_colliding() or shoulder_back_rc.is_colliding():
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

func update_current_checkpoint_info(new_cp_path: NodePath, new_cp_dir: int):
	current_checkpoint_path = new_cp_path
	current_checkpoint_direction = new_cp_dir
	SaveManager.log_hero_change("current_checkpoint_path", current_checkpoint_path)
	SaveManager.log_hero_change("current_checkpoint_direction", current_checkpoint_direction)

func step_shooting(inverted: bool = false, wet: bool = false) -> bool:
	if is_input_blunder_shoot()\
	and $StateMachine/TimerBlunderShootCooldown.is_stopped():
		$Gfx/Muzzle.visible = true
		$Gfx/Muzzle.play("blunder")
		if wet: state_machine.set_state("StateWetBlunderShooting")
		else: state_machine.set_state("StateBlunderShooting")
		shooter.shoot()
		return true ## Returns true if a blundershoot change of state occurred

	if Input.is_action_just_pressed("shoot"):
		$Gfx/Muzzle.visible = true
		$Gfx/Muzzle.play("default")
		shooter.shoot_ad_hoc(REGULAR_SHOT_SPEED, 0, false, inverted)
	return false

func color_muzzle(dark: Color, light: Color) -> void:
	$Gfx/Muzzle/BwShaderSetter.set_color(dark, light)

func die():
	if state_machine.current_state.death_prone:
		state_machine.set_state("StateDeathSnapshot")
		resize_collider_to_regular()

func on_water_status_changed(_is_in_water: bool, water: Water):
	self.is_in_water = _is_in_water
	current_water = water
	last_water_surface = water.get_surface_global_position()
	last_water_color = water.bw_shader_setter.get_color()

func on_water_status_changed_on_gun(_is_in_water: bool, _water: Water):
	shooter.is_in_water = _is_in_water

func step_repel_swim_feet(delta, repulsion_velocity: float = 10000):
	if swim_feet_rc.is_colliding():
		var proposed_velocity = repulsion_velocity * facing_direction * delta
		if abs(proposed_velocity) > abs(velocity.x):
			velocity.x = proposed_velocity

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
			AppManager.set_teleporters_active(true)
			SaveManager.log_hero_change("got_teleporter", true)

func is_currently_dead() -> bool:
	return state_machine.current_state.name in [
		"StateDeathSnapshot",
		"StateTweeningToRespawn",
		"StateRespawning"]

func reset_all_variables() -> void:
	state_machine.set_state("StateSpawning")

	global_position = original_position
	velocity = Vector2.ZERO
	facing_direction = 1
	is_in_water = false
	last_water_surface = 0
	last_water_color = []
	current_checkpoint_path = NodePath()
	can_dive = false
	shooter.bullet_type = Constants.BulletType.REGULAR
	shooter.shoots_underwater_ammo = false
	resize_collider_to_regular()
	shooter.is_in_water = false
	dmg_taker.current_hp = dmg_taker.HP_AMOUNT

	was_on_wall = false
	was_on_floor = false
	was_pushing_wall = false
	was_in_water = false
	was_auto_snapping = false
	on_wall_value_just_changed = false
	is_just_on_floor = false
	is_just_pushing_wall = false
	just_stopped_pushing_wall = false
	is_just_in_water = false
	just_left_water = false

	$StateMachine/TimerCoyoteJump.stop()
	$StateMachine/TimerBufferJump.stop()
	$StateMachine/TimerCoyoteWall.stop()
	$StateMachine/TimerBufferWallJump.stop()
	$StateMachine/TimerWallJumpDuration.stop()
	$StateMachine/TimerBlunderShootDuration.stop()
	$StateMachine/TimerBlunderShootCooldown.stop()
	$StateMachine/TimerBlunderJumpWindow.stop()
	$StateMachine/TimerLeavingWall.stop()
	$StateMachine/TimerBufferClimbing.stop()
	$StateMachine/TimerDeathSnapshot.stop()
	$StateMachine/TimerSuperBounceWindow.stop()
	$StateMachine/TimerBetweenBlunderJumpingShots.stop()
	$StateMachine/TimerBeforeGlide.stop()

	$Gfx/Muzzle.hide()

func force_water_detection() -> bool:
	var water_notifier = $IsInWaterNotifier
	if water_notifier.current_water_areas.is_empty():
		is_in_water = false
		return false
	
	var water = water_notifier.current_water_areas[0]  # Get the first water area
	is_in_water = true
	last_water_surface = water.get_surface_global_position()
	last_water_color = water.bw_shader_setter.get_color()
	on_water_status_changed(true, water)
	return true

func resize_collider_to_regular() -> void:
	%HeroCollider.shape.size.y = 130
	%HeroCollider.position.y = 0
	var dmg_coll: CollisionShape2D = dmg_taker.get_node("CollisionShape2D")
	dmg_coll.shape.size.y = 110
	dmg_coll.position.y = 0

func resize_collider_to_swim() -> void:
	%HeroCollider.shape.size.y = 70
	%HeroCollider.position.y = -30
	var dmg_coll: CollisionShape2D = dmg_taker.get_node("CollisionShape2D")
	dmg_coll.shape.size.y = 50
	dmg_coll.position.y = -30
