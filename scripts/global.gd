extends Node

@export var game_seed: int = 876543
var terrain_rng = RandomNumberGenerator.new()
var rng = RandomNumberGenerator.new()
@onready var root: Node = get_tree().root.get_node("Main")
var current_id: int = 0
var id_list: Dictionary = {}
var paused: bool = false
var pause_menu: Control = null

func _ready() -> void:
	pause_menu = root.pause_menu.instantiate()
	pause_menu.hide()
	root.add_child(pause_menu)
	terrain_rng.seed = game_seed
	rng.seed = game_seed
	root.child_entered_tree.connect(apply_id)
	root.child_exiting_tree.connect(remove_id)
	DisplayServer.window_set_size(DisplayServer.window_get_size())

func apply_id(node: Node) -> void:
	if node.is_in_group("id_required"):
		current_id += 1
		node.set_meta("id", current_id)
		id_list[current_id] = node
		print(id_list)

func remove_id(node: Node) -> void:
	if node.is_in_group("id_required"):
		id_list.erase(node.get_meta("id"))

func _get_valid_spawnpoints(entity: Node) -> Array[Marker3D]:
	var spawnpoints: Array[Marker3D]
	var type = GlobalEnums.Entities.get(entity.name)
	if not type == null:
		spawnpoints.assign(get_tree().get_nodes_in_group("Spawnpoint").filter(func x(spawnpoint: Marker3D):
			return spawnpoint.active and type in spawnpoint.spawnable_entities
		))
	return spawnpoints

func spawn(entity: Node) -> void:
	var spawnpoint = _get_valid_spawnpoints(entity).pick_random()
	if spawnpoint == null:
		spawnpoint = Marker3D.new()
	entity.rotation = spawnpoint.rotation
	entity.position = spawnpoint.position
	entity.spawn_behavior()
