class_name CameraState extends _State

var c:Camera2D

# The type of the state the CAMERA uses

func enter(new_machine:StateMachine) -> void:
 c = new_machine.owner as Camera2D
 super(new_machine)
