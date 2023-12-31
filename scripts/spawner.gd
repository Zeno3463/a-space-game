extends Node2D

@export var enemies = [[]]
@export var max_enemies = 10
@export var spawn_freq = 0.5
@export var mid_level: PackedScene

var _start_spawn_freq = 0
var _curr_enemies = 0
var can_spawn = true

func _ready():
	randomize()

func _process(delta):
	if not can_spawn: return
	if _start_spawn_freq <= 0 && _curr_enemies < max_enemies:
		_spawn()
		_start_spawn_freq = spawn_freq
	else:
		_start_spawn_freq -= delta

func _spawn():
	var pth = enemies[PlayerNode.level][randi() % len(enemies[PlayerNode.level])]
	var enemy = load(pth).instantiate()
	enemy.global_position = _get_random_position_in_radius(PlayerNode.global_position, 300)
	add_child(enemy)
	_curr_enemies +=1

func _get_random_position_in_radius(center: Vector2, radius: float):
	var angle = randf_range(0, 2 * PI)
	return Vector2(
		center.x + radius * cos(angle),
		center.y + radius * sin(angle)
	)

func destroy_all(last = false):
	can_spawn = false
	PlayerNode.get_node("Gun").can_shoot = false
	PlayerNode.get_node("Bomb Shooter").can_shoot = false
	for child in get_tree().get_root().get_node("/root/Main Scene").get_children():
		if child is Bullet:
			child.queue_free()
	for child in get_children():
		if child is Enemy or child is Swarm_Enemy:
			child.destroy(false)
	if not last:
		Ui.load_mid_level()
	else:
		Ui.load_end_screen()

func reset():
	for child in get_tree().get_root().get_node("/root/Main Scene").get_children():
		if child is Bullet:
			child.queue_free()
	for child in get_children():
		if child is Enemy or child is Swarm_Enemy:
			child.destroy(false)

func despawn():
	_curr_enemies -= 1

