extends PIDController
class_name Vector3PIDController

@export var _p: Vector3 = Vector3(1.0, 1.0, 1.0)
@export var _i: Vector3 = Vector3.ZERO
@export var _d: Vector3 = Vector3.ZERO
var _prev: Vector3 = Vector3.ZERO
var _integral: Vector3 = Vector3.ZERO

func _init() -> void:
	pass

func correct(error: Vector3, delta: float) -> Vector3:
	_integral += error * delta
	var derivative = (error - _prev) / delta
	_prev = error
	return _p * error + _i * _integral + _d * derivative
	
func update_parameters(p: Vector3, i: Vector3, d: Vector3) -> void:
	_p += p
	_i += i
	_d += d

func set_parameters(p: Vector3, i: Vector3, d: Vector3) -> void:
	_p = p
	_i = i
	_d = d
