extends RigidBody2D

@export var value: int = 100

func damage_prop(damage_value: int) -> void:
	value -= damage_value
	if value <= 0:
		print("valuable destroyed")
		queue_free()
