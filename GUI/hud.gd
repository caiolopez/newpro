extends Node

func _ready() -> void:
	AppManager.game_paused.connect(func():
		process_mode = Node.PROCESS_MODE_DISABLED
		)
	AppManager.game_unpaused.connect(func():
		process_mode = Node.PROCESS_MODE_INHERIT
		)

func force_hide_hud_elements() -> void:
	$BossOverlay.hide_hp_bar()
	$MiniMap.hide_minimap()
	$Dialog.hide_dialog()
	$Dialog.hide_hint()
