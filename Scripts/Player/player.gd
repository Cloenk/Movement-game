extends CharacterBody3D
#refs
@onready var head = $Head
@onready var grapple_raycast = $Head/GrappleRaycast
@onready var rope = $Head/Rope
@onready var stats = $Stats
@onready var cayote_timer = $CayoteTimer
@onready var sound = $Sound
@onready var hand = $Head/Hand
@onready var target = $Head/target
#velocities
var WalkingVelocity = Vector3()
var JumpingVelocity = Vector3()
var DashingVelocity = Vector3()
var WallJumpVelocity = Vector3()
var GrappleVelocity = Vector3()
var SlamVelocity = Vector3()
var ExplosionVelocity = Vector3()
var MeleeVelocity = Vector3()
#dirs
var input_dir = Vector3.ZERO
var direction = Vector3.ZERO
#movement vars
var JumpVelocity = 14
var MouseSens = 0.3
var Gravity = 15
var IsGrounded = true
var CurrentSpeed
var PlayerSpeed
#Lerps
var lerp_speed = 10
var DashLerpSpeed = 0.05
var WallJumpLerpSpeed = 0.05
var GrappleLerpSpeed = 0.01
var ExplosionLerpSpeed = 0.05
#Dashing vars
var CanDash = true
var IsDashing = false
var StopVelWhenLand = false
var StopVelWhenLandMelee = false
#Grapple vars
var IsGrappling = false
var GrappleEnd
var CanGrapple = true
var GrappledEnemy
var IsGrapplingEnemy = false
#sway vars
var FOVChange = 1.0
var mouseMov = Vector3.ZERO
var swayThresh = 0.5
var swaySpeed = 2
var swayAmount = 0.05
var defaultRot
var defaultPos
var mouse_input = Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	defaultRot = $Head/Hand.rotation
	defaultPos = $Head/Hand.position

