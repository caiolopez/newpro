extends Node

var bullet_res = preload("res://Bullet/Bullet.tscn")
const BULLET_POOL_SIZE: int = 50

func _ready():
	Events.hero_respawned_at_checkpoint.connect(return_all_bullets)
	for i in range(BULLET_POOL_SIZE):
		var bullet: Bullet = bullet_res.instantiate()
		$FreeBullets.add_child(bullet)
		bullet.visible = false


func place_bullet(facing_direction: int = 1, origin: Vector2 = Vector2(0, 0),\
vel:  Vector2 = Vector2(200, 0), is_foe: bool = true, bullet_type = Constants.BulletTypes.REGULAR, angle: float = 0.0, time_before_visible: float = 0, underwater_ammo: bool = false, owner_muzzle: Node2D = null):
	var bullet: Bullet
	if $FreeBullets.get_child_count() <= 0:
		bullet = bullet_res.instantiate()
		add_child(bullet)
		if DebugTools.print_stuff: print("Bullet pool size NEW RECORD! ", get_child_count())
	else:
		bullet = $FreeBullets.get_children()[0]
		bullet.reparent(self)
	var bullet_angle_deg = 270 + (facing_direction * (90 + angle))
	bullet.position = origin
	bullet.velocity = vel.rotated(deg_to_rad(bullet_angle_deg))
	bullet.is_foe = is_foe
	bullet.bullet_type = bullet_type
	bullet.rotation_degrees = bullet_angle_deg
	bullet.time_before_visible = time_before_visible
	bullet.is_underwater_ammo = underwater_ammo
	bullet.restart()
	bullet.color_owner_muzzle(owner_muzzle)


func release_bullet(bullet):
	bullet.visible = false
	bullet.get_node("AnimatedSprite2D").stop()
	# Changing visibility takes a frame to happen.
	bullet.call_deferred("reparent", $FreeBullets)


func return_all_bullets():
	for c in get_children():
		if c is Bullet:
			release_bullet(c)


func kill_all_foe_bullets():
	for c in get_children():
		if c is Bullet and c.is_foe:
			c.kill_bullet()
