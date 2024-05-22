class_name Water extends Area2D


func _ready():
	body_entered.connect(_on_hero_entered)
	body_exited.connect(_on_hero_exited)


func get_surface_global_position() -> float:
	return ((get_node("CollisionShape2D").shape.extents * scale)-global_position).y


func _on_hero_entered(body):
	if not body.is_in_group("heroes"): return
	Events.hero_entered_water.emit(self, get_surface_global_position())


func _on_hero_exited(body):
	if not body.is_in_group("heroes"): return
	Events.hero_exited_water.emit(self)
