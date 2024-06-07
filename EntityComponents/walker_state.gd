class_name WalkerState extends _State

var w: Node
var parent: CharacterBody2D


func enter(new_machine:StateMachine) -> void:
	w = new_machine.owner as Node
	parent = w.get_parent()
	super(new_machine)

