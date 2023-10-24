extends Node2D

@export var bullet_scene: PackedScene
var _start_reload = 0

func _process(delta):
	# Get the global position of the mouse
	var mouse_position = get_global_mouse_position()
	
	# Calculate the direction vector from the Node2D to the mouse position
	var direction = (mouse_position - global_position).normalized()
	
	# Calculate the angle in radians between the Node2D and the mouse position
	var angle = direction.angle()
	
	# Convert the angle to degrees and rotate the Node2D
	rotation_degrees = angle * 180 / PI
	
	# Auto shoot with a certain reload time
	if _start_reload <= 0:
		_shoot()
		_start_reload = PlayerNode.reload_time
	else:
		_start_reload -= delta
		
func _shoot():
	# iterate through all the bullet spawn points
	for child in get_children():
		# if the child is a bullet spawn point
		if !child is Sprite2D and child.visible:
			# instantiate a bullet node
			var bullet: Bullet = bullet_scene.instantiate()
			
			# adjust the position, rotation and velocity of the bullet accordingly
			bullet.global_position = child.global_position
			bullet.rotation = rotation
			bullet.velocity = Vector2(cos(rotation), sin(rotation)).normalized() * PlayerNode.bullet_speed
			
			if child.name.begins_with("back"):
				bullet.velocity *= -1
			
			# add the bullet to the scene
			get_parent().get_parent().add_child(bullet)
