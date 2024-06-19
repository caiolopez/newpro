extends Node2D

@onready var state_machine: StateMachine = $StateMachine
var current_stage: int = 0


func _ready():
	$DmgTaker.suffered.connect(on_suffered)
	$DmgTaker.died.connect(func(): state_machine.set_state("BStateDying"))
	$DmgTaker.resurrected.connect(func(): state_machine.set_state("BStateDormant"))


func _on_area_2d_area_entered(area):
	if area is BossFence\
	and state_machine.current_state.name == "BStateDashing":
		state_machine.set_state("BStatePostDash")


func update_current_stage(hp):
	var st: Array[int] = [30, 20, 10, 0]
	
	for i: int in range(st.size()):
		if hp > st[i]:
			current_stage = i
			print(i)
			return


func reparametrize_boss():
	match current_stage:
		0:
			$Flier.SPEED = 600
			$MoveStraight.SPEED = 2000
		1:
			$Shooter.pellet_amount = 1
			$Shooter.pellet_separation_angle = 20
			$Shooter.time_between_shots = 0.1
			$Flier.SPEED = 800
			$MoveStraight.SPEED = 2500
		2:
			$Shooter.pellet_amount = 3
			$Shooter.pellet_separation_angle = 10
			$Shooter.time_between_shots = 0.05
			$Flier.SPEED = 1000
			$MoveStraight.SPEED = 3000
		3:
			$Shooter.pellet_amount = 6
			$Shooter.pellet_separation_angle = 5
			$Shooter.time_between_shots = 0.05
			$Flier.SPEED = 1000
			$MoveStraight.SPEED = 3000


func on_suffered(hp: int):
	var prev_stage = current_stage
	update_current_stage(hp)
	if prev_stage < current_stage\
	and state_machine.current_state.name != "BStateSpinShooting":
		state_machine.set_state("BStateCentering")
	reparametrize_boss()


func _process(_delta):
	pass #print(current_stage)
