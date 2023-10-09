extends CharacterBody2D

class_name Player

var dir = Vector2.ONE

var curr_points = 0
var max_points = 5

@onready var life = max_life

### UPGRADABLE PARAMETERS ###
@export var acceleration = 200
@export var speed = 100
@export var bullet_speed = 500
@export var reload_time = 0.1
@export var bullet_damage = 1
@export var max_life = 10
### --------------------- ###

func _process(delta):
	# handle basic movement with acceleration
	if Input.is_action_pressed("down"):
		dir.y += acceleration * delta
		if dir.y > speed: dir.y = speed
	elif Input.is_action_pressed("up"):
		dir.y -= acceleration * delta
		if dir.y < -speed: dir.y = -speed
	else:
		if dir.y > 1: 
			dir.y -= acceleration * delta
			if dir.y < 0: dir.y = 0
		if dir.y < 1:
			dir.y += acceleration * delta
			if dir.y > 0: dir.y = 0
	if Input.is_action_pressed("left"):
		dir.x -= acceleration * delta
		if dir.x < -speed: dir.x = -speed
	elif Input.is_action_pressed("right"):
		dir.x += acceleration * delta
		if dir.x > speed: dir.x = speed
	else:
		if dir.x > 1:
			dir.x -= acceleration * delta
			if dir.x < 0: dir.x = 0
		if dir.x < 1:
			dir.x += acceleration * delta
			if dir.x > 0: dir.x = 0
	
	# move the player according to the direction input by the player
	set_velocity(dir)
	move_and_slide()

# called when the player is hit
func hit():
	life -= 1

# called when a body hits the player
func _on_area_2d_body_entered(body):
	# if the body is an enemy
	if body is Enemy:
		# despawn the enemy
		Spawner.despawn()
		# hit the player
		hit()
		# destroy the body
		body.queue_free()
