extends Node2D

@onready var center: Vector2 = $Marker2D.global_position
@onready var state_machine: StateMachine = $StateMachine
var current_stage: int = 0
var stunned_time_after_dash: float = 1
var blinking_timer: Timer = null

func _ready() -> void:
	Events.hero_died.connect(func():
		$GfxController/ParticleGroup.free_all_particles()
		)

	$DmgTaker.suffered.connect(on_suffered)
	$DmgTaker.died.connect(func(): state_machine.set_state("BStateDying"))
	$DmgTaker.restored.connect(func(): state_machine.set_state("BStateDormant"))
	$Area2D.area_entered.connect(_on_area_2d_area_entered)
	state_machine.start()

func _on_area_2d_area_entered(area):
	if area is BossFence\
	and state_machine.current_state.name == "BStateDashing":
		state_machine.set_state("BStatePostDash")

func update_current_stage(hp):
	var st: Array[int] = [30, 20, 10, 0]
	
	for i: int in range(st.size()):
		if hp > st[i]:
			current_stage = i
			return

func reparametrize_boss():
	match current_stage:
		0:
			$Flier.SPEED = 600
			$MoveStraight.SPEED = 2000
			stunned_time_after_dash = 1.0
			$GfxController/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE0_COLORS)
			$GfxController/ParticleGroup/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE0_COLORS)
		1:
			$Shooter.pellet_amount = 1
			$Shooter.pellet_separation_angle = 20
			$Shooter.time_between_shots = 0.05
			$Flier.SPEED = 700
			$MoveStraight.SPEED = 2500
			stunned_time_after_dash = 0.75
			$GfxController/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE1_COLORS)
			$GfxController/ParticleGroup/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE1_COLORS)
		2:
			$Shooter.pellet_amount = 3
			$Shooter.pellet_separation_angle = 10
			$Shooter.time_between_shots = 0.15
			$Flier.SPEED = 800
			$MoveStraight.SPEED = 3000
			stunned_time_after_dash = 0.5
			$GfxController/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE2_COLORS)
			$GfxController/ParticleGroup/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE2_COLORS)
		3:
			$Shooter.pellet_amount = 6
			$Shooter.pellet_separation_angle = 5
			$Shooter.time_between_shots = 0.15
			$Flier.SPEED = 900
			$MoveStraight.SPEED = 3200
			stunned_time_after_dash = 0.25
			$GfxController/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE3_COLORS)
			$GfxController/ParticleGroup/BwShaderSetter.set_color_pair(Constants.BOSS_STAGE3_COLORS)

func on_suffered(hp: int):
	var prev_stage = current_stage
	update_current_stage(hp)
	if prev_stage < current_stage:
		AudioManager.hooks.boss1_change_level_sfx()
		$GfxController/ParticleGroup.emit_particles()
		change_animation()
		Events.boss_changed_stage.emit(self)
		AppManager.camera.shake()
		if state_machine.current_state.name != "BStateSpinShooting":
			state_machine.set_state("BStateCentering")
	reparametrize_boss()

func change_animation():
	var prefix: StringName = state_machine.current_state.animation_prefix
	var sufix: StringName = &""
	if prefix != &"dormant":
		sufix = "_stage" + str(current_stage)
		
	$GfxController/AnimatedSprite2D.play(prefix + sufix)
