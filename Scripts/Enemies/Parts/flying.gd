extends Node

@export var host : CharacterBody3D
@export var speed : float
@export var StoppingDistance : float

var FlyingVelocity = Vector3()
var distance
var state

func _physics_process(delta):
	distance = host.global_transform.origin.distance_to(host.target.global_position)
	if distance >= 15:
		state = "chase"
	else:
		state = "hold"
	if state == "chase":
		var direction = host.target.global_transform.origin - host.global_transform.origin
		if direction.length() > 0.1:
			direction = direction.normalized()
		FlyingVelocity = direction * speed
		FlyingVelocity.y += 1
	else:
		FlyingVelocity = lerp(FlyingVelocity, Vector3(0,0,0), 0.05)
	host.velocity = FlyingVelocity
