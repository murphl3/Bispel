extends RigidBody3D
class_name LinkedBody3D

@export var _controller: LinkedController3D
@export var _linked: bool = true
var _blocked_signals: Array[StringName]

func _init() -> void:
	_blocked_signals = [
		'body_shape_entered',
		'body_shape_exited',
		'body_entered',
		'body_exited',
		'sleeping_state_changed',
		'input_event',
		'mouse_entered',
		'mouse_exited',
		'visibility_changed',
		'ready',
		'renamed',
		'tree_entered',
		'tree_exiting',
		'tree_exited',
		'child_entered_tree',
		'child_exiting_tree',
		'child_order_changed',
		'replacing_by',
		'editor_description_changed',
		'editor_state_changed',
		'script_changed',
		'property_list_changed'
	]
	child_entered_tree.connect(_child_entered_tree)
	Global.physics_frame.connect(_on_physics_frame)
	Global.process_frame.connect(_on_process_frame)

func _on_physics_frame(_delta: float) -> void:
	pass

func _on_process_frame(_delta: float) -> void:
	pass

func _child_entered_tree(node: Node) -> void:
	if not is_instance_valid(node) or node is LinkedBody3D:
		return
	if node is PhysicsBody3D:
		node.collision_layer = collision_layer
		node.collision_mask = collision_mask
	elif node is VisualInstance3D:
		node.layers = collision_layer
	elif node is Camera3D:
		node.cull_mask = collision_mask
	node.child_entered_tree.connect(_child_entered_tree)

func register_controller(controller: LinkedController3D = null) -> void:
	if _controller != controller:
		if _controller:
			_controller.deregister_body(self)
		_controller = controller
	if not _controller:
		var ancestor: Node = get_parent()
		while ancestor and not ancestor is LinkedBody3D:
			ancestor = ancestor.get_parent()
		if ancestor:
			_controller = ancestor.get_controller()
		else:
			_controller = LinkedController3D.new()
	_controller.register_body(self)

func get_controller() -> LinkedController3D:
	if not _controller:
		register_controller()
	return _controller

func _on_link() -> void:
	_on_unlink()
	var links: Array[Node3D] = []
	for item: Node3D in get_children():
		if not item is RemoteTransform3D and not item is Generic6DOFJoint3D:
			var conn: Node3D
			if item is RigidBody3D:
				conn = Generic6DOFJoint3D.new()
				conn.node_a = self.get_path()
				conn.node_b = item.get_path()
			else:
				conn = RemoteTransform3D.new()
				conn.remote_path = item.get_path()
			conn.transform = global_transform.affine_inverse() * item.global_transform
			links.append(conn)
			add_child(conn)
	set_meta('links', links as Array[Node3D])
	_linked = true

func _on_unlink() -> void:
	for conn: Node3D in get_meta('links', []):
		if conn and conn.is_inside_tree():
			remove_child(conn)
			conn.queue_free()
	remove_meta('links')
	_linked = false

func _ready() -> void:
	register_controller(_controller)
	if _linked:
		_on_link()

func _process(delta: float) -> void:
	_controller._process(self, delta)

func _physics_process(delta: float) -> void:
	_controller._physics_process(self, delta)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_controller._integrate_forces(self, state)

func _exit_tree() -> void:
	_controller._exit_tree(self)

func _input(event: InputEvent) -> void:
	_controller._input(self, event)

func _shortcut_input(event: InputEvent) -> void:
	_controller._shortcut_input(self, event)

func _unhandled_input(event: InputEvent) -> void:
	_controller._unhandled_input(self, event)

func _unhandled_key_input(event: InputEvent) -> void:
	_controller._unhandled_key_input(self, event)

func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	_controller._input_event(self, camera, event, event_position, normal, shape_idx)

func _mouse_enter() -> void:
	_controller._mouse_enter(self)

func _mouse_exit() -> void:
	_controller._mouse_exit(self)
