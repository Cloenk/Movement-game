extends Node3D

@onready var ItemShowerScene: PackedScene = preload("res://Scenes/Player/item_shower.tscn")

@onready var stats = $"../Stats"
@onready var shop = $shop
@onready var player = $".."
@onready var fast_fingers_timer = $FastFingersTimer
@onready var upgrades_menu = $"../UI/UpgradesMenu"
@onready var markers = $"../UI/UpgradesMenu/markers"

var Upgrades: Array[int] = []
var UpgradesAmount = -1
var canLastStand = true
var bloodMoney = 0

func _ready():
	GameSignals.newRound.connect(nextRound)
	GameSignals.enemyKilled.connect(enemyKilled)

func _input(event):
	if event.is_action_pressed("open inventory"):
		if upgrades_menu.is_visible():
			upgrades_menu.hide()
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			upgrades_menu.show()
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func AcquireItem(upgrade):
	UpgradesAmount += 1
	match upgrade.ID:
		1:
			stats.DamagePercent -= 20
			Upgrades.append(1)
		2:
			stats.MeleeDamage += 30
			Upgrades.append(2)
			GameSignals.bigBlow.connect(destroyMeelee)
		3:
			Upgrades.append(3)
		4:
			Upgrades.append(4)
		5:
			Upgrades.append(5)
		6:
			Upgrades.append(6)
	addItemToMenu(upgrade)

func addItemToMenu(upgrade):
	var itemShower = ItemShowerScene.instantiate()
	itemShower.upgrade = upgrade
	upgrades_menu.add_child(itemShower)
	itemShower.global_position = markers.get_child(UpgradesAmount).global_position

func takeDamage(dmg):
	if Upgrades.has(5):
		bloodMoney += dmg * 2

func enemyKilled():
	if Upgrades.has(6):
		stats.HP += 5
		if stats.HP >= stats.MaxHP:
			stats.HP = stats.MaxHP

func lastStand():
	if Upgrades.has(3) and canLastStand:
		stats.HP = 1
		canLastStand = false
		return true
	else:
		return false

func destroyMeelee():
	player.shooting.IsSwordBroken = true

func nextRound():
	bloodMoney = 0
	canLastStand = true
	if Upgrades.has(2):
		player.shooting.IsSwordBroken = false

func shotsFired():
	if Upgrades.has(4):
		stats.speed = stats.defaultSpeed + 12
		fast_fingers_timer.start()
func _on_fast_fingers_timer_timeout():
	stats.speed = stats.defaultSpeed
