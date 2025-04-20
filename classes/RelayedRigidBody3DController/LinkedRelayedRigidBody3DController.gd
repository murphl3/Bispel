extends RelayedRigidBody3DController
class_name LinkedRelayedRigidBody3DController

@export var connection_lock: bool = true
@export var layer_override: bool = false

signal update_connections(nodes: Array[Node], val: bool)
signal propagate_layers(nodes: Array[Node], override: bool)

func _init() -> void:
	super()
	_on_update_connections([_parent], connection_lock)

func _on_ready() -> void:
	_on_propagate_layers([_parent], false)

func _on_update_connections(nodes: Array[Node], val: bool) -> void:
	if not _parent in nodes:
		return
	connection_lock = val
	_update_connections.call_deferred(_parent)

func _update_connections(node: Node) -> void:
	if not node:
		return
	if not node.is_connected("child_entered_tree", _update_connections):
		node.child_entered_tree.connect(_update_connections)
	if node == _parent:
		return
	if node is RigidBody3D:
		if connection_lock == node.has_meta("connection_lock"):
			_update_connections.call_deferred(node)
			return
		if connection_lock and node.has_meta("connection_lock"):
			var connection = node.get_meta("connection_lock")
			_parent.remove_child(connection)
			node.remove_meta("connection_lock")
			connection.queue_free()
			_update_connections.call_deferred(node)
			return
		var connection: Variant
		if node is RigidBody3D:
			connection = Generic6DOFJoint3D.new()
			if node is RelayedRigidBody3D and node.controller is LinkedRelayedRigidBody3DController:
				node._update_connections.call_deferred(node)
		else:
			connection = RemoteTransform3D.new()
		connection.global_transform = node.global_transform
		_parent.add_child(connection)
	

func _on_propagate_layers(nodes: Array[Node], override: bool) -> void:
	if not _parent in nodes:
		return
	layer_override = override
	_propagate_layers.call_deferred(_parent)

func _propagate_layers(node: Node) -> void:
	if not node:
		return
	if not node.is_connected("child_entered_tree", _propagate_layers):
		node.child_entered_tree.connect(_propagate_layers)
	if node == _parent:
		return
	if node is RelayedRigidBody3D and node.controller is LinkedRelayedRigidBody3DController:
		if layer_override:
			node.collision_layer = _parent.collision_layer
			node.collision_mask = _parent.collision_mask
		node._propagate_layers.call_deferred(node, false)
		return
	if node is PhysicsBody3D:
		node.collision_layer = _parent.collision_layer
		node.collision_mask = _parent.collision_mask
	elif node is VisualInstance3D:
		node.layers = _parent.collision_layer
	elif node is Camera3D:
		node.cull_mask = _parent.collision_mask
