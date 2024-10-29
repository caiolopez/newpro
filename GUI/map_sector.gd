class_name MapSector extends Area2D

enum S {UNCHARTED = 0, CHARTING = 1, CHARTED = 2}
var status: S = S.UNCHARTED

func _ready():
	if get_children().filter(func(node): return node is CollisionPolygon2D).is_empty():
		push_error(self, " requires at least one CollisionPolygon2D node.")
		return

	body_entered.connect(func(body):
		if not body is Hero:
			return
		if not body.state_machine.current_state.death_prone:
			return

		if status == S.UNCHARTED:
			status = S.CHARTING
			Events.chart_map_sector.emit(self)
		)
		
	Events.hero_reached_checkpoint.connect(func():
		if status == S.CHARTING:
			status = S.CHARTED
		)

	Events.hero_respawned_at_checkpoint.connect(func():
		if status == S.CHARTING:
			status = S.UNCHARTED
			Events.unchart_map_sector.emit(self.get_path())
		)

func extract_coll_polygon_2d() -> CollisionPolygon2D:
	var poly: CollisionPolygon2D = null
	for child in get_children():
		if child is CollisionPolygon2D:
			poly = child
	return poly
