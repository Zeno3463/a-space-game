extends Control

@export var highlighted_color: Color
var selected = false
var final_upgrade_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is TextureButton:
			child.pressed.connect(Callable(_on_ship_upgrade_pressed).bind(child))

func _on_ship_upgrade_pressed(n):
	$Label3.text = n.txt
	$Label4.text = n.txt
	$TextureRect2.texture = n.texture_normal
	for child in get_children():
		if child is TextureButton:
			child.modulate = Color.WHITE
	n.modulate = highlighted_color
	final_upgrade_name = n.name
	selected = true

func _on_button_pressed():
	if not selected: return
	if final_upgrade_name == "shooter_class":
		PlayerNode.upgrade_shooter_class()
	if final_upgrade_name == "booster_class":
		PlayerNode.upgrade_booster_class()
	if final_upgrade_name == "bomber_class":
		PlayerNode.upgrade_bomber_class()
	Ui.unload_mid_level()
