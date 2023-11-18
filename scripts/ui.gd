extends CanvasLayer

func _ready():
	for btn in $Upgrades/Control.get_children():
		if btn is Button:
			btn.pressed.connect(Callable(_on_upgrade_pressed).bind(btn.name))
	for child in $Upgrades/Control.get_children():
		child.get_node("TextureProgressBar").max_value = len(PlayerNode.get(child.name+"_list")) - 1

func _process(_delta):
	$TextureProgressBar2.max_value = PlayerNode.max_life
	$TextureProgressBar2.value = PlayerNode.life
	$TextureProgressBar3.max_value = PlayerNode.max_points
	$TextureProgressBar3.value = PlayerNode.curr_points
	for child in $Upgrades/Control.get_children():
		child.get_node("TextureProgressBar").max_value = len(PlayerNode.get(child.name+"_list")[PlayerNode.level])
		child.get_node("TextureProgressBar").value = PlayerNode.get(child.name+"_i")

func _on_upgrade_pressed(n):
	if not get_tree().paused: return
	if PlayerNode.get(n+"_i") >= len(PlayerNode.get(n+"_list")[0]) - 1: return
	n = n + "_i"
	PlayerNode.set(n, PlayerNode.get(n) + 1)
	$Upgrades.position.y = -1000
	$Upgrades.modulate = Color.TRANSPARENT
	if n == "max_life_i":
		PlayerNode.life = PlayerNode.max_life_list[PlayerNode.level][PlayerNode.max_life_i]
	get_tree().paused = false

func load_mid_level():
	await get_tree().create_timer(5).timeout
	get_node("AnimationPlayer").play("black screen")
	await get_tree().create_timer(1).timeout
	var mid_level = preload("res://scenes/mid_level.tscn").instantiate()
	add_child(mid_level)

func unload_mid_level():
	Spawner.can_spawn = true
	PlayerNode.get_node("Gun").can_shoot = true
	PlayerNode.get_node("Bomb Shooter").can_shoot = true
	PlayerNode.level += 1
	PlayerNode.reset_upgrades()
	get_node("mid level").queue_free()
	get_node("AnimationPlayer").play_backwards("black screen")
