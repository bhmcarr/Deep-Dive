extends Node

@export var amount_to_recover: int = 100

signal effect_finished()

func use() -> void:
	Global.add_health(amount_to_recover)
	effect_finished.emit()
