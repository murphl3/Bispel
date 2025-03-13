extends Node

var active_node: Node = null
var mouse_captured: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		pause()
	if mouse_captured and not active_node == null and event is InputEventMouseMotion:
		active_node.handleMouseMotion(event.relative)

func pause() -> void:
	Global.pause_menu.show()
	release_mouse()
	Global.paused = true

func resume() -> void:
	Global.pause_menu.hide()
	capture_mouse()
	Global.paused = false

func set_active(node: Node) -> void:
	active_node = node

func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_captured = false
