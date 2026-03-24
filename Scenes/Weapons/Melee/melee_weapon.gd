extends Node2D
@onready var melee_hitbox: Area2D = $MeleeHitbox

@export var melee_power := 1000.0
@export var melee_damage := 20
@export var shake_screen: bool

func _ready() -> void:
	add_to_group("held_items")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var rel_rotation = fmod(rotation_degrees, 360)
	var is_melee = Inventory.current[Inventory.selected_item_index].type == Item.ItemType.MeleeWeapon

func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	# TODO: Vary melee power (knockback) based on how much the melee weapon swung
	# You'll need a timer to update a value of how hard the weapon is currently being swung
	if body.get_collision_layer_value(3) || body.get_collision_layer_value(5):
		Global.weapon_fired.emit(shake_screen)
		var remaining_charges = Inventory.remove_charges(Inventory.selected_item_index, 1)
		body.apply_torque_impulse(melee_power)
		if body.has_node("ValuableHandler"):
			body.get_node("ValuableHandler").damage_valuable(melee_damage, (get_global_mouse_position() - position).normalized(),melee_power)
		if remaining_charges <= 0:
			queue_free()
