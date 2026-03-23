extends Node

var player_max_health: int = 100
var player_current_health: int = 50

signal weapon_changed
signal weapon_fired(shake_screen: bool)
signal player_health_changed(new_value: int, did_health_decrease: bool)


func remove_health(amount: int) -> int:
	var total = player_current_health - amount
	if total <= 0:
		player_current_health = 0
	else:
		player_current_health = total
	player_health_changed.emit(player_current_health, true)
	return player_current_health
	
func add_health(amount: int) -> int:
	var total = player_current_health + amount
	if total >= player_max_health:
		player_current_health = player_max_health
	else:
		player_current_health = total
	player_health_changed.emit(player_current_health, false)
	return player_current_health
