extends Node

signal physics_frame(delta: float)
signal process_frame(delta: float)

func _physics_process(delta: float) -> void:
	physics_frame.emit(delta)

func _process(delta: float) -> void:
	process_frame.emit(delta)
