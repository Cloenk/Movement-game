extends RigidBody3D

var dmg

func _process(delta):
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.damage(dmg)
			queue_free()
		if !body.is_in_group("Enemy"):
			queue_free()


func _on_delete_timer_timeout():
	queue_free()
