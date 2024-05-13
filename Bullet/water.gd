class_name Water extends Area2D

signal hero_entered(water: Water, surface_global_pos: float)
signal hero_exited(water: Water)


func _ready():
	pass


func _process(delta):
	get_surface_global_position()
	pass


func get_surface_global_position() -> float:
	return ((get_node("CollisionShape2D").shape.extents * scale)-global_position).y


func _on_hero_entered(body):
	if not body.is_in_group("heroes"): return
	hero_entered.emit(self, get_surface_global_position())


func _on_hero_exited(body):
	if not body.is_in_group("heroes"): return
	hero_exited.emit(self)

