extends Area2D

@export var velocity: Vector2 = Vector2(500, 0)
enum Direction {UP, DOWN, LEFT, RIGHT}
var was_col: bool = false
var diff: Vector2

func _ready():
	$DownRC.force_raycast_update()
	pass


func update_direction():
	var changed: bool
	changed = was_col != $DownRC.is_colliding()
	was_col = $DownRC.is_colliding()
	if not changed:
		return

	if $DownRC.is_colliding():
		diff = to_local($DownRC.get_collision_point()) - $CollisionShape2D.shape.get_rect().size/2
		move_local_y(diff.y)
		print(diff)
	
	if not $DownRC.is_colliding():
		self.rotation_degrees += 90
		velocity = velocity.rotated(deg_to_rad(90))
		


func _physics_process(delta):
	update_direction()
	global_position += velocity * delta

