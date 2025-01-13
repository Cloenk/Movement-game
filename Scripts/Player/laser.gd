extends RayCast3D

@onready var beam = $BeamMesh

func createBeam():
	$AnimationPlayer.play("anim")
	var contactPoint

	force_raycast_update()
	#look_at(pos)
	if is_colliding():
		contactPoint = to_local(get_collision_point())
		
		beam.mesh.height = contactPoint.y
		beam.position.y = contactPoint.y/2
	else:
		contactPoint = to_local($Marker3D.global_position)
		
		beam.mesh.height = contactPoint.y
		beam.position.y = contactPoint.y/2

func delete():
	queue_free()
