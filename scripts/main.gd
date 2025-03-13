extends Node

@export var player: PackedScene = preload("res://scenes/player.tscn")
@export var default_scene: PackedScene = preload("res://scenes/hub.tscn")
@export var pause_menu: PackedScene = preload("res://scenes/pause_menu.tscn")

func _ready() -> void:
	add_child(default_scene.instantiate())
	add_child(player.instantiate())
