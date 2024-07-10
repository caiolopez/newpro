class_name Hero extends CharacterBody2D

@export var can_dive: bool = false ## Whether the hero has the ability to dive into water instead of floating.
@export var shoots_fire: bool = false ## Whether the hero has the ability to shoot incendiary bullets, required to damage enemies that are immune to regular bullets.
@export var regular_shot_speed: float = 1000 ## The speed the normal shot moves. For blundershot setup, use Shooter component.
@export var SPEED: float = 600.0 ## The moving speed of the hero.
@export var JUMP_VELOCITY: float  = -1000.0 ## The speed the hero jumps when grounded.
@export var VAULT_VELOCITY: float = -500.0 ## The speed the hero jumps when performing the vault. Vaulting is an assist that aims at standardize velocity.y when the hero climbs a wall all the way up.
@export var HEADBUTT_THRESHOLD_VEL: float = -300.0 ## The minimum upward velocity required for the headbutt assist to take place and snap the Hero.
@export var WALLJUMP_VELOCITY = Vector2(1600, -600) ## The speed the hero walljumps away from a wall.
@export var CLIMB_VELOCITY: float = -1000 ## The speed the hero jumps upward when jumping to the same side of the wall (Megaman-style walljump).
@export var GLIDE_VELOCITY: float = 100 ## The speed at which the hero slowly descends when airborne and holding Jump.
@export var GLIDE_X_DRAG: float = -3000 ## The rate at which it decelerates to normal SPEED after walljump.
@export var BLUNDER_AIRBORNE_VELOCITY = Vector2(-2000, 0) ## The strength of the recoil when blundershooting on air.
@export var BLUNDER_GROUNDED_VELOCITY = Vector2(-800, 0) ## The strength of the recoil when blundershooting on ground.
@export var BLUNDER_UNDERWATER_VELOCITY = Vector2(-800, 0) ## The strength of the recoil when blundershooting on ground.
@export var BLUNDER_AIRBORNE_DURATION: float = 0.2 ## The duration of the recoil when blundershooting on air.
@export var BLUNDER_GROUNDED_DURATION: float = 0.05 ## The duration of the recoil when blundershooting on ground.
@export var BLUNDER_UNDERWATER_DURATION: float = 0.15 ## The duration of the recoil when blundershooting on water.
@export var BLUNDER_JUMP_VELOCITY: float = -1200 ## The speed the hero jumps after blundershooting airborne.
@export var BLUNDER_JUMP_WATER_BOUNCE_VELOCITY: float = -800 ## The speed the hero jumps after falling on water while holding jump from a blunder jump. Like Kiddy Kong.
@export var GRAVITY: float = 2000 ## The standard downward force, in absolute values.
@export var FAST_FALL_GRAVITY: float = 3000 ## The downward force, in absolute values, used in falling. Should be higher than GRAVITY, in order to make the Hero fall faster.
@export var UNDERWATER_GRAVITY: float = 500 ## The downward force, in absolute values, for when the Hero is diving.
@export var MAX_FALL_VEL_Y: float = 2000.0 ## The maximum downward speed when falling.
@export var BUOYANCY: float = 100 ## The upward acceleration when underwater. Only affects state Floating.
@export var ASCENDING_VELOCITY: float = -300.0 ## The Y speed at which the hero swims upwards when holding jump while underwater. CAN_DIVE must be set to true.
@export var MAX_DESCENT_VEL_Y: float = 300 ## The maximum downward speed when diving (CAN_DIVE must be set to true).
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
@onready var original_position: Vector2 = global_position
@onready var shoulder_rc: RayCast2D = get_node("ShoulderRC")
@onready var pelvis_rc: RayCast2D = get_node("PelvisRC")
@onready var next_grd_height: RayCast2D = get_node("NextGrdHeight")
@onready var headbutt_assist: RayCast2D = get_node("HeadbuttAssist")
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self)
@onready var shooter: Shooter = get_node("Shooter")
const is_foe: bool = false ## Flag necessary for components that are shared between Hero and enemies.
var current_checkpoint_path: NodePath
var current_blunder_jump_angle: float
var was_on_wall: bool ## For variable change caculation
var was_on_floor: bool ## For variable change caculation
var was_pushing_wall: bool ## For variable change caculation
var was_on_water: bool ## For variable change caculation
var was_auto_snapping: bool
var on_wall_value_just_changed: bool
var is_auto_snapping: bool
var is_just_on_floor: bool
var is_just_pushing_wall: bool
var just_stopped_pushing_wall: bool
var facing_direction = 1
var is_in_water: bool = false
var is_just_on_water: bool
var current_water: Water
var last_water_surface: float


