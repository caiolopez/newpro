extends Node

func force_hide_hud_elements() -> void:
	$BossOverlay._hide_hp_bar()
	$MiniMap.hide_minimap()
	$Dialog.hide_dialog()
	$Dialog.hide_hint()
