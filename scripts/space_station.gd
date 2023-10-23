extends Node2D

var distance = 1000
@export var life = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.max_value = life
	$TextureProgressBar.value = life
	global_position = _get_random_position_in_radius(PlayerNode.global_position, distance)

func _process(delta):
	$TextureProgressBar.value = life

func _get_random_position_in_radius(center: Vector2, radius: float):
	var angle = randf_range(0, 2 * PI)
	return Vector2(
		center.x + radius * cos(angle),
		center.y + radius * sin(angle)
	)
	
# called when the enemy is hit by a bullet
func hit():
	# subtract the life by the total bullet damage
	life -= PlayerNode.bullet_damage
	
	# if there's no life left
	if life <= 0:
		# despawn the enemy
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Bullet and body.friendly:
		hit()
		body.queue_free()