func _input(event : InputEvent): #Mouse look
	if event is InputEventMouseMotion:
		mouseMov = Vector3(-event.relative.x * MouseSens, -event.relative.y * MouseSens, 0)
		mouse_input = event.relative
		var vel := Vector3(event.relative.x, -event.relative.y, 0.0) / 1000.0
		target.position.x += vel.x
		target.position.y += vel.y
		target.position.z = -0.776
		rotate_y(deg_to_rad(-event.relative.x * MouseSens))
		head.rotate_x(deg_to_rad(-event.relative.y * MouseSens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func damage(dmg: float):
		stats.HP -= dmg

func dash(): #Dashing
	sound.DoDashSound = true
	IsDashing = true
	CanDash = false
	$DashTimer.start()
	$IsDashingTimer.start()
	WalkingVelocity = Vector3.ZERO
	JumpingVelocity = Vector3.ZERO
	GrappleVelocity = Vector3.ZERO
	SlamVelocity = Vector3.ZERO
	DashingVelocity = direction.normalized() * stats.DashVel

func SecondDash():
	sound.DoSlashSound = true
	if !is_on_floor():
		StopVelWhenLandMelee = true
	WalkingVelocity = Vector3.ZERO
	JumpingVelocity = Vector3.ZERO
	GrappleVelocity = Vector3.ZERO
	SlamVelocity = Vector3.ZERO
	MeleeVelocity = ($Head/ShootingRayCastEnd.global_transform.origin - global_transform.origin).normalized() * stats.MeleeDashAmount

func _process(delta):
	PlayerSpeed = velocity.length()
	if PlayerSpeed <= 30:
		FOVChange = lerp(FOVChange, 1.0, 0.075)
	if PlayerSpeed >= 40:
		FOVChange = lerp(FOVChange, 1.5, 0.075)
	if PlayerSpeed >= 50:
		FOVChange = lerp(FOVChange, 2.0, 0.075)
	$Head/Camera3D.set_fov(lerp(75.0,75.0 + PlayerSpeed / FOVChange, 0.075))
	$UI/Speed.text = str(round(PlayerSpeed))

	$UI/HP.text = str(stats.HP)
	if CanDash == true:
		$UI/DashIcon.texture = load("res://Assets/Textures/DashIcon3.png")
	else:
		$UI/DashIcon.texture = load("res://Assets/Textures/DashIcon3Gray.png")

func _physics_process(delta):
	if Input.is_action_just_pressed("GroundSlam") and IsGrounded == false:
		SlamVelocity.y = -50
	
	if $GroundCheck.is_colliding(): #Check if grounded
		IsGrounded = true
	else:
		IsGrounded = false
	
	if GrappledEnemy != null:
		GrappleEnd = GrappledEnemy.global_position
	
	if Input.is_action_pressed("graple"): #Dash input
		if IsGrapplingEnemy == true and IsGrappling == true:
			if not is_instance_valid(GrappledEnemy):
				IsGrappling = false
				IsGrapplingEnemy = false
				CanGrapple = true
				GrappleEnd = null
				GrappledEnemy = null
				return
		
		if grapple_raycast.is_colliding() and CanGrapple:
			var collider = grapple_raycast.get_collider()
			CanGrapple = false
			IsGrappling = true
			
			if collider:
				if collider.is_in_group("Enemy"):
					GrappleEnd = collider.global_position
					GrappledEnemy = collider
					IsGrapplingEnemy = true
				elif collider.is_in_group("Ball"):
					GrappleEnd = collider.global_position
					GrappledEnemy = collider
					IsGrapplingEnemy = true
				else:
					GrappleEnd = grapple_raycast.get_collision_point()
	else:
		IsGrapplingEnemy = false
		CanGrapple = true
		IsGrappling = false
		GrappleEnd = null
		GrappledEnemy = null

	if IsGrappling == true: #DO THE GRAPPLE
		var grapple_direction = (GrappleEnd - global_position).normalized()
		var grapple_target_speed = grapple_direction * 100
		var grapple_diff = (grapple_target_speed - velocity)
		GrappleVelocity += grapple_diff * delta
		var dist = global_position.distance_to(GrappleEnd)
		rope.look_at(GrappleEnd)
		rope.scale = Vector3(1,1,dist)
		rope.show()
	else:
		rope.hide()

	if Input.is_action_just_pressed("Dash") and CanDash == true: #DashInput
		dash()
	
	if IsGrounded == false and IsGrappling == false: #falling
		JumpingVelocity.y -= Gravity * delta
		GrappleLerpSpeed = 0.03
	else:
		GrappleLerpSpeed = 0.05
		WallJumpVelocity = lerp(WallJumpVelocity, Vector3.ZERO, 0.7)
		JumpingVelocity.y = 0
		SlamVelocity.y = 0
		if IsDashing == false:
			DashLerpSpeed = 0.05
		if StopVelWhenLand == true: #stop dash when land
			StopVelWhenLand = false
			DashingVelocity = lerp(DashingVelocity, Vector3.ZERO, 0.7)
		if StopVelWhenLandMelee == true:
			StopVelWhenLandMelee = false
			MeleeVelocity.y = 0

	if is_on_wall(): #stop dash when wall kaboem
		if $Head/ForwardWallCast.is_colliding() or $Head/BackwardsWallCast.is_colliding():
			DashingVelocity = Vector3.ZERO
	if Input.is_action_just_pressed("ui_accept") : #jumping
		if IsGrounded or !cayote_timer.is_stopped(): #normal jump
			GrappleVelocity.y = 0
			ExplosionVelocity.y = 0
			JumpingVelocity.y = JumpVelocity
			sound.DoJumpSounds = true
			$".".global_position.y += 0.2

			if IsDashing: #dash jump
				StopVelWhenLand = true
				DashingVelocity *= 1.5
				DashingVelocity.y += 8
				DashLerpSpeed = 0.03

		if is_on_wall_only(): #wall jump
			sound.DoJumpSounds = true
			WallJumpVelocity = get_wall_normal() * 25
			JumpingVelocity.y = 19

	input_dir = Input.get_vector("left", "right", "up", "down") #Walking
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	if direction:
		WalkingVelocity.x = direction.x * stats.speed
		WalkingVelocity.z = direction.z * stats.speed
	else:
		WalkingVelocity.x = move_toward(WalkingVelocity.x, 0, stats.speed * delta)
		WalkingVelocity.z = move_toward(WalkingVelocity.z, 0, stats.speed * delta)
	if input_dir:
		if IsGrounded and !IsGrappling:
			sound.DoWalkingSounds = true
		else:
			sound.DoWalkingSounds = false
	else:
		sound.DoWalkingSounds = false
	velocity = WalkingVelocity + JumpingVelocity + DashingVelocity + WallJumpVelocity + GrappleVelocity + SlamVelocity + ExplosionVelocity + MeleeVelocity #Add velocity
	
	#MAKE VELOCITY GO DOWN
	DashingVelocity = lerp(DashingVelocity, Vector3.ZERO, DashLerpSpeed)
	WallJumpVelocity = lerp(WallJumpVelocity, Vector3.ZERO, WallJumpLerpSpeed)
	ExplosionVelocity = lerp(ExplosionVelocity, Vector3.ZERO, ExplosionLerpSpeed)
	GrappleVelocity.y = lerp(GrappleVelocity.y, 0.0, GrappleLerpSpeed)
	MeleeVelocity = lerp(MeleeVelocity, Vector3.ZERO, DashLerpSpeed)
	if IsGrappling == false:
		GrappleVelocity = lerp(GrappleVelocity, Vector3.ZERO, GrappleLerpSpeed)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		cayote_timer.start()
	
	hand.position = Global.smooth_nudgev(hand.position, target.position, swaySpeed, delta)
	target.position = Global.smooth_nudgev(target.position,defaultPos , 25, delta)
	#hand.rotation = Global.smooth_nudgev_rot(hand.rotation, target.rotation, 50, delta)
	#target.rotation = Global.smooth_nudgev_rot(target.rotation,defaultRot , 15, delta)


func _on_dash_timer_timeout():
	CanDash = true
func _on_is_dashing_timer_timeout():
	IsDashing = false

#func weaponMove(delta):
	#var mouseMovLength = mouseMov.length()
	#if (mouseMovLength > swayThresh or mouseMovLength < -swayThresh):
		#$Head/Hand.rotation = $Head/Hand.rotation.lerp(mouseMov.normalized() * swayAmount + defaultRot, swaySpeed * delta)
		#$Head/Hand.position = $Head/Hand.position.lerp(mouseMov * swayAmount + defaultPos, swaySpeed * delta)
	#else:
		#$Head/Hand.rotation = $Head/Hand.rotation.lerp(defaultRot, swaySpeed * delta)
		#$Head/Hand.position = $Head/Hand.position.lerp(defaultPos, swaySpeed * delta)
