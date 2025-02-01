extends Sprite2D

var upgrade

@onready var item_name = $ItemName
@onready var description = $Description

func _ready():
	texture = upgrade.Icon
	item_name.text = upgrade.name
	description.text = upgrade.description
