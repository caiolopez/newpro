class_name AppState extends _State

var app_manager: Node
@onready var t: Timer = get_node("../Timer")

func enter(new_machine:StateMachine) -> void:
	app_manager = new_machine.owner as Node
	super(new_machine)
