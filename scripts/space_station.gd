extends Node2D

@export var life = 1000
@export var last = false
var explosion = preload("res://scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.max_value = life
	$TextureProgressBar.value = life

func _process(_delta):
	$TextureProgressBar.value = life

# called when the enemy is hit by a bullet
func hit():
	# subtract the life by the total bullet damage
	life -= PlayerNode.bullet_damage
	
	var explosion_node = explosion.instantiate()
	explosion_node.global_position = global_position
	get_parent().add_child(explosion_node)
	
	# if there's no life left
	if life <= 0:
		Spawner.destroy_all(last)
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Bullet and body.friendly:
		hit()
		if self != null:
			hit()
		body.queue_free()
