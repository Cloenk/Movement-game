extends Node3D

@onready var SquidmanScene: PackedScene = preload("res://Scenes/Enemies/FlyingEnemy/flying_enemy.tscn")
@onready var SpikeScene: PackedScene = preload("res://Scenes/Enemies/SpikeBall/spike_ball.tscn")

@onready var stats = $"../Stats"

func _ready():
	Console.add_command("set", Set, ["stat", "amount"], 2)
	Console.add_command("reload", reload)
	Console.add_command("summon", summon, ["enemy name"], 1)
	Console.add_command("killall", killall)

func killall():
	var node = get_parent().get_parent().enemies
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func summon(enemy):
	var scene
	if enemy == "squid":
		scene = SquidmanScene.instantiate()
		scene.global_position = $"../Head/EnemySpawnLocation".global_position
		get_parent().get_parent().enemies.add_child(scene)
	if enemy == "spike":
		scene = SpikeScene.instantiate()
		scene.global_position = $"../Head/EnemySpawnLocation".global_position
		get_parent().get_parent().enemies.add_child(scene)

func reload():
	get_tree().reload_current_scene()

func Set(stat: String, A: String):
	var amount = A.to_float()
	if stat == "hp":
		var old = stats.HP
		stats.HP = amount
		Console.print_line("Set hp to: " + A + " (was: " + str(old) + ")") 
	if stat == "speed":
		var old = stats.speed
		stats.speed = amount
		Console.print_line("Set speed to: " + A + " (was: " + str(old) + ")") 
	if stat == "dashvel":
		var old = stats.DashVel
		stats.DashVel = amount
		Console.print_line("Set dashvel to: " + A + " (was: " + str(old) + ")") 
	if stat == "attackdmg":
		var old = stats.AttackDMG
		stats.AttackDMG = amount
		Console.print_line("Set attackdmg to: " + A + " (was: " + str(old) + ")") 
	if stat == "attackspeed":
		var old = stats.AttackSpeed
		stats.AttackSpeed = amount
		Console.print_line("Set attackspeed to: " + A + " (was: " + str(old) + ")") 
	if stat == "bulletsize":
		var old = stats.BulletSize
		stats.BulletSize = amount
		Console.print_line("Set bulletsize to: " + A + " (was: " + str(old) + ")") 
	if stat == "bulletspeed":
		var old = stats.BulletSpeed
		stats.BulletSpeed = amount
		Console.print_line("Set bulletspeed to: " + A + " (was: " + str(old) + ")") 
	if stat == "bombdmg":
		var old = stats.BombDMG
		stats.BombDMG = amount
		Console.print_line("Set bombdmg to: " + A + " (was: " + str(old) + ")") 
	if stat == "bombcooldown":
		var old = stats.BombCooldown
		stats.BombCooldown = amount
		Console.print_line("Set bombspeed to: " + A + " (was: " + str(old) + ")") 
	if stat == "bombsize":
		var old = stats.BombSize
		stats.BombSize = amount
		Console.print_line("Set bombsize to: " + A + " (was: " + str(old) + ")") 
	if stat == "meleespeed":
		var old = stats.MeleeSpeed
		stats.MeleeSpeed = amount
		Console.print_line("Set meleespeed to: " + A + " (was: " + str(old) + ")") 
	if stat == "meleedmg":
		var old = stats.MeleeDamage
		stats.MeleeDamage = amount
		Console.print_line("Set meleedmg to: " + A + " (was: " + str(old) + ")") 
	if stat == "meleedashcooldown":
		var old = stats.MeleeDashCooldown
		stats.MeleeDashCooldown = amount
		Console.print_line("Set meleedashcooldown to: " + A + " (was: " + str(old) + ")") 
	if stat == "meleedashamount":
		var old = stats.MeleeDashAmount
		stats.MeleeDashAmount = amount
		Console.print_line("Set meleedashamount to: " + A + " (was: " + str(old) + ")") 
