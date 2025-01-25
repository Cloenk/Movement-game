extends CharacterBody3D

@onready var target = $"../../Player"
@export var DamageNode: Node

func _physics_process(delta):
	move_and_slide()
