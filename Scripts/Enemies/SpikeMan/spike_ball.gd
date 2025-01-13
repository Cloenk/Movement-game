extends CharacterBody3D

@onready var DMGParticles: PackedScene = preload("res://Scenes/Enemies/SpikeBall/Spike_Particles.tscn")

var speed = 25
var accel = 3
var hp = 150
var damage = 25
var CanAttack = true

@onready var nav = $NavigationAgent3D
@onready var target = $"../Player".global_position
var direction = Vector3()

func _physics_process(delta):
	target = $"../Player".global_position
	var next = nav.get_next_path_position()
	var looking = next

	looking.y = global_position.y
	look_at(looking)
	nav.target_position = target

	direction = next - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func _process(delta):
	if hp <= 0:
		queue_free()
	if !$Animation.is_playing():
		$Animation.set_assigned_animation("Walk")
		$Animation.play()
	
	for body in $SpikeArea.get_overlapping_bodies():
		if body.is_in_group("Player") and CanAttack:
			CanAttack = false
			$AttackTimer.start()
			body.damage(damage)
			var explosion_force = 15
			var body_pos = body.global_position
			var force_div = 1
			body_pos.y -= 0.8
			force_div = 4
			var force_dir = self.global_position.direction_to(body_pos)
			var explosion_vec = lerp(0, explosion_force, 1 - clampf((1 / 5), 0, 1)) / force_div * force_dir
			body.ExplosionVelocity += explosion_vec * explosion_force
			if body.is_on_floor():
				body.ExplosionVelocity.y = 0

func Damage(dmg):
	hp -= dmg
	var particle = DMGParticles.instantiate()
	particle.global_position = $Meshes/Head.global_position
	particle.amount += dmg / 2
	get_parent().add_child(particle)

func _on_attack_timer_timeout():
	CanAttack = true
