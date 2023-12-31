extends CharacterBody2D

class_name Player

var dir = Vector2.ONE
var is_dashing = false
var can_dash = false
var can_bomb = false

var curr_points = 0
var max_points = 5

@onready var life = max_life
@onready var normal_color = $Gun/Sprite2D.modulate

### SHIP PARAMETERS ###
var shooter_class = 0
var bomber_class = 0
var booster_class = 0
### --------------- ###

### SHIP SPRITES ###
@export var shooter_classes: Array[Texture]
@export var booster_classes: Array[Texture]
@export var bomber_classes: Array[Texture]

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

var is_dead = false

var level = 0

@export var acceleration_list = [[200, 210, 220, 230, 240, 250]]
@export var speed_list = [[100, 150, 200, 250, 300, 350]]
@export var bullet_speed_list = [[500, 550, 600, 650, 700, 750]]
@export var reload_time_list = [[0.1, 0.08, 0.06, 0.04, 0.02, 0.01]]
@export var bullet_damage_list = [[1, 2, 3, 4, 5, 6]]
@export var max_life_list = [[10, 20, 40, 60, 80]]
@export var point_multiplier_list = [5, 20, 30]

@export var damage_player_color: Color
@export var explosion: PackedScene

func _process(delta):
	_handle_movement(delta)
	_handle_points()
	acceleration = acceleration_list[level][acceleration_i]
	speed = speed_list[level][speed_i]
	bullet_speed = bullet_speed_list[level][bullet_speed_i]
	reload_time = reload_time_list[level][reload_time_i]
	bullet_damage = bullet_damage_list[level][bullet_damage_i]
	max_life = max_life_list[level][max_life_i]

# called when the player is hit
func hit():
	$AudioStreamPlayer2D.play()
	if life <= 0: return
	life -= 1
	if life <= 0:
		is_dead = true
		$Sprite2D2.visible = false
		$Gun/Sprite2D.visible = false
		$Gun/Sprite2D2.visible = false
		$Gun/Sprite2D3.visible = false
		var explosion_node = explosion.instantiate()
		explosion_node.global_position = global_position
		get_tree().get_root().get_node("/root/Main Scene").add_child(explosion_node)
		await get_tree().create_timer(3).timeout
		_respawn()
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
	if is_dead: return
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
	if !is_dashing: set_velocity(dir)
	_handle_dash()
	move_and_slide()

func _handle_points():
	if curr_points >= max_points:
		curr_points = 0
		max_points += 5
		Ui.get_node("Upgrades").position.y = 0
		get_tree().paused = true
		Ui.get_node("AnimationPlayer").play("normal upgrade fade")

func upgrade_shooter_class():
	if shooter_class == 0:
		$Gun/back.visible = true
		$Gun/back2.visible = true
		$Gun/back3.visible = true
		$Gun/Sprite2D.set_texture(shooter_classes[0])
		shooter_class += 1

func upgrade_booster_class():
	if booster_class == 0:
		can_dash = true
		$Gun/Sprite2D2.set_texture(booster_classes[0])
		booster_class += 1

func upgrade_bomber_class():
	if bomber_class == 0:
		can_bomb = true
		$Gun/Sprite2D3.set_texture(bomber_classes[0])
		bomber_class += 1

func reset_upgrades():
	acceleration_i = 0
	speed_i = 0
	bullet_speed_i = 0
	reload_time_i = 0
	bullet_damage_i = 0
	max_life_i = 0

func _handle_dash():
	if not can_dash: return
	if Input.is_action_just_pressed("dash"):
		$Line2D.visible = true
		is_dashing = true
		set_velocity(Vector2(cos($Gun.rotation), sin($Gun.rotation)).normalized() * 150 * 10)
		await get_tree().create_timer(0.2).timeout
		set_velocity(Vector2.ZERO)
		is_dashing = false
		$Line2D.visible = false

func _respawn():
	reset_upgrades()
	is_dead = false
	$Sprite2D2.visible = true
	$Gun/Sprite2D.visible = true
	$Gun/Sprite2D2.visible = true
	$Gun/Sprite2D3.visible = true
	life = max_life
	max_points = point_multiplier_list[level]
	curr_points = 0
	Spawner.reset()
	SpaceStation.respawn()
	Ui.get_node("AnimationPlayer").play_backwards("black screen")
