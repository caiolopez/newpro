extends Node2D

@onready var state_machine: StateMachine = $StateMachine


func _ready():
	$DmgTaker.died.connect(func(): state_machine.set_state("BStateDying"))
	$DmgTaker.resurrected.connect(func(): state_machine.set_state("BStateDormant"))


func _on_area_2d_area_entered(area):
	if area is BossFence\
	and state_machine.current_state.name == "BStateDashing":
		$MoveStraight.process_mode = Node.PROCESS_MODE_DISABLED
		Events.camera_shake.emit()
		state_machine.set_state("BStatePostDash")




