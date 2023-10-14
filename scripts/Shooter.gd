'''
Shooting Script For Shooter Enemy
'''
extends Node2D

@export var bullet_scene: PackedScene
@export var reload_time = 0.9
@export var bullet_speed = 500
var _start_reload = 0

func _process(delta):
	# rotate the gun to the direction of the player
	look_at(PlayerNode.global_position)
	
	# auto shooting mechanism with a certain reload time
	if _start_reload <= 0:
		_shoot()
		_start_reload = reload_time
	else:
		_start_reload -= delta
		
func _shoot():
	for child in get_children():
		if !child is Sprite2D and child.visible:
			var bullet: Bullet = bullet_scene.instantiate()
			bullet.friendly = false
			bullet.global_position = child.global_position
			bullet.rotation = rotation
			bullet.velocity = Vector2(cos(rotation), sin(rotation)).normalized() * bullet_speed
			get_parent().get_parent().get_parent().add_child(bullet)
