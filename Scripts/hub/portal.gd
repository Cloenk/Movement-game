extends Node3D

@onready var ball = $Ball
@onready var player_area = $PlayerArea
@export var Scene: PackedScene

func _process(delta):
	ball.mesh.get_material().uv1_offset.y -= 10 * delta
	for body in player_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			get_tree().change_scene_to_packed(Scene)
