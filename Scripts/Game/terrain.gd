extends Node3D

@export var playerSpawn: Marker3D

@onready var world_environment = $WorldEnvironment
@onready var wave_spawns = $WaveSpawns

func getRandomSpawnPoint():
	var random_id = randi() % wave_spawns.get_child_count()
	return wave_spawns.get_child(random_id)
