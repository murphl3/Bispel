extends Node

var current_id: int = 0
var id_dict: Dictionary[int, Node] = {}

func apply_id(node: Node) -> int:
	current_id += 1
	node.set_meta("id", current_id)
	id_dict[current_id] = node
	return current_id

func _ready() -> void:
	pass
