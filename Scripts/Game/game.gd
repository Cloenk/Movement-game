extends Node3D

signal shopstart
signal shopclose

@onready var next_round_timer = $NextRoundTimer
@onready var room_spawner = $RoomSpawner
@onready var entities = $Entities
@onready var enemies = $Enemies
@onready var player = $Player
@onready var shop_animations = $shop/ShopAnimations
@onready var shop = $shop

var Playing = true
var CanWin = false
var difficulty = 0
var enemyAmount = 2
var waveAmount = 2

var newgold = 0
var time = 0

func _ready():
	GameSignals.enemyKilled.connect(enemyKilled)
	player.transition.play("start")
	room_spawner.spawnRoom()

func _process(delta):
	if enemies.get_child_count() == 0 and CanWin:
		win()
		CanWin = false
	if Playing == true:
		time += 5 * delta

func win():
	Playing = false
	player.transition.play("stop")
	if difficulty == 4:
		waveAmount += 1
		enemyAmount -1
	difficulty += 1
	enemyAmount += 1
	next_round_timer.start()

func nextRoom():
	shopclose.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.canMove = true
	Playing = true
	player.transition.play("start")
	room_spawner.spawnRoom()
	newgold = 0
	GameSignals.newRound.emit()

func startShop():
	shopstart.emit()
	time = roundi(time)
	var timeAmount = (100 - time / (difficulty + enemyAmount + 1)) / 2
	shop.countGold(newgold, timeAmount)
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

func enemyKilled():
	newgold += 10
