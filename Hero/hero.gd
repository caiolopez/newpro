extends CharacterBody2D

@export var can_dive = false ## Whether the hero has the ability to dive into water instead of floating.
@export var shoots_fire = false ## Whether the hero has the ability to shoot incendiary bullets, required to damage enemies that are immune to regular bullets.
@export var SPEED = 300.0 ## The moving speed of the hero.
@export var JUMP_VELOCITY = -400.0 ## The speed the hero jumps when grounded.
@export var WALLJUMP_VELOCITY = Vector2(800, -400) ## The speed the hero walljumps away from a wall.
@export var CLIMB_VELOCITY = -400.0 ## The speed the hero jumps upward when jumping to the same side of the wall (Megaman-style walljump).
@export var GLIDE_VELOCITY = 50.0 ## The speed at which the hero slowly descends when airborne and holding Jump.
@export var BLUNDER_AIRBORNE_VELOCITY = Vector2(-800, 0) ## The strenth of the recoil when blunderjumping on air.
@export var BLUNDER_GROUNDED_VELOCITY = Vector2(-800, 0) ## The strenth of the recoil when blunderjumping on ground.
@export var BLUNDER_AIRBORNE_DURATION = 1 ## The duration of the recoil when blunderjumping on air.
@export var BLUNDER_GROUNDED_DURATION = 0.5 ## The duration of the recoil when blunderjumping on ground.
@export var BLUNDER_JUMP_VELOCITY = -400.0 ## The speed the hero jumps after blundershooting airborne.
const DECELERATION = 10.0
@export var BUOYANCY = 100 ## The upward acceleration when underwater. Only affects state Floating.
@export var ASCENDING_VELOCITY = -300.0 ## The Y speed at which the hero swims upwards when holding jump while underwater. CAN_DIVE must be set to true.
@export var MAX_FALL_VEL_Y = 1200.0 ## The maximum downward speed when falling.
@export var MAX_DESCENT_VEL_Y = 300 ## The maximum downward speed when diving (CAN_DIVE must be set to true).
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
@export var bullet_manager: Node
var original_position: Vector2
var current_checkpoint: Area2D
var shoulder_rc: RayCast2D
var pelvis_rc: RayCast2D
var next_grd_height: RayCast2D
var currently_on_wall: bool
var facing_direction = 1
var is_on_water = false
var current_water: Water
var last_water_surface: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Events.hero_entered_water.connect(_on_hero_entered_water)
	Events.hero_exited_water.connect(_on_hero_exited_water)

	shoulder_rc = get_node("ShoulderRC")
	pelvis_rc = get_node("PelvisRC")
	next_grd_height = get_node("NextGrdHeight")
	
	original_position = global_position

	set_safe_margin(0.08)
	state_machine.start()

func _process(_delta):
	if Input.is_action_just_pressed("Debug Action 1"): die()
	if Input.is_action_just_pressed("Debug Action 2"): Events.camera_shake.emit()
	
	if get_node("DmgTaker").current_hp == 0:
		get_node("DmgTaker").reset_status()
		die()
	if is_on_water and state_machine.current_state.water_prone:
		state_machine.set_state("StateFloating")

func _physics_process(_delta):
	pass

func step_grav(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = minf(velocity.y, MAX_FALL_VEL_Y)


func step_lateral_mov(delta):
	if Input.is_action_pressed("move_left") == Input.is_action_pressed("move_right"):
		velocity.x = 0
		return
	
	if Input.is_action_pressed("move_left"):
		facing_direction = -1
	if Input.is_action_pressed("move_right"):
		facing_direction = 1
		
	if abs(velocity.x) > SPEED:
		velocity.x = lerp(velocity.x, facing_direction * SPEED, Utils.dt_lerp(delta, 10))

	else:
		velocity.x = facing_direction * SPEED

	shoulder_rc.update_direction()
	pelvis_rc.update_direction()
	next_grd_height.update_position()


func is_pushing_wall() -> bool:
	var pushing_wall = false
	var push_left = facing_direction == -1 and Input.is_action_pressed("move_left")
	var push_right = facing_direction == 1 and Input.is_action_pressed("move_right")
	if is_on_wall() and (push_left or push_right):
			pushing_wall = facing_direction == -round(get_wall_normal().x)
	return pushing_wall


func is_move_dir_away_from_last_wall(just: bool) -> bool:
	var mov_away
	if just:
		mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_just_pressed('move_left'))\
		or (round(get_wall_normal().x) == 1 and Input.is_action_just_pressed('move_right'))
	else:
		mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_pressed('move_left'))\
		or (round(get_wall_normal().x) == 1 and Input.is_action_pressed('move_right'))
	return mov_away


func is_input_blunder_shoot() -> bool:
	return Input.is_action_pressed('duck') and Input.is_action_just_pressed("shoot")


func shoot_regular() -> Area2D:
	return bullet_manager.create_bullet(facing_direction, position, Vector2(800, 0), false, shoots_fire)


func shoot_blunder(amount: int, interval_angle: float):
	var top_angle =  (amount-1) * interval_angle / 2
	for i in range(amount):
		bullet_manager.create_bullet(facing_direction, position, Vector2(800, 0), false, shoots_fire, top_angle - interval_angle * i)


func is_on_wall_value_change() -> bool:
	var changed = is_on_wall() != currently_on_wall
	currently_on_wall = is_on_wall()
	return changed


func _on_hero_entered_water(water, surface_global_pos):
	is_on_water = true
	current_water = water
	last_water_surface = surface_global_pos


func _on_hero_exited_water(_water):
	is_on_water = false
	current_water = null


func is_head_above_water() -> bool:
	if global_position.y < last_water_surface + 32:
		return true
	else:
		return false


func update_current_checkpoint(new_checkpoint: Area2D):		
	current_checkpoint = new_checkpoint


func die():
	state_machine.set_state("StateDeathSnapshot")
	
