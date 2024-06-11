extends Node

const A270DEG = 3 * PI / 2
const A90DEG = PI / 2
@export var bullet_res = preload("res://Bullet/bullet.tscn")

func _ready():
	for i in range(Constants.BULLET_POOL_SIZE):
		var bullet: Bullet = bullet_res.instantiate()
		$FreeBullets.add_child(bullet)
		bullet.visible = false


func create_bullet(facing_direction: int = 1, origin: Vector2 = Vector2(0, 0),\
vel:  Vector2 = Vector2(200, 0), is_foe: bool = true, is_fire: bool = false, angle: float = 0.0):
	var bullet: Bullet
	if $FreeBullets.get_child_count() <= 0:
		bullet = bullet_res.instantiate()
		add_child(bullet)
		print("Bullet pool size NEW RECORD! ", get_child_count())
	else:
		bullet = $FreeBullets.get_children()[0]
		bullet.reparent(self)
	bullet.visible = true
	var bullet_angle = A270DEG+(facing_direction*(A90DEG+deg_to_rad(angle)))
	bullet.position = origin
	bullet.velocity = vel.rotated(bullet_angle)
	bullet.is_foe = is_foe
	bullet.is_fire = is_fire


func free_bullet(bullet):
	bullet.call_deferred("reparent", $FreeBullets)
	bullet.visible = false


func free_all_bullets():
	for c in get_children():
		if c is Bullet:
			free_bullet(c)
