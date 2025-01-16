extends Node

@export var host: CharacterBody3D
@export var NavAgent: NavigationAgent3D
@export var speed: float
@export var accel: float
var direction = Vector3()

func _physics_process(delta):
	var target = host.target.global_position
	var next = NavAgent.get_next_path_position()
	var looking = next

	looking.y = host.global_position.y
	host.look_at(looking)
	NavAgent.target_position = target

	direction = next - host.global_position
	direction = direction.normalized()

	host.velocity = host.velocity.lerp(direction * speed, accel * delta)
