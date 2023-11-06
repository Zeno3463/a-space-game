extends CanvasLayer

func _ready():
	for btn in $Upgrades/Control.get_children():
		if btn is Button:
			btn.pressed.connect(Callable(_on_upgrade_pressed).bind(btn.name))
	for btn in $"Ship Upgrade/Control".get_children():
		if btn is Button:
			btn.pressed.connect(Callable(_on_ship_upgrade_pressed).bind(btn.name))
	for child in $Upgrades/Control.get_children():
		child.get_node("TextureProgressBar").max_value = len(PlayerNode.get(child.name+"_list")) - 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TextureProgressBar2.max_value = PlayerNode.max_life
	$TextureProgressBar2.value = PlayerNode.life
	$TextureProgressBar3.max_value = PlayerNode.max_points
	$TextureProgressBar3.value = PlayerNode.curr_points
	for child in $Upgrades/Control.get_children():
		child.get_node("TextureProgressBar").value = PlayerNode.get(child.name+"_i")

func _on_ship_upgrade_pressed(name):
	if name == "shooter_class":
		PlayerNode.upgrade_shooter_class()
	if name == "booster_class":
		PlayerNode.upgrade_booster_class()
	if name == "bomber_class":
		PlayerNode.upgrade_bomber_class()
	$"Ship Upgrade".position.y = -2000
	$"Ship Upgrade".modulate = Color.TRANSPARENT
	get_tree().paused = false

func _on_upgrade_pressed(name):
	if not get_tree().paused: return
	if PlayerNode.get(name+"_i") >= len(PlayerNode.get(name+"_list")) - 1: return
	name = name + "_i"
	PlayerNode.set(name, PlayerNode.get(name) + 1)
	$Upgrades.position.y = -1000
	$Upgrades.modulate = Color.TRANSPARENT
	if name == "max_life_i":
		PlayerNode.life = PlayerNode.max_life_list[PlayerNode.max_life_i]
	get_tree().paused = false
