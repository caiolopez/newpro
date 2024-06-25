extends Node

signal hero_entered_water(water: Water, surface_global_pos: float)
signal hero_exited_water(water: Water)

signal hero_entered_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes, lock_position: Vector2)
signal hero_exited_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes)

signal hero_changed_dir(new_dir: float)

signal camera_shake(duration: float, amount: float)
signal camera_stop_shake()

signal hero_hit_teleporter(teleporter: Teleporter)

signal hero_reached_checkpoint()
signal hero_respawned_at_checkpoint()
signal hero_died()

signal chart_map_sector(sector: MapSector)
signal unchart_map_sector(sector: MapSector)

signal boss_trigger_entered(boss: Node)

