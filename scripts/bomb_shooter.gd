extends Node2D

@export var bomb: PackedScene
@export var bomb_speed: float
@export var reload_time: float

var _start_reload = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (PlayerNode.global_position - global_position).normalized()
	rotation = atan2(dir.y, dir.x)
	
	if _start_reload <= 0:
		_shoot()
		_start_reload = reload_time
	else:
		_start_reload -= delta

func _shoot():
	var bomb_instance = bomb.instantiate()
	bomb_instance.friendly = false
	bomb_instance.global_position = global_position
	bomb_instance.velocity = Vector2(cos(rotation), sin(rotation)).normalized() * -bomb_speed
	get_tree().get_root().get_node("/root/Main Scene").add_child(bomb_instance)
