extends Node

const A270DEG = 3 * PI / 2
const A90DEG = PI / 2
@export var bullet = preload("res://Bullet/bullet.tscn")

func _ready():
	pass

func _physics_process(delta):
	pass

func create_bullet(facing_direction := 1, origin := Vector2(0, 0),\
angle := 0.0, vel := Vector2(200, 0), accel := Vector2(0, 0)) -> Area2D:
	var bullet = bullet.instantiate()
	var bullet_angle = A270DEG+(facing_direction*(A90DEG+deg_to_rad(angle)))
	add_child(bullet)
	bullet.position = origin
	bullet.velocity = vel.rotated(bullet_angle)
	bullet.acceleration = accel.rotated(bullet_angle)
	return bullet
