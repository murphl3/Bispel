@tool
extends Node3D

func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("Updated", true)
	if not Engine.is_editor_hint():
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if get_meta("Updated", false):
			remove_meta("Updated")
			notify_property_list_changed()
	if not Engine.is_editor_hint():
		pass
