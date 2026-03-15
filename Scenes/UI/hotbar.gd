extends Control

@onready var item_sprite_1: Sprite2D = $Panel/ItemSprite1
@onready var item_sprite_2: Sprite2D = $Panel/ItemSprite2
@onready var item_sprite_3: Sprite2D = $Panel/ItemSprite3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_sprite_1.texture = null
	item_sprite_2.texture = null
	item_sprite_3.texture = null

	Inventory.item_added.connect(_on_item_added)
	Inventory.item_removed.connect(_on_item_removed)

func _on_item_added(new_item: Item) -> void:
	_update_item_info()
	
func _on_item_removed(index_removed: int) -> void:
	_update_item_info()
	
func _update_item_info() -> void:
	var size = Inventory.size()
	if size > 0:
		item_sprite_1.texture = load(Inventory.get_item(0).image_path)
	if size > 1:
		item_sprite_2.texture = load(Inventory.get_item(1).image_path)
	if size > 2:
		item_sprite_3.texture = load(Inventory.get_item(2).image_path)
