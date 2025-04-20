extends RigidBody3D
class_name RelayedRigidBody3D

@export var controller: RelayedRigidBody3DController = RelayedRigidBody3DController.new()	

func _init() -> void:
	_acquire_relay(self)
	controller._set_parent(self)

func _acquire_relay(node: Node) -> void:
	if node.get_meta("relay", false):
		return
	var parent: Node = node.get_parent()
	while parent and not parent.has_meta("relay"):
		parent = parent.get_parent()
	if parent:
		node.set_meta("relay", parent.get_meta("relay"))
	else:
		node.set_meta("relay", Relay.new(node))
	node.child_entered_tree.connect(_acquire_relay)

func _ready() -> void:
	controller._on_ready()

func _process(delta: float) -> void:
	controller._on_process(delta)

func _physics_process(delta: float) -> void:
	controller._on_physics_process(delta)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	controller._on_integrate_forces(state)

func _enter_tree() -> void:
	controller._enter_tree()

func _exit_tree() -> void:
	controller._exit_tree()

func _input(event: InputEvent) -> void:
	controller._input(event)

func _shortcut_input(event: InputEvent) -> void:
	controller._shortcut_input(event)

func _unhandled_input(event: InputEvent) -> void:
	controller._unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	controller._unhandled_key_input(event)

func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	controller._input_event(camera, event, event_position, normal, shape_idx)

func _mouse_enter() -> void:
	controller._mouse_enter()

func _mouse_exit() -> void:
	controller._mouse_exit()

func _notification(what: int) -> void:
	controller._notification(what)
