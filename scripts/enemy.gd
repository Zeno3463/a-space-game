extends CharacterBody2D

# Define a class name for the enemy
class_name Enemy

# Load the explosion scene as a PackedScene
var explosion = preload("res://scenes/explosion.tscn")

# Set speed, life, and points as export variables
@export var speed = 50
@export var life = 5
@export var points = 1
@export var need_to_despawn = true

@onready var enemy_gfx = get_node_or_null("AnimatedSprite2D")

var dead = false

func _ready():
	# Set the initial life of the enemy using a TextureProgressBar
	$TextureProgressBar.max_value = life
	$TextureProgressBar.value = life

func _process(_delta):
	# Display the current life of the enemy on the TextureProgressBar every frame
	$TextureProgressBar.value = life
	
	# Rotate the enemy to face the player
	if enemy_gfx != null:
		$AnimatedSprite2D.look_at(PlayerNode.global_position)

func _physics_process(_delta):
	# Move the enemy towards the player with a certain speed
	var dir = (PlayerNode.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

# This function is called when the enemy is hit by a bullet
func hit():
	# Subtract the life of the enemy by the bullet damage from the player
	life -= PlayerNode.bullet_damage
	# Check if there's no life left
	if life <= 0 and not dead:
		destroy()
		
func destroy(can_add_points = true):
	if dead: return
	dead = true
	if need_to_despawn: Spawner.despawn()
	
	# Add the points corresponding to this enemy to the player's total points
	if can_add_points: PlayerNode.curr_points += points
	
	$AudioStreamPlayer2D.play()
	modulate = Color.TRANSPARENT
	
	# Create an explosion effect at the enemy's position
	var explosion_node = explosion.instantiate()
	explosion_node.global_position = global_position
	get_parent().add_child(explosion_node)
	
	await $AudioStreamPlayer2D.finished
	
	# Destroy the enemy
	queue_free()
