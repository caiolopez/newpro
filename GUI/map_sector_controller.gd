class_name MapSectorController extends Area2D

enum S {UNCHARTED = 0, CHARTING = 1, CHARTED = 2}

func _ready() -> void:
	if get_children().filter(func(node): return node is CollisionPolygon2D).is_empty():
		push_error(self, " requires at least one CollisionPolygon2D node.")
		return

	body_shape_entered.connect(func(_rid, body: Node2D, _body_shape, area_shape_index: int):
		if not body is Hero and not body.state_machine.current_state.death_prone:
			return

		var sector: MapSectorTrigger = Utils.get_collision_polygon_by_index(self, area_shape_index)
		if sector.status == S.UNCHARTED:
			sector.status = S.CHARTING
			Events.chart_map_sector.emit(sector)
	)
	
	Events.hero_reached_checkpoint.connect(func():
		for sector in get_children():
			if sector is MapSectorTrigger and sector.status == S.CHARTING:
				sector.status = S.CHARTED
	)

	Events.hero_respawned_at_checkpoint.connect(func():
		for sector in get_children():
			if sector is MapSectorTrigger and sector.status == S.CHARTING:
				sector.status = S.UNCHARTED
				Events.unchart_map_sector.emit(sector.get_path())
	)
