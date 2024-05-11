extends Area2D

var velocity: Vector2
var max_fall_speed = 1000
var acceleration: Vector2
var is_fire: bool
var is_foe: bool

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	velocity = velocity + acceleration * delta
	global_position += delta*velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("kills_bullets"):
		queue_free()


func _on_area_entered(area):
	print(area.get_class(), area.get_groups())
	if is_instance_of(area, Water):
		acceleration = Vector2(300, 800)
		pass


func _on_area_exited(area):
	if is_instance_of(area, Water):
		queue_free()
