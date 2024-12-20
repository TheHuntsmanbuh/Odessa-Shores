extends StairsCharacter


#headbob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#movement variables
var speed
const STANDUP_VELOCITY = 0.2
const SPRINT_SPEED = 8.0 
const WALK_SPEED = 5.0
const SENSITIVITY = 0.01
const JUMP_VELOCITY = 4.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var body = $MeshInstance3D
@onready var bodycolision = $Collider

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		desired_velocity = velocity

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	#handle crouch input
	if Input.is_action_pressed("crouch"):
		bodycolision.scale.y = 0.3
	else:
		bodycolision.scale.y = 1
	if Input.is_action_just_released("crouch"):
		velocity.y = STANDUP_VELOCITY
	else:
		pass
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	desired_velocity = direction
	if is_on_floor():
		
		if direction:
			# smooths the movement using lerp
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 10.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 10.0)
			
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		

	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	if velocity.length() <= 0.1:
		pass
	else:
		if $Timer.time_left <= 0 and is_on_floor() == true and velocity.length() <= 4.9:
					$footstepsound.pitch_scale = randf_range(0.8, 1.2)
					$footstepsound.play()
					$Timer.start(0.4) 
		elif $Timer.time_left <= 0 and velocity.length() >= 5 and is_on_floor() == true :
				$footstepsound.pitch_scale = randf_range(0.8, 1.2)
				$footstepsound.play()
				$Timer.start(0.2) 
	#head bob section
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_stair_step()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
