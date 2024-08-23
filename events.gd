extends Node

signal hero_entered_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes, lock_position: Vector2)
signal hero_exited_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes)

signal hero_changed_dir(new_dir: float)

signal camera_shake(duration: float, amount: float)
signal camera_stop_shake()
signal camera_set_glpos(glpos: Vector2)

signal hero_hit_teleporter(teleporter: Teleporter)

signal hero_reached_checkpoint()
signal hero_respawned_at_checkpoint()
signal hero_spawned()
signal hero_died()

signal hero_got_collectible(type: StringName)

signal show_dialog(dialog: StringName)
signal hide_dialog()

signal chart_map_sector(sector: MapSector)
signal unchart_map_sector(sector_path: NodePath)

signal boss_trigger_entered(boss: Node)
