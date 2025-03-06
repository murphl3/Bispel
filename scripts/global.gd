extends Node

@onready var rngSeed: int = 1
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var idDict: Dictionary = {}
@onready var current_id: int = 1
@onready var playerScene: PackedScene = preload("res://scenes/player.tscn")
@onready var playerCount: int = 1

func attach_id(node: Node) -> void:
	node.set_meta("id", current_id)
	idDict[current_id] = node
	current_id += 1

func remove_id(id: int):
	if idDict.has(id):
		idDict.erase(id)

func spawnPlayer(id: int = 0) -> void:
	var spawners = get_tree().get_nodes_in_group("Spawner")\
		.filter(func(n: Node) -> bool: return n.get_meta("Active", false))\
		.filter(func(n: Node) -> bool: return n.get_meta("SpawnTypes", []).has("Player"))
	var player: CharacterBody3D
	if idDict.has(id):
		player = idDict[id]
	else:
		player = playerScene.instantiate()
		get_tree().root.get_node("Main").add_child(player)
	if spawners.size() > 0:
		var spawner = spawners.pick_random()
		player.position = spawner.position
		player.basis = spawner.basis

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
