extends Node3D

@onready var WaveScene: PackedScene = preload("res://Scenes/Game/wave_beam.tscn")

@onready var game = $".."
@onready var waveTimer = $WaveTimer

var TerrainFolder = DirAccess.get_files_at("res://Scenes/Terrains/")
var Terrains = [preload("res://Scenes/Terrains/Terrain1.tscn")]
var CurrentRoom
var waves

func spawnRoom():
	var room = getRandomTerrain().instantiate()
	game.player.global_position = room.playerSpawn.position
	add_child(room)
	CurrentRoom = room
	game.player.camera.set_environment(room.world_environment.get_environment())
	waveTimer.set_wait_time(4)
	waveTimer.start()
	waves = game.waveAmount

func deleteRoom():
	CurrentRoom.queue_free()
	CurrentRoom = null

func getRandomTerrain():
	return Terrains[randi() % Terrains.size()]

func spawnWave():
	var wave = WaveScene.instantiate()
	var spawnPos = CurrentRoom.getRandomSpawnPoint()
	wave.difficulty = game.difficulty
	wave.enemyAmount = game.enemyAmount
	wave.gameNode = game
	wave.global_position = spawnPos.global_position
	game.entities.add_child(wave)
	waves -= 1
	spawnPos.queue_free()
	if waves > 0:
		waveTimer.set_wait_time(0.2)
		waveTimer.start()

func _on_wave_timer_timeout():
	spawnWave()
