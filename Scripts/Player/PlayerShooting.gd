extends Node3D

@onready var TracerScene: PackedScene = preload("res://Scenes/Player/BulletTracer.tscn")
@onready var BulletScene: PackedScene = preload("res://Scenes/Projectiles/Player/bullet.tscn")
@onready var ExplosionScene: PackedScene = preload("res://Scenes/Projectiles/explosion.tscn")
@onready var laserScene: PackedScene = preload("res://Scenes/Projectiles/Player/laser.tscn")
@onready var BallScene: PackedScene = preload("res://Scenes/Player/ball.tscn")

@onready var stats = $"../Stats"
@onready var shooting_start = $"../Head/ShootingStart"
@onready var hand_animations = $"../ShootingAnimation"
@onready var bomb_animation = $"../BombAnimation"
@onready var melee_animation = $"../MeleeAnimation"
@onready var hand = $"../Head/Hand"


var SelectedWeapon = 1
var IsReady = true
var CanShoot = true
var CanCharge = true
var CanBomb = true
var CanBall = true
var CanSlash = true
var CanDash = true
var IsCharging = false
var ChargeMeter = 0.0

var delta

func _ready():
	hand.position = Vector3(0.565,-0.135,-0.776)
	hand.texture = load("res://Assets/Textures/Weapons/HandIdle.png")

func _process(delta):
	self.delta = delta
	if $"../Head/ShootingRayCast".is_colliding():
		$"../Head/ShootingStart".look_at($"../Head/ShootingRayCast".get_collision_point())
	else:
		$"../Head/ShootingStart".look_at($"../Head/ShootingRayCastEnd".global_position)
	
	if $"../Head/SlashArea".is_monitoring():
		for body in $"../Head/SlashArea".get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.Damage(stats.MeleeDamage)
				$"../Head/SlashArea".set_monitoring(false)
			if body.is_in_group("Ball"):
				body.linear_velocity = shooting_start.global_transform.basis.z * -1 * 50
				body.boost += 25
	
	if Input.is_action_just_pressed("Weapon one"):
		hand_animations.stop()
		bomb_animation.stop()
		melee_animation.stop()
		SelectedWeapon = 1
		IsReady = false
		IsCharging = false
		ChargeMeter = 0
		$ReadyTimer.start()
		$"../Head/Hand/BombCharge".hide()
		hand.texture = load("res://Assets/Textures/Weapons/HandIdle.png")
		hand.position = Vector3(0.565,-0.135,-0.776)
		get_parent().defaultPos = Vector3(0.565,-0.135,-0.776)
		hand.scale = Vector3(0.14,0.14,0.14)
		$"../Head/ShootingStart".position = Vector3(0.5,-0.255,-0.845)
	if Input.is_action_just_pressed("Weapon two"):
		hand_animations.stop()
		bomb_animation.stop()
		melee_animation.stop()
		SelectedWeapon = 2
		IsReady = false
		IsCharging = false
		ChargeMeter = 0
		$ReadyTimer.start()
		$"../Head/Hand/BombCharge".hide()
		hand.texture = load("res://Assets/Textures/Weapons/HandPoint.png")
		hand.position = Vector3(0.55,0.035,-0.776)
		get_parent().defaultPos = Vector3(0.55,0.035,-0.776)
		hand.scale = Vector3(0.14,0.14,0.14)
		$"../Head/ShootingStart".position = Vector3(0.284,-0.333,-0.845)
	if Input.is_action_just_pressed("weapon three"):
		hand_animations.stop()
		bomb_animation.stop()
		melee_animation.stop()
		SelectedWeapon = 3
		IsReady = false
		IsCharging = false
		ChargeMeter = 0
		$ReadyTimer.start()
		$"../Head/Hand/BombCharge".hide()
		hand.texture = load("res://Assets/Textures/Weapons/MantisBlade.png")
		hand.position = Vector3(0.38,-0.245,-0.776)
		get_parent().defaultPos = Vector3(0.38,-0.245,-0.776)
		hand.scale = Vector3(0.14,0.14,0.14)
	
	if Input.is_action_pressed("Shoot") and IsReady and IsCharging == false:
		if SelectedWeapon == 1 and CanShoot:
			CanShoot = false
			$ShootingTimer.set_wait_time(stats.AttackSpeed)
			$ShootingTimer.start()
			hand_animations.stop()
			hand_animations.play("Shoot")
			ShootBullet()
		if SelectedWeapon == 2 and CanBomb:
			CanBomb = false
			$BombTimer.set_wait_time(stats.BombCooldown)
			$BombTimer.start()
			bomb_animation.stop()
			bomb_animation.play("Bomb")
			ShootBomb()
		if SelectedWeapon == 3 and CanSlash:
			CanSlash = false
			$SlashTimer.set_wait_time(stats.MeleeSpeed)
			$SlashTimer.start()
			melee_animation.stop()
			melee_animation.play("Slash")
	
	if Input.is_action_pressed("AltFire") and IsReady and IsCharging == false:
		if SelectedWeapon == 2 and CanBall:
			ShootBall()
			CanBall = false
			$BallTimer.set_wait_time(stats.BallCooldown)
			$BallTimer.start()
		if SelectedWeapon == 3 and CanDash:
			get_parent().SecondDash()
			CanDash = false
			$DashTimer.set_wait_time(stats.MeleeDashCooldown)
			$DashTimer.start()

