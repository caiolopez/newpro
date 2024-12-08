extends Node

var bullet_res = preload("res://Bullet/Bullet.tscn")
const BULLET_POOL_SIZE: int = 50
var active_bullets: Array[Bullet] = []
var inactive_bullets: Array[Bullet] = []

func _ready() -> void:
	Events.hero_respawned_at_checkpoint.connect(return_all_bullets)
	_populate_pool()

func _populate_pool():
	for i in range(BULLET_POOL_SIZE):
		var bullet: Bullet = bullet_res.instantiate()
		add_child(bullet)
		inactive_bullets.append(bullet)
		bullet.global_position = Vector2(100000, 100000)

func place_bullet(
	facing_direction: int = 1,
	origin: Vector2 = Vector2(0, 0),
	vel: Vector2 = Vector2(200, 0),
	is_foe: bool = true, 
	bullet_type = Constants.BulletTypes.REGULAR, angle: float = 0.0, 
	time_before_visible: float = 0, underwater_ammo: bool = false, 
	owner_muzzle: Node2D = null
	):
	
	var bullet: Bullet
	if inactive_bullets.is_empty():
		bullet = bullet_res.instantiate()
		add_child(bullet)
		if DebugTools.print_stuff: 
			print("Bullet pool size NEW RECORD! ", get_child_count())
	else:
		bullet = inactive_bullets.pop_back()
	
	active_bullets.append(bullet)
	
	# Configure bullet
	var bullet_angle_deg = 270 + (facing_direction * (90 + angle))
	bullet.position = origin
	bullet.velocity = vel.rotated(deg_to_rad(bullet_angle_deg))
	bullet.is_foe = is_foe
	bullet.bullet_type = bullet_type
	bullet.rotation_degrees = bullet_angle_deg
	bullet.time_before_visible = time_before_visible
	bullet.is_underwater_ammo = underwater_ammo
	bullet.current_muzzle = owner_muzzle
	bullet.activate()

func _return_single_bullet(bullet: Bullet):
	active_bullets.erase(bullet)
	inactive_bullets.append(bullet)
	bullet.global_position = Vector2(100000, 100000)
	bullet.deactivate()

func return_bullet(bullet: Bullet):
	if bullet in active_bullets:
		_return_single_bullet(bullet)

func return_all_bullets():
	while not active_bullets.is_empty():
		_return_single_bullet(active_bullets.back())

func kill_all_foe_bullets():
	var bullets_to_kill = active_bullets.filter(func(bullet): return bullet.is_foe)
	for bullet in bullets_to_kill:
		bullet.kill_bullet()
