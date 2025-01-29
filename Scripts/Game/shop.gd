extends Control

@onready var kills_gold = $"GoldCounting/Kills gold"
@onready var time_gold = $"GoldCounting/Time Gold"
@onready var total_gold = $"GoldCounting/Total gold"
@onready var gold_counting = $GoldCounting
@onready var goldCounter = $Gold
@onready var player = $"../Player"

@export var availableUpgrades: Array[Upgrade]
var gold = 1000

func _process(delta):
	goldCounter.text = str(gold)

func countGold(KG, TG):
	#var test = availableUpgrades.pick_random()
	#availableUpgrades.erase(test)
	gold_counting.show()
	if TG > 0:
		time_gold.text = str(TG)
		gold += (KG + TG)
	else:
		time_gold.text = str(0)
		gold += KG
	kills_gold.text = str(KG)
	total_gold.text = str(gold)

func _on_okay_button_pressed():
	gold_counting.hide()
