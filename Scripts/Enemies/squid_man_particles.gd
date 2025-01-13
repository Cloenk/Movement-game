extends GPUParticles3D

func _ready():
	set_emitting(true)

func _process(delta):
	if is_emitting() == false:
		self.queue_free()
