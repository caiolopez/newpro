extends Node

@onready var timer: Timer = Timer.new()
signal combo_performed(combo: StringName)


func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(func():
		for child in get_children():
			if child is ComboSequence:
				child.i = 0
		)


func _input(event):
	if not event.is_pressed(): return
	
	timer.start()

	for child in get_children():
		if child is ComboSequence\
		and not child.seq.is_empty():
			if event.is_action_pressed(child.seq[child.i]):
				child.i += 1
				if child.i >= child.seq.size():
					print("Combo completed! ", child.name)
					combo_performed.emit(child.name)
					child.i = 0
			else:
				if event.is_action_pressed(child.seq[0]):
					child.i = 1
				else:
					child.i = 0
