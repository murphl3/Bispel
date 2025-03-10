extends CharacterBody3D

@export var HORIZONTAL_SENSITIVITY: float = 0.01
@export var VERTICAL_SENSITIVITY: float = 0.005
@export var MOVEMENT_SPEED: float = 10.0
@export var JUMP_STRENGTH: float = 39.2
@export var SPRINT_MODIFIER: float = 1.5
@export var ACCELERATION: float = 7.5
@export var FOLLOW_RANGE: float = 2.5
@onready var head: Marker3D = $Head
@onready var nav: NavigationAgent3D = $"Navigation Agent"
var target_velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	Global.spawn(self)
	await get_tree().create_timer(1).timeout
	nav.target_desired_distance = FOLLOW_RANGE

func spawn_behavior() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Global.paused:
		return
	if not get_gravity() == Vector3.ZERO:
		up_direction = up_direction.lerp(-get_gravity().normalized(), get_gravity().length() * delta)
		var forward = (basis.z - (basis.z.dot(up_direction) * up_direction)).normalized()
		transform.basis = Basis(up_direction.cross(forward).normalized(), up_direction, forward)
		nav.target_position = GlobalInputs.active_node.position
	if is_on_floor():
		var movement_input: Vector3 = global_basis.inverse() * (nav.get_next_path_position() - position)
		if nav.is_target_reached():
			movement_input = Vector3.ZERO
		else:
			movement_input.y = 0;
		var impulse: Vector3 = (movement_input.normalized()) * MOVEMENT_SPEED
		velocity = velocity.lerp(global_basis * impulse, delta * ACCELERATION)
	if get_slide_collision_count() > 0:
		velocity = velocity.lerp(Vector3.ZERO, 3 * delta)
	velocity += get_gravity() * delta
	move_and_slide()