func _physics_process(delta):
	if Input.is_action_pressed("AltFire"):
		if SelectedWeapon == 1 and CanCharge:
			IsCharging = true
	else:
		if SelectedWeapon == 1:
			IsCharging = false

	if IsCharging == true:
		var ScaleAmount = ChargeMeter * 14
		ChargeMeter += 5 * delta
		$"../Head/Hand/ChargeFlash".show()
		$"../Head/Hand/ChargeFlash".rotation.z += 14 * delta
		$"../Head/Hand/ChargeFlash".scale = Vector3(ScaleAmount, ScaleAmount, ScaleAmount)
		if !$"../ChargeAnimation".is_playing():
			$"../ChargeAnimation".play("Charge")
		if ChargeMeter >= 2.5:
			ChargeMeter = 2.5
	else:
		$"../Head/Hand/ChargeFlash".hide()

	if Input.is_action_just_released("AltFire"):
		if SelectedWeapon == 1:
			if ChargeMeter >= 2.5:
				CanCharge = false
				IsCharging = false
				ChargeMeter = 0
				ShootLaser()
				$chargeTimer.set_wait_time(stats.ChargeSpeed)
				$chargeTimer.start()
				$"../ChargeAnimation".stop()
				$"../ChargeAnimation".play("ChargeShoot")
			ChargeMeter = 0
			hand.texture = load("res://Assets/Textures/Weapons/HandIdle.png")

func ShootBullet():
	var bul = BulletScene.instantiate()
	var sprx = randi_range(-stats.BullerSpread, stats.BullerSpread)
	var spry = randi_range(stats.BullerSpread, -stats.BullerSpread)
	bul.damage = stats.AttackDMG
	bul.global_position = shooting_start.global_position
	bul.rotation.x = $"../Head".rotation.x
	bul.rotation.y = $"..".rotation.y
	bul.size = Vector3(stats.BulletSize, stats.BulletSize, stats.BulletSize)
	bul.linear_velocity = shooting_start.global_transform.basis.z * -1 * stats.BulletSpeed + Vector3(sprx, spry, sprx)
	get_parent().get_parent().add_child(bul)

func ShootBomb():
	var Collider = $"../Head/ShootingRayCast".get_collider()
	var tracer = TracerScene.instantiate()
	if Collider:
		if Collider.is_in_group("Ball"):
			Collider.explode(3, 300, 50)
		else:
			var exp = ExplosionScene.instantiate()
			exp.global_position = $"../Head/ShootingRayCast".get_collision_point()
			exp.size = stats.BombSize
			exp.Damage = stats.BombDMG
			get_parent().get_parent().add_child(exp)
	else:
		return

func ShootLaser():
	var laser = laserScene.instantiate()
	get_parent().get_parent().add_child(laser)
	laser.global_position = $"../Head/Hand/LaserStartPos".global_position
	laser.rotation.x += $"../Head".rotation.x
	laser.rotation.y += $"..".rotation.y
	if $"../Head/ShootingRayCast".is_colliding():
		var collider = $"../Head/ShootingRayCast".get_collider()
		laser.createBeam()
		if collider.is_in_group("Enemy"):
			collider.Damage(stats.ChargeDamage)
		if collider.is_in_group("Ball"):
			collider.explode(1.5, 175, 10)
	else:
		laser.createBeam()

func ShootBall():
	var bul = BallScene.instantiate()
	bul.global_position = shooting_start.global_position
	bul.rotation.x = $"../Head".rotation.x
	bul.rotation.y = $"..".rotation.y
	bul.linear_velocity = shooting_start.global_transform.basis.z * -1 * 50 + get_parent().velocity * 2
	get_parent().get_parent().add_child(bul)

func _on_shooting_timer_timeout():
	CanShoot = true
func _on_bomb_timer_timeout():
	CanBomb = true
func _on_slash_timer_timeout():
	CanSlash = true
func _on_ready_timer_timeout():
	IsReady = true
func _on_dash_timer_timeout():
	CanDash = true
func _on_charge_timer_timeout():
	CanCharge = true
func _on_ball_timer_timeout():
	CanBall = true
