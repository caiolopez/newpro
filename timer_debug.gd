extends Timer

var was_stopped:= true
var just_started:= false

func _ready():
	connect("timeout", on_timeout)


func _process(delta):
	just_started = was_stopped and not is_stopped()
	was_stopped = is_stopped()
	if just_started:
		print("TIMER ", name, " STARTED")


func on_timeout():
	print("TIMER ", name, " TIMEOUT")
