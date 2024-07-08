class_name AppState extends _State

var AppManager: Node
@onready var t: Timer = get_node("../Timer")

func enter(new_machine:StateMachine) -> void:
	AppManager = new_machine.owner as Node
	super(new_machine)
