extends Node

@export var host : CharacterBody3D
@export var area : Area3D
@export var damage : float
@export var DoKnockback : bool
var CanAttack = true

func _process(delta):
	for body in area.get_overlapping_bodies():
		if body.is_in_group("Player") and CanAttack:
			CanAttack = false
			$AttackTimer.start()
			body.damage(damage)
			if DoKnockback:
				var explosion_force = 15
				var body_pos = body.global_position
				var force_div = 1
				body_pos.y -= 0.8
				force_div = 4
				var force_dir = host.global_position.direction_to(body_pos)
				var explosion_vec = lerp(0, explosion_force, 1 - clampf((1 / 5), 0, 1)) / force_div * force_dir
				body.ExplosionVelocity += explosion_vec * explosion_force
				if body.is_on_floor():
					body.ExplosionVelocity.y = 0

func _on_attack_timer_timeout():
	CanAttack = true
