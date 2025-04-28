extends Resource
class_name LinkedController3D

signal link
signal unlink
signal bodies_updated

var _bodies: Array[LinkedBody3D] = []
var _blocked_signals: Array[StringName]
var mass: float = 0.0
var global_position: Vector3 = Vector3.ZERO	
var linear_velocity: Vector3 = Vector3.ZERO
var angular_velocity: Vector3 = Vector3.ZERO


func _init() -> void:
	_blocked_signals = [
		'changed',
		'setup_local_to_scene_requested',
		'script_changed',
		'property_list_changed'
	]

func register_body(body: LinkedBody3D) -> void:
	if not body in _bodies:
		_bodies.append(body)
	connect_signals(body)
	_bodies_updated()
	
func deregister_body(body: LinkedBody3D) -> void:
	if body in _bodies:
		_bodies.erase(body)
	disconnect_signals(body)
	_bodies_updated()

func _bodies_updated() -> void:
	mass = _bodies.reduce(func(accumulator: float, body: LinkedBody3D) -> float: return accumulator + body.mass, 0.0)
	bodies_updated.emit()

func connect_signals(body: LinkedBody3D) -> void:
	for sig: Dictionary in body.get_signal_list().filter(func(x): return x.name not in body._blocked_signals):
		var handler: Callable = Callable(self, '_on_' + sig.name).bind(body)
		if has_method(handler.get_method()) and not body.is_connected(sig.name, handler):
			body.connect(sig.name, handler)
	for sig: Dictionary in get_signal_list().filter(func(x): return x.name not in _blocked_signals):
		var handler: Callable = Callable(body, '_on_' + sig.name)
		if body.has_method(handler.get_method()) and not is_connected(sig.name, handler):
			connect(sig.name, handler)

func disconnect_signals(body: LinkedBody3D) -> void:
	for sig: Dictionary in body.get_signal_list().filter(func(x): return x.name not in body._blocked_signals):
		var handler: Callable = Callable(self, '_on_' + sig.name).bind(body)
		if has_method(handler.get_method()) and body.is_connected(sig.name, handler):
			body.disconnect(sig.name, handler)
	for sig: Dictionary in get_signal_list().filter(func(x): return x.name not in _blocked_signals):
		var handler: Callable = Callable(body, '_on_' + sig.name)
		if body.has_method(handler.get_method()) and is_connected(sig.name, handler):
			disconnect(sig.name, handler)

func _process(_body: LinkedBody3D, _delta: float) -> void:
	pass

func _physics_process(_body: LinkedBody3D, _delta: float) -> void:
	pass

func _integrate_forces(_body: LinkedBody3D, _state: PhysicsDirectBodyState3D) -> void:
	pass

func _exit_tree(_body: LinkedBody3D) -> void:
	pass

func _input(_body: LinkedBody3D, _event: InputEvent) -> void:
	pass

func _shortcut_input(_body: LinkedBody3D, _event: InputEvent) -> void:
	pass

func _unhandled_input(_body: LinkedBody3D, _event: InputEvent) -> void:
	pass

func _unhandled_key_input(_body: LinkedBody3D, _event: InputEvent) -> void:
	pass

func _input_event(_body: LinkedBody3D, _camera: Camera3D, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass

func _mouse_enter(_body: LinkedBody3D) -> void:
	pass

func _mouse_exit(_body: LinkedBody3D) -> void:
	pass
