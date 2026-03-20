extends Control

@onready var item_sprite_1: Sprite2D = $Panel/ItemSprite1
@onready var item_sprite_2: Sprite2D = $Panel/ItemSprite2
@onready var item_sprite_3: Sprite2D = $Panel/ItemSprite3

@onready var charges_1: Label = $"Panel/ChargeLabels/1"
@onready var charges_2: Label = $"Panel/ChargeLabels/2"
@onready var charges_3: Label = $"Panel/ChargeLabels/3"

@onready var hotbar_selector: Sprite2D = $Panel/HotbarSelector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_sprite_1.texture = null
	item_sprite_2.texture = null
	item_sprite_3.texture = null

	Inventory.item_added.connect(_on_item_added)
	Inventory.item_removed.connect(_on_item_removed)
	Inventory.item_selected.connect(_on_item_selected)
	Inventory.charge_value_changed.connect(_on_charge_value_changed)

func _on_item_added(new_item: Item) -> void:
	_update_item_info()
	
func _on_item_removed(index_removed: int) -> void:
	_update_item_info()
	match index_removed:
		0:
			charges_1.text = ''
		1:
			charges_2.text = ''
		2:
			charges_3.text = ''
	
func _on_item_selected(new_index: int) -> void:
	_update_item_info()
	
func _on_charge_value_changed(item_index: int, new_charge_value: int) -> void:
	# Update charge values
	match item_index:
		0:
			charges_1.text = str(new_charge_value)
		1:
			charges_2.text = str(new_charge_value)
		2:
			charges_3.text = str(new_charge_value)

func _clear_icons() -> void:
	item_sprite_1.texture = null
	item_sprite_2.texture = null
	item_sprite_3.texture = null
	
func _update_item_info() -> void:
	_clear_icons()
	item_sprite_1.texture = load(Inventory.get_item(0).image_path)
	item_sprite_2.texture = load(Inventory.get_item(1).image_path)
	item_sprite_3.texture = load(Inventory.get_item(2).image_path)
		
	# Update selector position
	match Inventory.selected_item_index:
		0:
			hotbar_selector.position = item_sprite_1.position
		1:
			hotbar_selector.position = item_sprite_2.position
		2:
			hotbar_selector.position = item_sprite_3.position
	
