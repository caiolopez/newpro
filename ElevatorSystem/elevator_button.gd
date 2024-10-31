class_name ElevatorButton extends Area2D

@export var type: button_type
@onready var parent: ElevatorSystem = get_parent()
enum button_type {ORIGIN, DESTINATION}
var is_active: bool

func _ready():
	set_inactive()
	area_entered.connect(on_area_entered)

func on_area_entered(area):
	if not area is Bullet: return
	if area.handled: return
	if not is_active:
		if type == button_type.ORIGIN:
			parent.send_elevator_to(&"origin")
		if type == button_type.DESTINATION:
			parent.send_elevator_to(&"destination")
	area.kill_bullet()

func set_active():
	is_active = true
	$Sprite2D.modulate = Color.DARK_GREEN

func set_inactive():
	is_active = false
	if type == parent.current_state:
		$Sprite2D.modulate = Color.RED
	else:
		$Sprite2D.modulate = Color.WHITE
	
