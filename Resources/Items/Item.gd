class_name Item
extends Resource

enum ItemType { RangedWeapon, MeleeWeapon, Consumable, Placeholder }

@export var id: int
@export var name: String
@export var image_path: String
@export var value: int
@export var node_path: String
@export var type: ItemType
@export var charges: int

# TODO: Why don't we need this again?
#func _init(
	#p_type: ItemType,
	#p_id: int = 0, 
	#p_name: String = "ITEM_NAME",
	#p_image_path: String = "", 
	#p_value: int = 0, 
	#p_node_path: String = "",
#) -> void:
	#id = p_id
	#name = p_name
	#image_path = p_image_path
	#value = p_value
	#node_path = p_node_path
	#type = p_type
