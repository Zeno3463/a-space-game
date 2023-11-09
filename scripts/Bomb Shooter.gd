extends Node2D

@export var bomb_scene: PackedScene
var _start_reload = 0
var can_shoot = true

func _process(delta):
	# Get the global position of the mouse
	var mouse_position = get_global_mouse_position()
	
	# Calculate the direction vector from the Node2D to the mouse position
	var direction = (mouse_position - global_position).normalized()
	
	# Calculate the angle in radians between the Node2D and the mouse position
	var angle = direction.angle()
	
	# Convert the angle to degrees and rotate the Node2D
	rotation_degrees = angle * 180 / PI
	
	# check if the player is allowed to shoot bombs; if not, exit the function
	if not PlayerNode.can_bomb: return
	
	if PlayerNode.is_dead or not can_shoot: return
	# Auto shoot with a certain reload time
	if _start_reload <= 0:
		_shoot()
		_start_reload = 0.5
	else:
		_start_reload -= delta
		
func _shoot():
	# iterate through all the bomb spawn points
	for child in get_children():
		# if the child is a bomb spawn point
		if !child is Sprite2D and child.visible:
			# instantiate a bomb node
			var bomb = bomb_scene.instantiate()
			
			# adjust the position, rotation and velocity of the bomb accordingly
			bomb.global_position = child.global_position
			bomb.rotation = rotation
			bomb.velocity = Vector2(cos(rotation), sin(rotation)).normalized()
			
			if child.name.begins_with("back"):
				bomb.velocity *= -1
			
			# add the bomb to the scene by attaching it to the parent's parent (grandparent) node
			get_parent().get_parent().add_child(bomb)
