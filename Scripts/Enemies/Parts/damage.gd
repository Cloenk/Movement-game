extends Node

@export var ParticleScene : PackedScene
@export var ParticlePos : Marker3D
@export var host : CharacterBody3D
@export var hp : float
@export var damagePercent : float = 100

func Damage(dmg):
	var particle = ParticleScene.instantiate()
	particle.global_position = ParticlePos.global_position
	particle.amount += dmg / 2
	host.get_parent().get_parent().entities.add_child(particle)
	dmg / 100 * damagePercent
	hp -= dmg
	if hp <= 0:
		Death()

func Death():
	host.queue_free()
