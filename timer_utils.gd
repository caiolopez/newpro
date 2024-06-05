extends Timer

@export var does_print: bool = false
var was_stopped:= true
var just_started:= false


func _ready():
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


func get_elapsed_time() -> float:
	var real_elapsed_time
	if is_stopped():
		real_elapsed_time = 0.0
	else:
		real_elapsed_time = wait_time - time_left
	return real_elapsed_time
