extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
var mouse_captured: bool = false

func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_captured = false

func _ready() -> void:
	capture_mouse()

func _physics_process(delta: float) -> void:
	print(basis.x, basis.y, basis.z)
	print(head.rotation)
	move_and_slide()
