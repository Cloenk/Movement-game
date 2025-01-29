extends Node2D
@onready var game = $"../.."
@onready var background = $Background
@onready var sprite = $Icon
@onready var hover = $Hover
@onready var shop = $".."
@onready var item_name = $Hover/ItemName
@onready var description = $Hover/Description
@onready var bought_sprites = $boughtSprites
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
		if upgrade != null:
			price.text = str(upgrade.Price)
			item_name.text = upgrade.name
			description.text = upgrade.description
			sprite.texture = upgrade.Icon
			background.texture = upgrade.Icon

func stopShop():
	if bought == false:
		shop.availableUpgrades.append(upgrade)
	upgrade = null
	price.text = "Out of stock"
	sprite.texture = null
	background.texture = null
	bought_sprites.hide()

func _on_buy_button_pressed():
	if shop.gold >= upgrade.Price and bought == false:
		bought = true
		shop.availableUpgrades.erase(upgrade)
		shop.gold -= upgrade.Price
		shop.player.upgrades.AcquireItem(upgrade)
		bought_sprites.show()

func _on_buy_button_mouse_entered():
	hover.show()
func _on_buy_button_mouse_exited():
	hover.hide()
