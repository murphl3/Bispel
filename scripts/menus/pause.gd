extends Control

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	Global.resume()
	hide()
