extends CharacterBody3D

# Player nodes
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var camera = $Nek/Head/Camera3D
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var raycast = $RayCast3D

# Speed variables
var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0
const JUMP_VELOCITY = 4.5
var lerp_speed = 10.0

# Direction
var direction = Vector3.ZERO
var crouching_depth = -0.5
var free_look_tilt_amount = 5

# States

var walking = false
var sprinting = false
var crouching = false
var free_looking = false
var sliding = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	
	# Mouse movement logic
	
	if event is InputEventMouseMotion:
		if free_looking:
			nek.rotate_y(deg_to_rad(-event.relative.x * GlobalSettings.mouse_sens))
			nek.rotation.y = clamp(nek.rotation.y, deg_to_rad(-120),deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * GlobalSettings.mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * GlobalSettings.mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	
	# Handle movement state
	
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, crouching_depth,delta*lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		walking = false
		sprinting = false
		crouching = true
		
	elif !raycast.is_colliding():
		
		# Standing
		
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed)
		crouching_collision_shape.disabled = true
		standing_collision_shape.disabled = false
		
		if Input.is_action_pressed("sprint"):
			
			# Sprinting
			
			current_speed = sprinting_speed
			
			walking = false
			sprinting = true
			crouching = false
		else:
			
			# Walking
			
			current_speed = walking_speed
			
			walking = true
			sprinting = false
			crouching = false
			

	# Handle free looking
	
	if Input.is_action_pressed("free_look"):
			
			free_looking = true
			camera.rotation.z = -deg_to_rad(nek.rotation.y*free_look_tilt_amount)
			
	else:
		
		free_looking = false
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta*lerp_speed)
		camera.rotation.z = lerp(camera.rotation.z, 0.0, delta*lerp_speed)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
