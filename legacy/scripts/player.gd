extends CharacterBody3D

@export var HORIZONTAL_SENSITIVITY: float = 0.01
@export var VERTICAL_SENSITIVITY: float = 0.005
@export var MOVEMENT_SPEED: float = 10.0
@export var JUMP_STRENGTH: float = 39.2
@export var SPRINT_MODIFIER: float = 1.5
@export var ACCELERATION: float = 7.5
@onready var head: Marker3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var targeting: RayCast3D = $Targeting

func _ready() -> void:
	GlobalInputs.set_active(self)
	GlobalInputs.capture_mouse()
	Global.spawn(self)

func spawn_behavior() -> void:
	pass

func handleMouseMotion(event: Vector2) -> void:
	rotate(basis.y, (-event.x * VERTICAL_SENSITIVITY))
	head.rotate_x(-event.y * HORIZONTAL_SENSITIVITY)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func _physics_process(delta: float) -> void:
	if Global.paused:
		return
	if not get_gravity() == Vector3.ZERO:
		up_direction = up_direction.lerp(-get_gravity().normalized(), get_gravity().length() * delta)
		var forward = (basis.z - (basis.z.dot(up_direction) * up_direction)).normalized()
		transform.basis = Basis(up_direction.cross(forward).normalized(), up_direction, forward)
	if GlobalInputs.active_node == self:
		var movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var impulse: Vector3 = Vector3(movement_input.x, 0, movement_input.y) * MOVEMENT_SPEED
		if Input.is_action_pressed("move_sprint"):
			impulse *= SPRINT_MODIFIER
		if Input.is_action_pressed("move_up"):
			impulse.y += JUMP_STRENGTH
		if is_on_floor():
			velocity = velocity.lerp(global_basis * impulse, delta * ACCELERATION)
	if get_slide_collision_count() > 0:
		velocity = velocity.lerp(Vector3.ZERO, 3 * delta)
	velocity += get_gravity() * delta
	targeting.basis = head.basis
	move_and_slide()
	$Targeting/Ball.global_position = targeting.get_collision_point()
