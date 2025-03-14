@tool
extends Node

@export var initial_scene: PackedScene = preload("res://scenes/maps/hub.tscn")
var current_scenes: Array[Node] = []

func add_scene(scene: PackedScene, transform: Transform3D = Transform3D.IDENTITY) -> void:
	if not scene.can_instantiate():
		return
	var instance: Node3D = scene.instantiate()
	if not instance is Node3D:
		instance.queue_free()
		return
	if not Engine.is_editor_hint() and instance.is_in_group("id_required"):
		Global.apply_id(instance)
	instance.transform = transform
	add_child(instance)

func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("Updated", true)
	if not Engine.is_editor_hint():
		pass
	add_scene(initial_scene)
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if not get_meta("Updated", false):
			remove_meta("Updated")
			notify_property_list_changed()
	if not Engine.is_editor_hint():
		pass
