extends Node

func _ready() -> void:
	Global.spawnPlayer()

func _process(_delta: float) -> void:
	pass

func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("id_required"):
		Global.attach_id(node)
	pass

func _on_child_exiting_tree(node: Node) -> void:
	var id = node.get_meta("id", false)
	if id:
		Global.remove_id(id)
	pass
