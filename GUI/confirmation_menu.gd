extends Control

signal confirmation_made(confirmed: bool)

func _ready() -> void:
	hide()
	$VBoxContainer/YesButton.pressed.connect(func(): _on_decision_made(true))
	$VBoxContainer/CancelButton.pressed.connect(func(): _on_decision_made(false))

func _unhandled_input(event):
	if visible and (event.is_action_pressed("ui_cancel")):
		_on_decision_made(false)

func ask_for_confirmation(label_text: String = "Are you sure?", button_text: String = "Yes") -> bool:
	$VBoxContainer/SureLabel.text = label_text
	$VBoxContainer/YesButton.text = button_text
	show()
	$VBoxContainer/CancelButton.grab_focus()
	
	var result = await confirmation_made
	hide()
	return result

func _on_decision_made(decision: bool):
	confirmation_made.emit(decision)
