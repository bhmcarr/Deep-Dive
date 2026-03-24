extends Node

# Health
var player_max_health: int = 100
var player_current_health: int = 50

# Movement Speed
var player_speed: int = 100

signal weapon_changed
signal weapon_fired(shake_screen: bool)
signal player_health_changed(new_value: int, did_health_decrease: bool)
signal player_max_health_changed(new_value: int, did_health_decrease: bool)
signal player_speed_changed(new_value: int, did_stat_decrease: bool)


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

func set_max_health(new_amount: int) -> int:
	player_max_health = new_amount
	player_max_health_changed.emit(new_amount, false)
	return player_max_health
	
func set_speed(new_amount: int) -> int:
	player_speed = new_amount
	player_speed_changed.emit(new_amount, false)
	return player_speed
