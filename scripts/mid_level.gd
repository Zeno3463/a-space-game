extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is TextureButton:
			child.pressed.connect(Callable(_on_ship_upgrade_pressed).bind(child.name))

func _on_ship_upgrade_pressed(n):
	if n == "shooter_class":
		PlayerNode.upgrade_shooter_class()
	if n == "booster_class":
		PlayerNode.upgrade_booster_class()
	if n == "bomber_class":
		PlayerNode.upgrade_bomber_class()
	Ui.unload_mid_level()
