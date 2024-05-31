class_name DoorState extends _State

var door: Door

func enter(new_machine:StateMachine) -> void:	
	door = new_machine.owner as Door
	super(new_machine)


