extends Node3D

@onready var commonGroundEnemies = [preload("res://Scenes/Enemies/SpikeBall/spike_ball.tscn")]
@onready var commonFlyingEnemies = [preload("res://Scenes/Enemies/FlyingEnemy/flying_enemy.tscn")]

@onready var bottem = $Bottem
@onready var top = $Top
@onready var spawn_timer = $SpawnTimer
@onready var animation_player = $AnimationPlayer

var difficulty
var enemyAmount
var gameNode

func _ready():
	animation_player.play("start")

func spawn():
	if enemyAmount > 0:
		var type = randi_range(1,2)
		if type == 1:
			var enemy = getRandomEnemy(commonGroundEnemies).instantiate()
			enemy.global_position = getRandomSpawnPoint(bottem).global_position
			gameNode.enemies.add_child(enemy)
			enemyAmount -= 1
			spawn_timer.start()
			gameNode.CanWin = true
		if type == 2:
			var enemy = getRandomEnemy(commonFlyingEnemies).instantiate()
			enemy.global_position = getRandomSpawnPoint(top).global_position
			gameNode.enemies.add_child(enemy)
			enemyAmount -= 1
			spawn_timer.start()
			gameNode.CanWin = true

func getRandomEnemy(array):
	return array[randi() % array.size()]

func getRandomSpawnPoint(parent):
	var random_id = randi() % parent.get_child_count()
	return parent.get_child(random_id)

func _on_spawn_timer_timeout():
	spawn()

func _on_delete_timer_timeout():
	animation_player.play("stop")

func delete():
	queue_free()
