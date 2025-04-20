extends RefCounted
class_name Relay

var _parent: Object
var signals: Dictionary[StringName, RefCounted] = {}

func _init(parent: Object) -> void:
	_parent = parent

func send(message: Array[Variant]) -> void:
	emit_signal.callv(message)

func register_signal(message: Dictionary) -> RefCounted:
	if not message.name in signals:
		signals.set(message.name, RefCounted.new())
		add_user_signal(message.name, message.args)
	return signals[message.name]

func update_signals() -> void:
	for message in signals.keys():
		if signals[message].get_reference_count() < 2:
			if has_user_signal(message):
				remove_user_signal(message)
			signals.erase(message)
