extends Node3D

@onready var stats = $"../Stats"
@onready var shop = $shop
@onready var player = $".."
@onready var fast_fingers_timer = $FastFingersTimer

var Upgrades: Array[int] = []
var canLastStand = true
var bloodMoney = 0

func _ready():
	GameSignals.newRound.connect(nextRound)
	GameSignals.enemyKilled.connect(enemyKilled)

func AcquireItem(upgrade):
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
