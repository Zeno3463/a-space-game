extends CPUParticles2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	await get_tree().create_timer(3).timeout
	queue_free()