func _ready():
	Events.hero_entered_water.connect(func(_water, surface_glpos):
		is_in_water = true
		last_water_surface = surface_glpos)
	Events.hero_exited_water.connect(func(_water): is_in_water = false)
	Events.hero_hit_teleporter.connect(_on_hero_hit_teleporter)
	ComboParser.combo_performed.connect(func(combo): if combo == "Die": die())

	set_safe_margin(0.08)
	state_machine.start()


func _process(_delta):
	#if Input.is_action_just_pressed("shoot"): print("SHOOT!")
	#if Input.is_action_just_pressed("jump"): print("J")
	#if Input.is_action_just_pressed("move_left"): print("LEFT")
	#if Input.is_action_just_pressed("move_right"): print("RIGHT")
	#if Input.is_action_just_released("jump"): print("j")
	#if Input.is_action_just_released("move_left"): print("left")
	#if Input.is_action_just_released("move_right"): print("right")
	
	check_value_change()
	
	if dmg_taker.current_hp == 0\
	and state_machine.current_state.death_prone:
		die()
	if $InnardsRC.is_colliding()\
	and state_machine.current_state.death_prone:
		die()
	if is_in_water and state_machine.current_state.water_prone:
		state_machine.set_state("StateFloating")

func _physics_process(_delta):
	pass

func step_grav(delta, downward_accel: float = GRAVITY):
	if not is_on_floor():
		velocity.y += downward_accel * delta
		velocity.y = minf(velocity.y, MAX_FALL_VEL_Y)


func step_lateral_mov(delta):
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
		Events.hero_changed_dir.emit(facing_direction)

	velocity.x += GLIDE_X_DRAG * facing_direction * delta
	velocity.x = maxf(abs(velocity.x), SPEED) * facing_direction

	shoulder_rc.update_direction()
	pelvis_rc.update_direction()
	next_grd_height.update_position()
	headbutt_assist.update_direction()
	headbutt_assist.update_position()


func is_pushing_wall() -> bool:
	var pushing_wall = false
	var push_left = facing_direction == -1 and Input.is_action_pressed("move_left")
	var push_right = facing_direction == 1 and Input.is_action_pressed("move_right")
	if is_on_wall() and (push_left or push_right):
			pushing_wall = facing_direction == -round(get_wall_normal().x)
	return pushing_wall


func is_move_dir_away_from_last_wall() -> bool:
	var mov_away
	mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_pressed('move_left'))\
	or (round(get_wall_normal().x) == 1 and Input.is_action_pressed('move_right'))
	return mov_away


func is_move_dir_just_away_from_last_wall() -> bool:
	var mov_away
	mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_just_pressed('move_left'))\
	or (round(get_wall_normal().x) == 1 and Input.is_action_just_pressed('move_right'))
	return mov_away


func is_input_blunder_shoot() -> bool:
	return Input.is_action_pressed('duck') and Input.is_action_just_pressed("shoot")


func check_value_change():
	is_just_on_floor = is_on_floor() and not was_on_floor
	was_on_floor = is_on_floor()
	
	is_just_on_water = is_in_water and not was_on_water
	was_on_water = is_in_water
	
	on_wall_value_just_changed = is_on_wall() != was_on_wall
	was_on_wall = is_on_wall()
	
	is_just_pushing_wall = is_pushing_wall() and not was_pushing_wall
	just_stopped_pushing_wall = not is_pushing_wall() and was_pushing_wall
	was_pushing_wall = is_pushing_wall()


func is_head_above_water() -> bool:
	if global_position.y < last_water_surface + 64:
		return true
	else:
		return false


func step_auto_snap():
	if is_on_floor()\
	and not pelvis_rc.is_colliding()\
	and not shoulder_rc.is_colliding()\
	and  next_grd_height.is_colliding()\
	and is_pushing_wall():
		global_position.y = next_grd_height.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 1
		print("AUTO SNAP ON STAIRS")
		is_auto_snapping = true
	else:
		is_auto_snapping = false


func _on_hero_hit_teleporter(destination: Vector2):
	if not state_machine.current_state.death_prone:
		return
	$StateMachine/StateTeleporting.destination = destination
	state_machine.set_state("StateTeleporting")


func update_current_checkpoint_path(new_checkpoint_path: NodePath):
	current_checkpoint_path = new_checkpoint_path
	SaveManager.log_hero_change("current_checkpoint_path", current_checkpoint_path)


func die():
	state_machine.set_state("StateDeathSnapshot")

func insta_spawn():
	state_machine.set_state("StateSpawning")
	
