extends Node
const PLACEHOLDER = preload("uid://bnwc4qm2wdrud")

@export var current: Array[Item] = [PLACEHOLDER, PLACEHOLDER, PLACEHOLDER]
var SIZE_LIMIT = 3
var selected_item_index: int = 0

signal item_added(new_item: Item)
signal item_removed(index_removed: int)
signal item_selected(new_selected_index: int)
signal charge_value_changed(item_index: int, new_charge_value: int)

## Gets the current held item at provided index. Returns the item resource on success, and null on fail.
func get_item(item_index: int) -> Item:
	if item_index >= current.size():
		return null
	return current.get(item_index)

## Adds an item to current inventory. Returns true if item was added successfully or false if it was unable to be added.
func add_item(new_item: Item) -> bool:
	# find the first placeholder and replace it
	var placeholder_index = current.find(PLACEHOLDER)
	if placeholder_index == -1:
		return false
	current[placeholder_index] = new_item.duplicate()
	print("Added item: ", new_item.name)
	item_added.emit(current[placeholder_index])
	charge_value_changed.emit(placeholder_index, current[placeholder_index].charges)
	return true
	
## Removes an item to current inventory. Returns the resource of the item removed.
func remove_item(index_to_remove: int) -> Item:
	var removed_item = current[index_to_remove]
	current[index_to_remove] = PLACEHOLDER
	print("Removed item: ", removed_item.name)
	item_removed.emit(index_to_remove)
	return removed_item
	
## Returns the current number of items in the player's inventory
func size() -> int:
	# get count of items that are NOT placeholders
	var count = 0
	for item in current:
		if item != PLACEHOLDER:
			count += 1
	return count
	
## Returns true if inventory is full and false otherwise
func is_full() -> bool:
	if size() >= SIZE_LIMIT:
		return true
	else:
		return false

## Sets the selected item index to new_index. Returns true on success and false on fail.
func set_selected_item_index(new_index: int) -> bool:
	if new_index >= SIZE_LIMIT:
		return false
	selected_item_index = new_index
	item_selected.emit(new_index)
	return true
	
## Decrements the number of charges on the item in the selected inventory index, then returns the number of remaining charges
func remove_charges(index: int, amount: int) -> int:
	current[index].charges -= amount
	charge_value_changed.emit(selected_item_index, current[index].charges)
	return current[index].charges
	
## Increments the number of charges on the item in the selected inventory index, then returns the number of remaining charges
func add_charges(index: int, amount: int) -> int:
	current[index].charges += amount
	charge_value_changed.emit(selected_item_index, current[index].charges)
	return current[index].charges
