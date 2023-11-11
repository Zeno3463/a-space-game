'''
Shooting Script For Shooter Enemy
'''
extends Node2D

@export var bullet_scene: PackedScene
@export var reload_time = 0.9
@export var bullet_speed = 500
@export var radius = 500
@export var lifetime = 1
var _start_reload = 0

func _process(delta):
	# auto shooting mechanism with a certain reload time
	if _start_reload <= 0 and global_position.distance_to(PlayerNode.global_position) <= radius:
		_shoot()
		_start_reload = reload_time
	else:
		_start_reload -= delta

func _shoot():
	for child in get_children():
		if !child is Sprite2D and child.visible:
			var bullet = bullet_scene.instantiate()
			bullet.friendly = false
			bullet.global_position = child.global_position
			bullet.rotation = child.global_rotation
			bullet.velocity = Vector2(cos(child.global_rotation), sin(child.global_rotation)).normalized() * bullet_speed
			bullet.lifetime = lifetime
			get_tree().get_root().get_node("/root/Main Scene").add_child(bullet)
