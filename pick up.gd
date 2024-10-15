extends Area2D

@export var speed = -200

func _physics_process(delta):
	global_position.y += -speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is Player:
		body.hp = 2
		body.shieldsprite.visible = true
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

