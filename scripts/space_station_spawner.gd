extends Node2D

var distance = 1000
@export var space_stations: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn(0)

func spawn(id):
	global_position = _get_random_position_in_radius(PlayerNode.global_position, distance)
	var space_station = space_stations[id].instantiate()
	space_station.global_position = global_position
	get_parent().add_child.call_deferred(space_station)

func _get_random_position_in_radius(center: Vector2, radius: float):
	var angle = randf_range(0, 2 * PI)
	return Vector2(
		center.x + radius * cos(angle),
		center.y + radius * sin(angle)
	)

