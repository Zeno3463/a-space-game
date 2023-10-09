extends CharacterBody2D

class_name Enemy

@export var speed = 50
@export var life = 5
@export var points = 1

func _ready():
	# set the initial life of the enemy
	$TextureProgressBar.max_value = life
	$TextureProgressBar.value = life

func _process(delta):
	# display the current life of the enemy every frame
	$TextureProgressBar.value = life
	
	# rotate the enemy to look at the player
	$AnimatedSprite2D.look_at(PlayerNode.global_position)

func _physics_process(delta):
	# move towards the player with a certain speed
	var dir = (PlayerNode.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

# called when the enemy is hit by a bullet
func hit():
	# subtract the life by the total bullet damage
	life -= PlayerNode.bullet_damage
	
	# if there's no life left
	if life <= 0:
		# despawn the enemy
		Spawner.despawn()
		
		# add the points corresponding to this enemy to the player's total points
		PlayerNode.curr_points += points
		
		# destroy the enemy
		queue_free()
