extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 45
@export var SPRINT_MODIFIER: float = 1.5
@export var VERTICAL_SENSITIVITY: float = 0.005
@export var HORIZONTAL_SENSITIVITY: float = 0.01
@export var FRICTION: float = 7.5
@export var ROTATION_SENSITIVITY: float = 7.5
var mouse_captured: bool = false

func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_captured = false

func rotate_player(event: Vector2) -> void:
	rotate(basis.y, (-event.x * VERTICAL_SENSITIVITY))
	head.rotate_x(-event.y * HORIZONTAL_SENSITIVITY)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func _ready() -> void:
	capture_mouse()
	if get_gravity() != Vector3.ZERO:
		up_direction = -get_gravity().normalized()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	if mouse_captured and event is InputEventMouseMotion:
		rotate_player(event.relative)

func _physics_process(delta: float) -> void:
	if get_gravity() != Vector3.ZERO:
		up_direction = up_direction.lerp(-get_gravity().normalized(), delta * ROTATION_SENSITIVITY)
	# ChatGPT Assisted
	var forward = (transform.basis.z - (transform.basis.z.dot(up_direction) * up_direction)).normalized()
	var right = up_direction.cross(forward).normalized()
	# End of Assistance
	transform.basis = Basis(right, up_direction, forward)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	var local_impulse = Vector3(input_dir.x * SPEED, 0, input_dir.y * SPEED)
	if Input.is_action_pressed("move_sprint"):
		local_impulse *= SPRINT_MODIFIER
	if is_on_floor():
		if Input.is_action_pressed("move_up"):
			local_impulse.y += JUMP_VELOCITY
		velocity = velocity.lerp(global_basis * local_impulse, delta * FRICTION)
	else:
		velocity += get_gravity() * delta
	move_and_slide()
