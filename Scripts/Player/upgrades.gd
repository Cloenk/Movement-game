extends Node3D

@onready var stats = $"../Stats"
@onready var player = $".."

var Upgrades: Array[int] = []
var canLastStand = true

func _ready():
	GameSignals.newRound.connect(nextRound)

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
	canLastStand = true
	if Upgrades.has(2):
		player.shooting.IsSwordBroken = false
