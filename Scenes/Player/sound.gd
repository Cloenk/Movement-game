extends Node3D

@onready var player = $".."
@onready var walking = $WalkingSounds
@onready var jump = $JumpSound
@onready var land = $LandSound
@onready var dash = $DashSound
@onready var slash = $SlashSound
@onready var wind = $WindSound

var DoWalkingSounds = false
var DoJumpSounds = false
var DoLandSound = false
var DoDashSound = false
var DoSlashSound = false
var DoWindSound = false

func _process(delta):
	if DoWalkingSounds == true:
		if walking.playing == false:
			walking.pitch_scale = randf_range(0.8, 1.2)
			walking.play()
	
	if DoJumpSounds == true:
		jump.pitch_scale = randf_range(0.8, 1.1)
		jump.play()
		DoJumpSounds = false
	
	if player.velocity.y <= -10:
		DoLandSound = true
	if DoLandSound == true and player.IsGrounded:
		DoLandSound = false
		land.pitch_scale = randf_range(0.8, 1.1)
		land.play()
	
	if DoDashSound == true:
		dash.pitch_scale = randf_range(0.8, 1.1)
		dash.play()
		DoDashSound = false
	
	if DoSlashSound == true:
		slash.pitch_scale = randf_range(0.8, 1.1)
		slash.play()
		DoSlashSound = false
	
	if player.velocity.y < -15:
		wind.set_volume_db(-75 + -player.velocity.y)
		if !wind.is_playing():
			wind.play()
	else:
		wind.stop()
