class_name Door extends AnimatableBody2D

@export var duration: float = 1.0
@export var open_offset: Vector2 = Vector2(0.0, -100.0)
@export var auto_close_time: float = 0.0 ## If different than zero, will cause the door to automatically close after the specified time.
@export var state_machine: StateMachine ## The state machine that governs doors. Drag-and-drop the state-machine object to this field.
@onready var closed_pos: Vector2 = position
var door_tween: Tween
signal open_d()
signal close_d()


func _ready():
	if auto_close_time > 0:
		$StateMachine/TimerAutoClose.set_wait_time(auto_close_time)
	state_machine.start()


func _process(_delta):
	if Input.is_action_just_pressed("Debug Action 1"): open_d.emit()
	if Input.is_action_just_pressed("Debug Action 2"): close_d.emit()


func tween_door_to_origin():
	door_tween = create_tween()
	door_tween.tween_property(
		self,
		"position",
		closed_pos,
		duration).from_current().set_trans(Tween.TRANS_EXPO)
	door_tween.finished.connect($StateMachine/StateClosing.on_tween_finished)
	door_tween.finished.connect($StateMachine/StateRevFromOpening.on_tween_finished)
	

func tween_door_to_offset():
	door_tween = create_tween()
	door_tween.tween_property(
		self,
		"position",
		closed_pos + open_offset,
		duration).from_current().set_trans(Tween.TRANS_EXPO)
	door_tween.finished.connect($StateMachine/StateOpening.on_tween_finished)
	door_tween.finished.connect($StateMachine/StateRevFromClosing.on_tween_finished)
