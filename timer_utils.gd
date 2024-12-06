extends Timer

@export var does_print: bool = false
var was_stopped:= true
var just_started:= false


func _ready() -> void:
	if not does_print: return
	connect("timeout", on_timeout)


func _process(_delta):
	if not does_print: return
	just_started = was_stopped and not is_stopped()
	was_stopped = is_stopped()
	if just_started:
		print("TIMER ", name, " STARTED")


func on_timeout():
	if not does_print: return
	print("TIMER ", name, " TIMEOUT")
