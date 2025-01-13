extends Node

@export var host : CharacterBody3D
@export var BulletStartPosNode : Marker3D
@export var Cooldown : float
@export var Damage : float
@export var BulletVelocity : float
@export var ShootingRange : float
@export var LookAtTarget : bool

@onready var BulletScene: PackedScene = preload("res://Scenes/Projectiles/FlyingEnemy/Bullet.tscn")
@onready var timer = $Timer

var CanFire = true
var distance

func _process(delta):
	distance = host.global_transform.origin.distance_to(host.target.global_position)
	BulletStartPosNode.look_at(host.target.global_position)
	if LookAtTarget:
		host.look_at(host.target.global_position, Vector3(0,1,0))
	if CanFire == true:
		if distance <= ShootingRange:
			CanFire = false
			shoot()
			timer.set_wait_time(Cooldown)
			timer.start()

func shoot():
	var bul = BulletScene.instantiate()
	bul.global_position = BulletStartPosNode.global_position
	bul.rotation.x = host.rotation.x
	bul.rotation.y = host.rotation.y
	bul.linear_velocity = BulletStartPosNode.global_transform.basis.z * -1 * BulletVelocity
	bul.dmg = Damage
	host.get_parent().add_child(bul)

func _on_timer_timeout():
	CanFire = true
