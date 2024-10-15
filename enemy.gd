class_name Enemy extends Area2D
var rng = RandomNumberGenerator.new()
var enemydie := preload("res://enemydie.tscn")
signal killed
@onready var shield_upgrade = preload("res://Shield upgrade.tscn")
@export var speed = 150
@export var hp = 1
@export var points = 100

func _physics_process(delta):
	global_position.y += speed *  delta

func die():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.take_damage(1)
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		var effect := enemydie.instantiate()
		get_parent().add_child(effect)
		effect.position = position
		killed.emit(points)
		var result = rng.randi_range (0,5) 
		if result == 4:
			var shield=shield_upgrade.instantiate()
			shield.position = position
			get_parent().add_child(shield)
			
		die()
