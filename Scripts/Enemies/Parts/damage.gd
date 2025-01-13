extends Node

@export var host : CharacterBody3D
@export var hp : float
@export var damagePercent : float = 100

func Damage(dmg):
	dmg / 100 * damagePercent
	hp -= dmg
	if hp <= 0:
		Death()

func Death():
	host.queue_free()
