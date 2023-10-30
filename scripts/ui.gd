extends CanvasLayer

func _ready():
	for btn in $Upgrades/Control.get_children():
		if btn is Button:
			btn.pressed.connect(Callable(_on_upgrade_pressed).bind(btn.name))
	for btn in $"Ship Upgrade/Control".get_children():
		if btn is Button:
			btn.pressed.connect(Callable(_on_ship_upgrade_pressed).bind(btn.name))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TextureProgressBar2.max_value = PlayerNode.max_life
	$TextureProgressBar2.value = PlayerNode.life
	$TextureProgressBar3.max_value = PlayerNode.max_points
	$TextureProgressBar3.value = PlayerNode.curr_points

func _on_ship_upgrade_pressed(name):
	if name == "shooter_class":
		PlayerNode.upgrade_shooter_class()
	if name == "booster_class":
		PlayerNode.upgrade_booster_class()
	if name == "bomber_class":
		PlayerNode.upgrade_bomber_class()
	$"Ship Upgrade".position.y = -2000
	get_tree().paused = false

func _on_upgrade_pressed(name):
	if not get_tree().paused: return
	name = name + "_i"
	PlayerNode.set(name, PlayerNode.get(name) + 1)
	$Upgrades.position.y = -1000
	get_tree().paused = false
