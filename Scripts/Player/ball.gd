extends RigidBody3D

@onready var ExplosionScene: PackedScene = preload("res://Scenes/Projectiles/explosion.tscn")
var grace = true
var boost = 0

func _ready():
	$AnimationPlayer.play("decay")

func _process(delta):
	linear_velocity = lerp(linear_velocity, Vector3.ZERO, 0.005)
	for body in $Ball.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			explode(1, 150 + boost, 0)
		if body.is_in_group("Player") and grace == false:
			explode(1, 150 + boost, 0)

func explode(size, dmg, part):
	var exp = ExplosionScene.instantiate()
	exp.global_position = global_position
	exp.size = size
	exp.Damage = dmg
	exp.extraparticles = part
	get_parent().get_parent().add_child(exp)
	self.queue_free()

func _on_grace_timer_timeout():
	grace = false

func Delete():
	explode(1, 150, 0)
	queue_free()
