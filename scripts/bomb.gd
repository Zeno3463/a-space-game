extends CharacterBody2D

# time until bomb explodes
var lifetime = 1
var hit_player = false
var exploded = false

# determine if the bomb is friendly (doesn't do damage to player)
@export var friendly = true

# multiplier to adjust the bomb's speed
var bomb_speed_multiplier = 50

func _physics_process(delta):
	# Adjust the velocity of the bomb by multiplying it with a negative speed multiplier
	# This makes the bomb move in the opposite direction of its current velocity
	velocity *= -bomb_speed_multiplier

	# Decrease the remaining lifetime of the bomb by the time that has passed since the last frame
	lifetime -= delta

	# Move the bomb and handle collisions with the environment
	move_and_slide()

	# Check if the bomb's lifetime has expired
	if lifetime <= 0 and not exploded:
		exploded = true
		_explode()

	# Restore the original velocity of the bomb (reverting the speed adjustment)
	velocity /= -bomb_speed_multiplier

func _explode():
	var hit_smth = false
	# Iterate through all bodies overlapping with the bomb (using an Area2D as an area of effect)
	for child in $Area2D.get_overlapping_bodies():
		# Check if the overlapping body is of type Enemy and the bomb is friendly
		if child is Enemy and friendly:
			hit_smth = true
			# Call the hit() function on the enemy to deal damage
			child.hit()
			# Check if the enemy still exists (not already destroyed by a previous hit)
			if child != null:
				child.hit()
		elif not friendly and child is Player and not hit_player:
			hit_smth = true
			hit_player = true
			child.hit()
			if child != null:
				child.hit()
	if hit_smth:
		var player = AudioStreamPlayer2D.new()
		player.stream = preload("res://audio/explosion.wav")
		add_child(player)
		player.playing = true
	# Remove the bomb from the scene
	await $AnimationPlayer.animation_finished
	queue_free()
