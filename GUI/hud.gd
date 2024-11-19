extends Node

func _ready() -> void:
	AppManager.game_paused.connect(func():
		process_mode = Node.PROCESS_MODE_DISABLED
		for child in get_children():
			child.hide()
		)
	AppManager.game_unpaused.connect(func():
		process_mode = Node.PROCESS_MODE_INHERIT
		for child in get_children():
			child.show()
		)

func force_hide_hud_elements() -> void:
	$BossOverlay._hide_hp_bar()
	$MiniMap.hide_minimap()
	$Dialog.hide_dialog()
	$Dialog.hide_hint()
