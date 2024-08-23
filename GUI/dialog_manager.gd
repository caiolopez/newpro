extends Node

var dialogs = {
	"npc_greeting": [
		{"speaker": "npc", "text": "Hello, traveler! Welcome to our village."},
		{"speaker": "hero", "text": "Thank you! It's a lovely place."},
		{"speaker": "npc", "text": "I'm glad you like it. Enjoy your stay!"}
	],
	"shopkeeper": [
		{"speaker": "Shopkeeper", "text": "Welcome! What can I get for you?"},
		{"speaker": "Player", "text": "Just looking, thanks."},
		{"speaker": "Shopkeeper", "text": "Alright, let me know if you need anything."}
	]
}

var avatar_textures = {
	"hero": preload("res://hero.png"),
	"npc": preload("res://icon.svg"),
}

var current_dialog = []
var dialog_index: int = 0
var tween_chars: Tween
var tween_pos: Tween

@onready var dialog_box: NinePatchRect = $DialogBox
@onready var avatar: TextureRect = $DialogBox/Avatar
@onready var text_label: RichTextLabel = $DialogBox/MainText

func _ready() -> void:
	Events.show_dialog.connect(start_dialog)
	Events.hide_dialog.connect(hide_dialog)
	dialog_box.hide()

func _input(event: InputEvent) -> void:
	if not event.is_pressed(): return
	if event.is_action_pressed("up"):
		if text_label.visible_ratio < 1.0:
			text_label.visible_ratio = 1.0
			tween_chars.kill()
		else:
			show_next_line()

func start_dialog(key: StringName) -> void:
	current_dialog = dialogs.get(key, [])
	dialog_index = 0
	show_next_line()
	tween_dialog_box(true)

func show_next_line() -> void:
	if dialog_index < current_dialog.size():
		var line = current_dialog[dialog_index]
		text_label.text = line.text
		avatar.texture = avatar_textures.get(line.speaker.to_lower(), null)
		dialog_index += 1
		
		text_label.visible_ratio = 0
		
		tween_chars = create_tween()
		tween_chars.tween_property(text_label, "visible_ratio", 1.0, 0.02 * line.text.length())
	else:
		tween_dialog_box(false)

func hide_dialog() -> void:
	tween_chars.kill()
	text_label.visible_ratio = 1.0
	tween_dialog_box(false)

func tween_dialog_box(show: bool) -> void:
	if tween_pos and tween_pos.is_running():
		tween_pos.kill()
	
	var start_position = Vector2(dialog_box.position.x, 1080)
	var end_position = Vector2(dialog_box.position.x, 1080 - dialog_box.size.y)
	
	tween_pos = create_tween()
	if show:
		dialog_box.show()
		dialog_box.position = start_position
		tween_pos.tween_property(dialog_box, "position", end_position, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween_pos.tween_property(dialog_box, "position", start_position, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		tween_pos.tween_callback(dialog_box.hide)
