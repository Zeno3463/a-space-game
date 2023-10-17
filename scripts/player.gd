extends CharacterBody2D

class_name Player

var dir = Vector2.ONE

var curr_points = 0
var max_points = 5

@onready var life = max_life
@onready var normal_color = $Gun/Sprite2D.modulate

### UPGRADABLE PARAMETERS ###
var acceleration = 200
var speed = 100
var bullet_speed = 500
var reload_time = 0.1
var bullet_damage = 1
var max_life = 10
### --------------------- ###

var acceleration_i = 0
var speed_i = 0
var bullet_speed_i = 0
var reload_time_i = 0
var bullet_damage_i = 0
var max_life_i = 0

@export var acc_list = [200, 210, 220, 230, 240, 250]
@export var speed_list = [100, 150, 200, 250, 300, 350]
@export var bullet_speed_list = [500, 550, 600, 650, 700, 750]
@export var reload_list = [0.1, 0.08, 0.06, 0.04, 0.02, 0.01]
@export var bullet_dmg_list = [1, 2, 3, 4, 5, 6]
@export var max_life_list = [10, 20, 40, 60, 80]

@export var damage_player_color: Color

func _process(delta):
	_handle_movement(delta)
	_handle_points()
	acceleration = acc_list[acceleration_i]
	speed = speed_list[speed_i]
	bullet_speed = bullet_speed_list[bullet_speed_i]
	reload_time = reload_list[reload_time_i]
	bullet_damage = bullet_dmg_list[bullet_damage_i]
	max_life = max_life_list[max_life_i]

# called when the player is hit
func hit():
	life -= 1
	$Camera2D.shake(50)
	$Gun/Sprite2D.modulate = damage_player_color
	await get_tree().create_timer(0.2).timeout
	$Gun/Sprite2D.modulate = normal_color

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

func _handle_movement(delta):
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

func _handle_points():
	if curr_points >= max_points:
		curr_points = 0
		max_points += 5
		Ui.get_node("Upgrades").position.y = 0
