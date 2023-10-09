extends CharacterBody2D

class_name Bullet
var lifetime = 1
var friendly = true

func _physics_process(delta):
	lifetime -= delta
	move_and_slide()
	if lifetime <= 0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Enemy and friendly:
		body.hit()
		queue_free()
	if body is Player and not friendly:
		body.hit()
		queue_free()
