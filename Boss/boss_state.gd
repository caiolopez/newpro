class_name BossState extends _State

var boss: Node

func enter(new_machine:StateMachine) -> void:
	boss = new_machine.owner as Node
	super(new_machine)

