extends Node2D

@export var rotation_speed: float = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (PlayerNode.global_position - global_position).normalized()
	var rot = atan2(dir.y, dir.x)
	rotation = lerp_angle(rotation, rot, rotation_speed)
