class_name BossState extends _State

var boss: Node
var center: Vector2
var t: Timer

func enter(new_machine:StateMachine) -> void:
	t = get_node("../Timer")
	center =  $"../../Marker2D".global_position
	boss = new_machine.owner as Node
	super(new_machine)

