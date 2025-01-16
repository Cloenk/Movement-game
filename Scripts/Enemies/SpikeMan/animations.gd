extends Node3D

@onready var animation = $"../Animation"

func _process(delta):
	if !animation.is_playing():
		animation.set_assigned_animation("Walk")
		animation.play()
