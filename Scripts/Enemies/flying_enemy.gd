extends CharacterBody3D

@onready var BulletScene: PackedScene = preload("res://Scenes/Projectiles/FlyingEnemy/Bullet.tscn")
@onready var DMGParticles: PackedScene = preload("res://Scenes/Enemies/FlyingEnemy/squid_man_particles.tscn")
@onready var target = $"../Player"

var DodgeVelocity = Vector3()
var FlyingVelocity = Vector3()

var damage = 10
var hp = 100
var speed = 17
var state = "shoot"
var distance

func _ready():
	$DodgeTimer.start()

func _process(delta):
	if velocity.length() > 0:
		var direction = velocity.normalized()
		var target_rotation = Transform3D().looking_at(direction, Vector3.UP).basis
		$Meshes/LeftArm.basis = $Meshes/LeftArm.basis.slerp(target_rotation, 10 * delta)
		$Meshes/RightArm.basis = $Meshes/LeftArm.basis.slerp(target_rotation, 10 * delta)
		$Meshes/LeftLeg.basis = $Meshes/LeftArm.basis.slerp(target_rotation, 10 * delta)
		$Meshes/RightLeg.basis = $Meshes/LeftArm.basis.slerp(target_rotation, 10 * delta)
	if hp <= 0:
		queue_free()

func _physics_process(delta):
	distance = global_transform.origin.distance_to(target.global_position)
	$BulletStartPos.look_at(target.global_position)
	look_at(target.global_position, Vector3(0,1,0))
	
	if distance <= 4:
		state = "run"
	else:
		if distance >= 15:
			state = "chase"
		else:
			state = "shoot"
	
	if state == "chase":
		var direction = target.global_transform.origin - global_transform.origin
		if direction.length() > 0.1:
			direction = direction.normalized()
	
		FlyingVelocity = direction * speed + DodgeVelocity
		FlyingVelocity.y += 1
	else:
		if state == "run":
			var direction = target.global_transform.origin + global_transform.origin
			if direction.length() > 0.1:
				direction = direction.normalized()
			FlyingVelocity = direction * speed + DodgeVelocity
			FlyingVelocity.y += 5
		else:
			FlyingVelocity = lerp(velocity, Vector3(0,0,0), 0.05)
	DodgeVelocity = lerp(DodgeVelocity, Vector3(0,0,0), 0.07)
	velocity = FlyingVelocity + DodgeVelocity
	move_and_slide()

func shoot():
	var bul = BulletScene.instantiate()
	bul.global_position = $BulletStartPos.global_position
	bul.rotation.x = rotation.x
	bul.rotation.y = rotation.y
	bul.linear_velocity = $BulletStartPos.global_transform.basis.z * -1 * 60
	bul.dmg = damage
	get_parent().add_child(bul)

func Damage(dmg):
	hp -= dmg
	var particle = DMGParticles.instantiate()
	particle.global_position = $BulletStartPos.global_position
	particle.amount += dmg / 2
	get_parent().add_child(particle)

func _on_timer_timeout():
	if distance <= 50:
		shoot()

func _on_dodge_timer_timeout():
	var rand = randi_range(1,2)
	var randy = randi_range(5,20)
	var randside = randi_range(30,40)
	if rand == 1:
		DodgeVelocity = ($RightMark.global_transform.origin - $RightRay.global_transform.origin).normalized() * randside
		DodgeVelocity.y = randy
		$DodgeTimer.set_wait_time(randi_range(1,10))
		$DodgeTimer.start()
	else:
		DodgeVelocity = ($LeftMark.global_transform.origin - $LeftRay.global_transform.origin).normalized() * randside
		DodgeVelocity.y = randy
		$DodgeTimer.set_wait_time(randi_range(1,10))
		$DodgeTimer.start()
