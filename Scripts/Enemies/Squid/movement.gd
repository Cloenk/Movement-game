extends Node

var DodgeVelocity = Vector3()
var FlyingVelocity = Vector3()

@export var host: CharacterBody3D
@export var speed: float

var state
var distance = 1
var readyS = false

func _physics_process(delta):
	distance = host.global_transform.origin.distance_to(host.target.global_position)
	
	if distance <= 4:
		state = "run"
	else:
		if distance >= 15:
			state = "chase"
		else:
			state = "shoot"
	
	if state == "chase":
		var direction = host.target.global_transform.origin - host.global_transform.origin
		if direction.length() > 0.1:
			direction = direction.normalized()
	
		FlyingVelocity = direction * speed + DodgeVelocity
		FlyingVelocity.y += 1
	else:
		if state == "run":
			var direction = host.target.global_transform.origin + host.global_transform.origin
			if direction.length() > 0.1:
				direction = direction.normalized()
			FlyingVelocity = direction * speed + DodgeVelocity
			FlyingVelocity.y += 20
		else:
			FlyingVelocity = lerp(FlyingVelocity, Vector3(0,0,0), 0.05)
	DodgeVelocity = lerp(DodgeVelocity, Vector3(0,0,0), 0.07)
	host.velocity = FlyingVelocity + DodgeVelocity


func _on_dodge_timer_timeout():
	var rand = randi_range(1,2)
	var randy = randi_range(20,35)
	var randside = randi_range(60,75)
	if rand == 1:
		DodgeVelocity = ($"../RightMark".global_transform.origin - $"../RightRay".global_transform.origin).normalized() * randside 
		DodgeVelocity.y = randy
		$"../DodgeTimer".set_wait_time(randi_range(1,10))
		$"../DodgeTimer".start()
	else:
		DodgeVelocity = ($"../LeftMark".global_transform.origin - $"../LeftRay".global_transform.origin).normalized() * randside
		DodgeVelocity.y = randy
		$"../DodgeTimer".set_wait_time(randi_range(1,10))
		$"../DodgeTimer".start()
