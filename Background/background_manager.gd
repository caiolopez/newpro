extends CanvasLayer

var render_backgrounds: bool = true
var current_background: Node = null
var shutter: ColorRect = null
var intended_background_name: StringName = ""

const BACKGROUNDS = {
	"pink": "res://Background/Backgrounds/background_a.tscn",
	"green":"res://Background/Backgrounds/background_b.tscn"
	}

func _ready() -> void:
	shutter = $Shutter
	shutter.modulate.a = 0.0

func set_render_backgrounds(state: bool) -> void:
	render_backgrounds = state
	if not state:
		if current_background:
			current_background.queue_free()
			current_background = null
	else:
		if intended_background_name:
			change_background(intended_background_name)

func change_background(new_bg_name: StringName) -> void:
	if current_background and new_bg_name == intended_background_name: return
	intended_background_name = new_bg_name
	SaveManager.log_hero_change("current_background", intended_background_name)
	if not render_backgrounds: return

	await shutter.close()
	var background_scene = load(BACKGROUNDS[new_bg_name]).instantiate()
	if current_background: current_background.queue_free()
	add_child(background_scene)
	current_background = background_scene
	await shutter.open()

func reset() -> void:
	intended_background_name = ""
	if current_background:
		current_background.queue_free()
		current_background = null
