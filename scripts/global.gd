extends Node

@onready var rngSeed: int = 1
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var idDict: Dictionary = {}
@onready var current_id: int = 1

func attach_id(node: Node) -> void:
	node.set_meta("id", current_id)
	idDict[current_id] = node
	current_id += 1

func remove_id(id: int):
	idDict.erase(id)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
