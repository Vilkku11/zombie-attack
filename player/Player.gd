extends CharacterBody3D

# Player nodes
@onready var head = $Head
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

# DIrection
var direction = Vector3.ZERO
var crouching_depth = -0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	
	# Mouse movement logic
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * GlobalSettings.mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * GlobalSettings.mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	
	# Handle movement state
	
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, 0.8 + crouching_depth,delta*lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
	elif !raycast.is_colliding():
		
		# Standing
		
		head.position.y = lerp(head.position.y, 0.8, delta*lerp_speed)
		crouching_collision_shape.disabled = true
		standing_collision_shape.disabled = false
		if Input.is_action_pressed("sprint"):
			
			# Sprinting
			
			current_speed = sprinting_speed
		else:
			
			# Walking
			
			current_speed = walking_speed
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
