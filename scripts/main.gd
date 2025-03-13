@tool
extends Node

@export var initial_scene: PackedScene = preload("res://scenes/maps/hub.tscn")
var current_scenes: Array[Node] = []

func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("Updated", true)
	if not Engine.is_editor_hint():
		pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if get_meta("Updated"):
			pass
	if not Engine.is_editor_hint():
		pass
