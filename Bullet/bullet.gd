extends Area2D

var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO
var is_fire := false
var is_foe := false

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	velocity += acceleration * delta
	global_position += delta*velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("kills_bullets"):
		queue_free()
