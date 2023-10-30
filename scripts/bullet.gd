extends CharacterBody2D

# Define a class name for the bullet (used for referencing in code)
class_name Bullet

# Time until the bullet disappears
var lifetime = 1

# Determines if the bullet is friendly (doesn't harm allies)
var friendly = true

func _physics_process(delta):
	# Decrease the remaining lifetime of the bullet by the time that has passed since the last frame
	lifetime -= delta
	
	# Move the bullet and handle collisions with the environment
	move_and_slide()
	
	# Check if the bullet's lifetime has expired
	if lifetime <= 0:
		queue_free()

# This function is called when the bullet enters an Area2D (used for collision detection)
func _on_area_2d_body_entered(body):
	# Check if the entered body is an Enemy and the bullet is friendly
	if body is Enemy and friendly:
		# Call the hit() function on the enemy to deal damage
		body.hit()
		
		# Remove the bullet from the scene
		queue_free()
	
	# Check if the entered body is the Player and the bullet is not friendly
	if body is Player and not friendly:
		# Call the hit() function on the player to deal damage
		body.hit()
		
		# Remove the bullet from the scene
		queue_free()
