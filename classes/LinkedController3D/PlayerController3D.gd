extends AgentController3D
class_name PlayerController3D

func _process(body: LinkedBody3D, delta: float) -> void:
	super._process(body, delta)

func _physics_process(body: LinkedBody3D, delta: float) -> void:
	super._physics_process(body, delta)

func _integrate_forces(body: LinkedBody3D, state: PhysicsDirectBodyState3D) -> void:
	super._integrate_forces(body, state)
