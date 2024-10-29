extends Node

# Gameplay Signals
signal hero_entered_camera_locker(camera_locker: CameraTrigger, axes: Constants.Axes, lock_position: Vector2)
signal hero_exited_camera_locker(camera_locker: CameraTrigger, axes: Constants.Axes)
signal hero_changed_dir(new_dir: float)
signal hero_hit_teleporter(teleporter: Teleporter) # When a hero shot hits active teleporter
signal teleporters_activated(enabled: bool) # When hero collects powerup that activates teleporters
signal hero_reached_checkpoint()
signal hero_respawned_at_checkpoint()
signal hero_died()
signal hero_got_collectible(type: StringName)
signal boss_trigger_entered(boss: Node)

# Camera Signals
signal camera_shake(duration: float, amount: float)
signal camera_stop_shake()
signal camera_set_glpos(glpos: Vector2)

# UI Signals
signal curtain_fade_in_ended()
signal curtain_fade_out_ended()

signal show_dialog(dialog: StringName)
signal hide_dialog()
signal show_hint(hint: StringName)
signal show_hint_text(hint: String)
signal hide_hint()

signal chart_map_sector(sector: MapSectorTrigger)
signal unchart_map_sector(sector_path: NodePath)

signal request_new_game()
signal request_load_game()
