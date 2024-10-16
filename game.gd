extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground
@onready var player = $Player
var score := 0:
	set(value):
		score = value
		hud.score = score

var scroll_speed = 100
#var player = null

func _ready():
	score = 0
	#player = get_tree().get_first_node_in_group("Player")
	#assert(player!=null) 
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


	pb.scroll_offset.y += delta*scroll_speed
	if pb.scroll_offset.y >= 5000:
		pb.scroll_offset.y = 0

func _on_player_laser_shot(laser_scene,location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)
 
func _on_enemy_killed(points):
	score += points
	print(score)

func _on_player_killed():
	gos.set_score(score)
	await get_tree().create_timer(1.5).timeout 
	gos.visible = true
