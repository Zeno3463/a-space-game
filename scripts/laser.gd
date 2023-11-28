extends Node2D

@export var rotation_speed: float = 20
@export var radius = 50
@export var reload = 0.5
var _is_shooting = false
var _start_reload = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (PlayerNode.global_position - global_position).normalized()
	var rot = atan2(dir.y, dir.x)
	rotation = lerp_angle(rotation, rot, rotation_speed)
	# auto shooting mechanism with a certain reload time
	if global_position.distance_to(PlayerNode.global_position) <= radius:
		_shoot(delta)
	else:
		$Sprite2D.visible = false

func _shoot(delta):
	_is_shooting = true
	$Sprite2D.visible = true
	if $Sprite2D/Area2D.overlaps_body(PlayerNode):
		if _start_reload <= 0:
			PlayerNode.hit()
			PlayerNode.hit()
			_start_reload = reload
		else:
			_start_reload -= delta
	else:
		_start_reload = 0
