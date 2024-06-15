class_name Water extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func get_surface_global_position() -> float:
	return (global_position - (get_node("CollisionShape2D").shape.extents * scale)).y


func _on_body_entered(body):
	if body is Hero:
		Events.hero_entered_water.emit(self, get_surface_global_position())
	elif body.has_node("Walker"):
		body.get_node("Walker").is_in_water = true
		body.get_node("Walker").last_water_surface = get_surface_global_position()


func _on_body_exited(body):
	if body is Hero:
		Events.hero_exited_water.emit(self)
	elif body.has_node("Walker"):
		body.get_node("Walker").is_in_water = false
