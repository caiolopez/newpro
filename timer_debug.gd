extends Timer


func _ready():
	connect("timeout", on_timeout)


func on_timeout():
	print("TIMER ", name, " TIMEOUT")
