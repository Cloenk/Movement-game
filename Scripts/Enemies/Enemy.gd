extends CharacterBody3D

@onready var target: CharacterBody3D = $"../Player"
@export var DamageNode: Node

func _physics_process(delta):
	move_and_slide()
