@tool
extends CharacterBody3D

@export var brain: PackedScene = preload("res://scenes/brains/brain.tscn")
@export var reach_distance: float = 3.0

func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("Updated", true)
	if not Engine.is_editor_hint():
		add_child(brain.instantiate())

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if get_meta("Updated", false):
			remove_meta("Updated")
	if not Engine.is_editor_hint():
		velocity += get_gravity() * delta
		move_and_slide()
