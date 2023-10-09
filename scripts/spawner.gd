extends Node2D

@export var enemies: Array[PackedScene]
@export var max_enemies = 10
@export var spawn_freq = 0.5

var _start_spawn_freq = 0
var _curr_enemies = 0

func _ready():
	randomize()

func _process(delta):
	if _start_spawn_freq <= 0 && _curr_enemies < max_enemies:
		_spawn()
		_start_spawn_freq = spawn_freq
	else:
		_start_spawn_freq -= delta
		
func _spawn():
	var enemy = enemies.pick_random().instantiate()
	enemy.global_position = _get_random_position_in_radius(PlayerNode.global_position, 300)
	add_child(enemy)
	_curr_enemies +=1
	
func _get_random_position_in_radius(center: Vector2, radius: float):
	var angle = randf_range(0, 2 * PI)
	return Vector2(
		center.x + radius * cos(angle),
		center.y + radius * sin(angle)
	)

func despawn():
	_curr_enemies -= 1

