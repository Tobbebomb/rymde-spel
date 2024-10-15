class_name Player extends CharacterBody2D

@onready var animatedsprite :=$AnimatedSprite2D
@onready var shieldsprite :=$shieldsprite
signal laser_shot(laser_scene, location)
signal killed

@export var speed = 300
@export var rate_of_fire := 0.25
@export var hp = 1
@onready var muzzle = $Muzzle
@export var damage = 1
var laser_scene = preload( "res://laser.tscn")

var shoot_cd := false

func _process(delta):
	if Input.is_action_pressed("Shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire). timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	velocity = direction * speed
	if velocity.x < 0:
		animatedsprite.play("left")
	elif velocity.x > 0:
		animatedsprite.play("right")
	else:
		animatedsprite.play("defult")
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func take_damage(amount):
	hp -= amount
	if hp < 2:
		shieldsprite.visible=false
	if hp <= 0:
		die()


func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)
 
func die():
	killed.emit()
	queue_free()
