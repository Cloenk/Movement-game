extends RigidBody3D

var size = Vector3(1,1,1)
var damage
var grace = true

func _ready():
	$Main.scale = size
	$Outline.scale = size
	$EnemyArea.scale = size

func _process(delta):
	for body in $EnemyArea.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.DamageNode.Damage(damage)
			queue_free()
		if body.is_in_group("Ball"):
			body.explode(1,150, 0)
			queue_free()
		if !body.is_in_group("Player"):
			if grace == false:
				queue_free()
		else:
			return

func _on_delete_timer_timeout():
	queue_free()
func _on_grace_timer_timeout():
	grace = false
