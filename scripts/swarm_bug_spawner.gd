extends Node2D

class_name Swarm_Enemy

func _process(_delta):
	var count = 0
	for child in get_children():
		if child is Enemy:
			count += 1
	if count == 0:
		Spawner.despawn()
		queue_free()
		
func destroy(_temp):
	queue_free()
