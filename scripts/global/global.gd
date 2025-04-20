extends Node

var id_map: Dictionary[int, Node] = {}
var current_id: int = -1

func add_id(node: Node) -> int:
	current_id += 1
	id_map.set(current_id, node)
	return current_id

# var horizontal_sensitivity: float = 0.01
# var vertical_sensitivity: float = 0.005
# var input_controller: Brain = null
# var mouse_captured: bool = false
# 
# func _unhandled_input(event: InputEvent) -> void:
# 	if Input.is_key_pressed(KEY_ESCAPE):
# 		get_tree().paused = true
# 		free_mouse()
# 	if mouse_captured and not input_controller == null and event is InputEventMouseMotion:
# 		input_controller.handleMouseMotion(event)
# 
# func _ready() -> void:
# 	process_mode = Node.PROCESS_MODE_ALWAYS
# 
# func capture_mouse() -> void:
# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# 	mouse_captured = true
# 
# func free_mouse() -> void:
# 	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
# 	mouse_captured = false
# 
