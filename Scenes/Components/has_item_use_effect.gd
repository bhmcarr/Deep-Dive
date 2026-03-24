extends Node2D

enum EffectType { Recovery, Upgrade }
enum StatType { Health, Speed }

@export var type: EffectType
@export var stat_to_upgrade: StatType
@export var stat_to_recover: StatType
@export var amount_to_upgrade: int
@export var amount_to_recover: int = 100

signal effect_finished

func use() -> void:
	match type:
		EffectType.Recovery:
			_recover_stat()
		EffectType.Upgrade:
			_upgrade_stat()


func _recover_stat() -> void:
	match stat_to_recover:
		StatType.Health:
			Global.add_health(amount_to_recover)
		# StatType.Speed:
		# 	pass

	effect_finished.emit()

func _upgrade_stat() -> void:
	match stat_to_upgrade:
		StatType.Health:
			Global.set_max_health(Global.player_max_health + amount_to_upgrade)
		StatType.Speed:
			Global.set_speed(Global.player_speed + amount_to_upgrade)
			
	effect_finished.emit()
