extends CharacterBody3D


var current_speed = 5.0

var direction = Vector3.ZERO
var lerp_speed = 10.0

const jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var camera3rd := $"../ThirdPersonView"
@onready var player_body := $Body
@onready var player_hitbox := $Hitbox

func _input(event):
	if event.is_action_pressed("ChangeView"):
		if camera3rd.is_current():
			camera3rd.clear_current(true)
		else:
			camera.clear_current(true)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var dir = Vector3()
			dir.x = -event.relative.y * 0.01 / 5
			dir.z = -event.relative.x * 0.01 / 5
			player_body.rotate_y(-event.relative.x * 0.01 / 5)
			player_body.rotate_x(-event.relative.y * 0.01 / 5)
			player_hitbox.rotate_y(-event.relative.x * 0.01 / 5)
			player_hitbox.rotate_x(-event.relative.y * 0.01 / 5)
			neck.rotate_y(-event.relative.x * 0.01 / 5)
			camera.rotate_x(-event.relative.y * 0.01 / 5)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	direction = lerp(direction, (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
