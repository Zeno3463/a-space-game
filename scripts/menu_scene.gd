extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$Camera2D.enabled = true

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
	get_tree().paused = false
	PlayerNode.get_node("Camera2D").enabled = true

func _on_button_mouse_entered():
	$AnimationPlayer.play("scale")

func _on_button_mouse_exited():
	$AnimationPlayer.play_backwards("scale")
