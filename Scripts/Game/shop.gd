extends Control

@onready var kills_gold = $"GoldCounting/Kills gold"
@onready var blood_gold = $"GoldCounting/Blood Gold"
@onready var time_gold = $"GoldCounting/Time Gold"
@onready var total_gold = $"GoldCounting/Total gold"
@onready var bloodgoldsprite = $GoldCounting/bloodgoldsprite
@onready var gold_counting = $GoldCounting
@onready var goldCounter = $Gold
@onready var player = $"../Player"

@export var availableUpgrades: Array[Upgrade]
var gold = 0

func _process(delta):
	goldCounter.text = str(gold)

func countGold(KG, TG):
	if !player.upgrades.bloodMoney == 0:
		gold += player.upgrades.bloodMoney
		blood_gold.text = str(player.upgrades.bloodMoney)
		blood_gold.show()
		bloodgoldsprite.show()
	else:
		blood_gold.hide()
		bloodgoldsprite.hide()
	if TG > 0:
		time_gold.text = str(TG)
		gold += (KG + TG)
	else:
		time_gold.text = str(0)
		gold += KG
	kills_gold.text = str(KG)
	total_gold.text = str(gold)
	gold_counting.show()

func _on_okay_button_pressed():
	gold_counting.hide()
