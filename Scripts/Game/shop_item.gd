extends Node2D
@onready var game = $"../.."
@onready var shop = $".."
@onready var price = $Price

@export var upgrade: Upgrade

var bought = false

func _ready():
	game.shopstart.connect(randomUpgrade)
	game.shopclose.connect(stopShop)

func randomUpgrade():
	bought = false
	if shop.availableUpgrades.size() > 0:
		upgrade = shop.availableUpgrades.pick_random()
		shop.availableUpgrades.erase(upgrade)
		price.text = upgrade.name

func stopShop():
	if bought == false:
		shop.availableUpgrades.append(upgrade)
	bought = false
	upgrade == null
	price.text = "oopsie"

func _on_buy_button_pressed():
	if shop.gold >= upgrade.Price and bought == false:
		bought = true
		shop.gold -= upgrade.Price
		shop.player.upgrades.AcquireItem(upgrade)
