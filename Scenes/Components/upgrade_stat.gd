extends Node

enum StatType { Health, Speed }

@export var stat_to_upgrade: StatType
@export var amount_to_upgrade: int

signal effect_finished

func use() -> void:
	match stat_to_upgrade:
		StatType.Health:
			Global.player_max_health += amount_to_upgrade
		StatType.Speed:
			Global.player_speed += amount_to_upgrade
			
	effect_finished.emit()
