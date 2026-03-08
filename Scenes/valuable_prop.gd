extends RigidBody2D

@export var value: int = 100
@onready var floating_text_emitter: Node2D = $FloatingTextEmitter

func damage_prop(damage_value: int) -> void:
	value -= damage_value
	floating_text_emitter.emit_text("$" + str(value))
	if value <= 0:
		print("valuable destroyed")
		queue_free()
