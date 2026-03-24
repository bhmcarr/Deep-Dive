extends Node2D
@onready var item_use_sound_player: AudioStreamPlayer2D = $ItemUseSoundPlayer
@onready var has_item_use_effect: Node2D = $HasItemUseEffect

func _ready() -> void:
	add_to_group("held_items")
	
	# connect to effect_finished signal
	has_item_use_effect.effect_finished.connect(_on_effect_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var rel_rotation = fmod(rotation_degrees, 360)
	
	if Input.is_action_just_pressed("shoot"):
		_use()
		
func _use() -> void:
	print("Used ", Inventory.get_item(Inventory.selected_item_index).name)

	if item_use_sound_player.stream != null:
		item_use_sound_player.playing = true
	
	Inventory.remove_charges(Inventory.selected_item_index, 1)
	has_item_use_effect.use()
	
func _on_effect_finished() -> void:
	# remove item from inventory and free the scene if charges == 0
	if Inventory.get_item(Inventory.selected_item_index).charges == 0:
		Inventory.remove_item(Inventory.selected_item_index)
		queue_free()
