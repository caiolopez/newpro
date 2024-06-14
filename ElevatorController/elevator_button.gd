class_name ElevatorButton extends Area2D

@export var type: button_type
enum button_type {ORIGIN, DESTINATION}
var is_active: bool


func _ready():
	set_inactive()
	area_entered.connect(on_area_entered)
	get_parent().elevator.tween_ended.connect(set_inactive)

func on_area_entered(area):
	if not area is Bullet:
		return
	if not is_active:
		if type == button_type.ORIGIN:
			get_parent().push_origin()
		if type == button_type.DESTINATION:
			get_parent().push_destination()
	area.kill_bullet()
	for b in get_parent().get_children():
		if b is ElevatorButton:
			b.set_inactive()
	set_active()


func set_active():
	is_active = true
	$Sprite2D.modulate = Color.AQUA


func set_inactive():
	is_active = false
	$Sprite2D.modulate = Color.WHITE
