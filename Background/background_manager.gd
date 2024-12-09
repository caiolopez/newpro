extends CanvasLayer

var render_backgrounds: bool = true
var current_background: Node = null
var shutter: ColorRect = null
var intended_background_name: StringName = ""
var background_instances: Dictionary = {} 

const BACKGROUNDS = {
	"pink": "res://Background/Backgrounds/background_a.tscn",
	"green":"res://Background/Backgrounds/background_b.tscn"
	}

func _ready() -> void:
	shutter = $Shutter
	shutter.modulate.a = 0.0
	_instantiate_backgrounds_and_disable()

func _instantiate_backgrounds_and_disable() -> void:
	for bg_name in BACKGROUNDS:
		var background_scene = load(BACKGROUNDS[bg_name]).instantiate()
		background_scene.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(background_scene)
		move_child(background_scene, 0)
		background_instances[bg_name] = background_scene

func change_background(new_bg_name: StringName) -> void:
	if not BACKGROUNDS.has(new_bg_name):
		push_error("Invalid background name: " + new_bg_name)
		return
	if current_background and new_bg_name == intended_background_name: return
	intended_background_name = new_bg_name
	SaveManager.log_hero_change("current_background", intended_background_name)
	if not render_backgrounds: return

	await shutter.close()
	if current_background:
		current_background.process_mode = Node.PROCESS_MODE_DISABLED
	current_background = background_instances[new_bg_name]
	current_background.process_mode = Node.PROCESS_MODE_INHERIT
	await shutter.open()

func set_render_backgrounds(state: bool) -> void:
	render_backgrounds = state
	if not state:
		if current_background:
			current_background.queue_free()
			current_background = null
	else:
		if intended_background_name:
			change_background(intended_background_name)

func reset() -> void:
	intended_background_name = ""
	if current_background:
		current_background.queue_free()
		current_background = null
