extends Node

@export var print_stuff: bool = true
@export var input_stuff: bool = true
@export var debug_mode: bool = true

func _ready():
	pass

func _process(_delta):
	input_bin()
	print_bin()

func input_bin():
	if not input_stuff: return
	if Input.is_action_just_pressed("Debug Action 1"):
		pass #SaveManager.print_all_dics()

	if DebugTools.debug_mode\
	and Input.is_action_just_pressed("Debug Action 2")\
	and AppManager.hero.state_machine.current_state.death_prone:
		AppManager.hero.state_machine.set_state("StateDebug")
	
	#if Input.is_action_just_pressed("shoot"): AudioManager.play_sfx(&"snare")
	#if Input.is_action_just_pressed("jump"): AudioManager.play_music("giorgio")

	#if Input.is_action_just_pressed("shoot"): print("SHOOT!")
	#if Input.is_action_just_pressed("jump"): print("J ", AppManager.hero.pelvis_back_rc.is_colliding(), AppManager.hero.shoulder_back_rc.is_colliding())
	#if Input.is_action_just_pressed("move_left"): print("LEFT")
	#if Input.is_action_just_pressed("move_right"): print("RIGHT")
	#if Input.is_action_just_released("jump"): print("j")
	#if Input.is_action_just_released("move_left"): print("left")
	#if Input.is_action_just_released("move_right"): print("right")


func print_bin():
	if not print_stuff: return
