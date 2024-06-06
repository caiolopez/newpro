extends Node

const A270DEG = 3 * PI / 2
const A90DEG = PI / 2
@export var bullet_res = preload("res://Bullet/bullet.tscn")

func _ready():
	pass

func _physics_process(_delta):
	pass

func create_bullet(facing_direction: int = 1, origin: Vector2 = Vector2(0, 0),\
vel:  Vector2 = Vector2(200, 0), is_foe: bool = true, is_fire: bool = false, angle: float = 0.0):
	var bullet = bullet_res.instantiate()
	var bullet_angle = A270DEG+(facing_direction*(A90DEG+deg_to_rad(angle)))
	add_child(bullet)
	bullet.position = origin
	bullet.velocity = vel.rotated(bullet_angle)
	bullet.is_foe = is_foe
	bullet.is_fire = is_fire


func free_all_bullets():
	for c in get_children():
		if c is Bullet:
			c.queue_free()
