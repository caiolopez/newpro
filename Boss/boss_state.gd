class_name BossState extends _State

var boss: Node
@onready var t: Timer = get_node("../Timer")

func enter(new_machine:StateMachine) -> void:
	boss = new_machine.owner as Node
	super(new_machine)
