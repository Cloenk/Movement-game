extends Node3D

@onready var next_round_timer = $NextRoundTimer
@onready var room_spawner = $RoomSpawner
@onready var entities = $Entities
@onready var enemies = $Enemies
@onready var player = $Player
@onready var shop_animations = $shop/ShopAnimations

var HasWon = false
var CanWin = false
var difficulty = 1
var enemyAmount = 2
var waveAmount = 2

func _ready():
	player.transition.play("start")
	room_spawner.spawnRoom()

func _process(delta):
	if enemies.get_child_count() == 0 and CanWin:
		win()
		CanWin = false

func win():
	player.transition.play("stop")
	if difficulty == 4:
		waveAmount += 1
		enemyAmount -1
	difficulty += 1
	enemyAmount += 1
	next_round_timer.start()

func nextRoom():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.canMove = true
	player.transition.play("start")
	room_spawner.spawnRoom()

func startShop():
	player.canMove = false
	for n in entities.get_children():
		entities.remove_child(n)
		n.queue_free()
	room_spawner.deleteRoom()
	player.resetCooldowns()
	shop_animations.play("showShop")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#$shop.show() do with animation

func _on_continue_pressed():
	shop_animations.play("HideShop")
