class_name ElevatorButton extends Area2D

@export var type: button_type
@onready var parent: ElevatorSystem = get_parent()
enum button_type {ORIGIN, DESTINATION}
var is_active: bool
var last_processed_bullet: Bullet = null

func _ready():
	set_inactive()
	area_entered.connect(on_area_entered)
	area_exited.connect(func(area): if area == last_processed_bullet:
		last_processed_bullet = null, CONNECT_DEFERRED)
	parent.tween_ended.connect(set_inactive)
	parent.was_reset.connect(set_inactive)

func on_area_entered(area):
	if not area is Bullet:
		return
	if area == last_processed_bullet:
		return
	last_processed_bullet = area
	if not is_active:
		if type == button_type.ORIGIN:
			parent.send_elevator_to(&"origin")
		if type == button_type.DESTINATION:
			parent.send_elevator_to(&"destination")
	area.kill_bullet()
	for b in parent.elevator_button_list:
		b.set_inactive()
	call_deferred("set_active")

func set_active():
	is_active = true
	$Sprite2D.modulate = Color.DARK_GREEN

func set_inactive():
	is_active = false
	call_deferred("_evaluate_inactivity")

func _evaluate_inactivity():
	var elevator_state = parent.current_state
	if type == elevator_state:
		$Sprite2D.modulate = Color.RED
	else:
		$Sprite2D.modulate = Color.WHITE
	
