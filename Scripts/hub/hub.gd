extends Node3D

@onready var bottem_clouds = $Clouds/BottemClouds
@onready var middle_clouds = $Clouds/MiddleClouds
@onready var top_clouds = $Clouds/TopClouds

func _process(delta):
	bottem_clouds.mesh.get_material().uv1_offset.x += 0.03 * delta
	bottem_clouds.mesh.get_material().uv1_offset.z += 0.03 * delta
	middle_clouds.mesh.get_material().uv1_offset.x += 0.05 * delta
	middle_clouds.mesh.get_material().uv1_offset.z -= 0.05 * delta
	top_clouds.mesh.get_material().uv1_offset.x -= 0.05 * delta
	top_clouds.mesh.get_material().uv1_offset.z += 0.05 * delta
