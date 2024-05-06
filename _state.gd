class_name _State extends Node

var machine:StateMachine
var active:bool

func enter(new_machine:StateMachine) -> void:
	machine = new_machine
	active = true
	print("enter_state ", name)
	on_enter()

func on_enter() -> void:
	pass

func process(delta:float) -> void:
	on_process(delta)
	pass

func on_process(_delta:float) -> void:
	pass

func physics_process(delta:float) -> void:
	on_physics_process(delta)
	pass

func on_physics_process(_delta:float) -> void:
	pass

func exit() -> void:
	active = false
	#print("exit_state ", name)
	on_exit()
	pass

func on_exit():
	pass
