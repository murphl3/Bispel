extends Resource
class_name RelayedRigidBody3DController

var _parent: RelayedRigidBody3D
var relay: Relay
var signal_registry: Dictionary[StringName, RefCounted] = {}

func _init() -> void:
	pass

func _set_parent(parent: RelayedRigidBody3D) -> void:
	_parent = parent
	relay = parent.get_meta("relay")
	var default_signals: Array = Resource.new().get_signal_list().map(func(x): return x.name)
	for message in get_signal_list().filter(func(x): return not x.name in default_signals):
		signal_registry.set(message.name, relay.register_signal(message))
		assert(has_method("_on_" + message.name), "Signal \"" + message.name + "\" exists, but not its handler: \"_on_" + message.name + "(...)\"")
		relay.connect(message.name, Callable(self, "_on_" + message.name))

func _on_ready() -> void:
	pass

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	pass

func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass

func _shortcut_input(_event: InputEvent) -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	pass

func _unhandled_key_input(_event: InputEvent) -> void:
	pass

func _input_event(_camera: Camera3D, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass

func _mouse_enter() -> void:
	pass

func _mouse_exit() -> void:
	pass

func _notification(_what: int) -> void:
	pass
