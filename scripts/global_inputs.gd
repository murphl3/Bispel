extends Node

var active_node: Node = null
var mouse_captured: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
		resume()
	if Input.is_key_pressed(KEY_ESCAPE):
		pause()
		release_mouse()
	if mouse_captured and not active_node == null and event is InputEventMouseMotion:
		active_node.handleMouseMotion(event.relative)

func pause() -> void:
	Global.paused = true

func resume() -> void:
	Global.paused = false

func set_active(node: Node) -> void:
	active_node = node

func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_captured = false
