class_name ElevatorButton extends Area2D

@export var type: button_type
@onready var elevator_system: ElevatorSystem = _find_elevator_system()
enum button_type {ORIGIN, DESTINATION}
var is_active: bool

func _ready():
	set_inactive()
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if not area is Bullet: return
	if area.handled: return
	if not is_active:
		if type == button_type.ORIGIN:
			elevator_system.send_elevator_to(&"origin")
		if type == button_type.DESTINATION:
			elevator_system.send_elevator_to(&"destination")
	area.kill_bullet()

func set_active():
	is_active = true
	$Sprite2D.modulate = Color.DARK_GREEN

func set_inactive():
	is_active = false
	if type == elevator_system.current_state:
		$Sprite2D.modulate = Color.RED
	else:
		$Sprite2D.modulate = Color.WHITE

func _find_elevator_system() -> ElevatorSystem:
	var current_parent = get_parent()
	if current_parent is ElevatorSystem:
		return current_parent
	elif current_parent.get_parent() is ElevatorSystem:
		return current_parent.get_parent()
	return null
