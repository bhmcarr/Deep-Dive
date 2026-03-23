extends Control
@onready var hp_label: Label = $HP2/HPLabel



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set initial health value
	hp_label.text = str(Global.player_current_health)
	Global.player_health_changed.connect(_on_player_health_changed)


func _on_player_health_changed(new_amount: int, did_health_decrease: bool) -> void:
	hp_label.text = str(new_amount)
