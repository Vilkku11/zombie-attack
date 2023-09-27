extends CharacterBody3D

# Player nodes
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var eyes = $Nek/Head/Eyes
@onready var camera = $Nek/Head/Eyes/Camera3D
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var raycast = $RayCast3D
@onready var animation_player = $Nek/Head/Eyes/AnimationPlayer

# Speed variables
var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0
const JUMP_VELOCITY = 4.5
var lerp_speed = 10.0
var air_lerp_speed = 3.0

# Movement vars

var direction = Vector3.ZERO
var crouching_depth = -0.5
var free_look_tilt_amount = 5

var last_velocity = Vector3.ZERO

# States

var walking = false
var sprinting = false
var crouching = false
var free_looking = false
var sliding = false

# Head bobbing vars

const head_bobbing_sprinting_speed = 22.0
const head_bobbing_walking_speed = 14.0
const head_bobbing_crouching_speed = 10.0

const head_bobbing_sprinting_intensity = 0.2
const head_bobbing_walking_intensity = 0.1
const head_bobbing_crouching_intensity = 0.05

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

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
	
	# Input dir
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Handle movement state
	
	if Input.is_action_pressed("crouch") && is_on_floor():
		current_speed = lerp(current_speed, crouching_speed, delta * lerp_speed)
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
			
			current_speed = lerp(current_speed, sprinting_speed, delta * lerp_speed)
			
			walking = false
			sprinting = true
			crouching = false
		else:
			
			# Walking
			
			current_speed = lerp(current_speed, walking_speed, delta * lerp_speed)
			
			walking = true
			sprinting = false
			crouching = false
			

	# Handle free looking
	
	if Input.is_action_pressed("free_look"):
			
			free_looking = true
			eyes.rotation.z = -deg_to_rad(nek.rotation.y*free_look_tilt_amount)
			
	else:
		
		free_looking = false
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta*lerp_speed)
		eyes.rotation.z = lerp(eyes.rotation.z, 0.0, delta*lerp_speed)
		
	# Handle headbobbing
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed * delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed * delta
	
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index / 2) + 0.5
		
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (head_bobbing_current_intensity / 2.0), delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x * head_bobbing_current_intensity, delta * lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0 , delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0 , delta * lerp_speed)
		
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY



	# Handle landing
	if is_on_floor():
		if last_velocity.y < -6.0:
			print(last_velocity.y)
			animation_player.play("landing")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_on_floor():
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	last_velocity = velocity
	move_and_slide()
	
