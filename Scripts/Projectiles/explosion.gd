extends Node3D

var explosion_force = 25
var Damage
var size = 1
var extraparticles = 0

func _ready():
	$GPUParticles3D.set_amount($GPUParticles3D.get_amount() + extraparticles)
	scale = Vector3(size, size, size)
	$AnimationPlayer.play("Decay")
	await get_tree().physics_frame
	await get_tree().physics_frame
	push_away_objects()

func push_away_objects():
	for body in $ExplosionArea.get_overlapping_bodies():
		var body_pos = body.global_position
		var force_div = 1
		if body.is_in_group("Player"):
			body_pos.y -= 0.8
			force_div = 4
		var force_dir = self.global_position.direction_to(body_pos)
		var body_dist = (body_pos - self.global_position).length()
		var explosion_vec = lerp(0, explosion_force, 1 - clampf((1 / 5), 0, 1)) / force_div * force_dir
		if body.is_in_group("Player"):
			body.ExplosionVelocity += explosion_vec * explosion_force
		if body.is_in_group("Enemy"):
			body.DamageNode.Damage(Damage)

func delete():
	queue_free()
