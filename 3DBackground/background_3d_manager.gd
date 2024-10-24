extends CanvasLayer

var render_backgrounds: bool = true
var current_background: Node3D = null

func _ready() -> void:
	current_background = $Background3D

func set_render_backgrounds(state: bool) -> void:
	render_backgrounds = state
	current_background.visible = state
	if state:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
