extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureProgressBar2.max_value = PlayerNode.max_life
	$TextureProgressBar2.value = PlayerNode.life
	$TextureProgressBar3.max_value = PlayerNode.max_points
	$TextureProgressBar3.value = PlayerNode.curr_points
