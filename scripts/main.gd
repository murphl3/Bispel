@tool
extends Node

@export var player: PackedScene = preload("res://scenes/player.tscn")
@export var default_scene: PackedScene = preload("res://scenes/hub.tscn")

func _ready() -> void:
	add_child(default_scene.instantiate())
	add_child(player.instantiate())
