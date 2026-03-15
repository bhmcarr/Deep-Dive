extends Node

@export var current: Array[Item] = []
var SIZE_LIMIT = 3

signal item_added(new_item: Item)
signal item_removed(index_removed: int)

## Gets the current held item at provided index. Returns the item resource on success, and null on fail.
func get_item(item_index: int) -> Item:
	var element = current.get(item_index)
	if element:
		return element
	else:
		return null

## Adds an item to current inventory. Returns true if item was added successfully or false if it was unable to be added.
func add_item(new_item: Item) -> bool:
	if current.size() == SIZE_LIMIT:
		return false
	current.push_back(new_item)
	print("Added item: ", new_item.name)
	item_added.emit(new_item)
	return true
	
## Removes an item to current inventory. Returns the resource of the item removed.
func remove_item(index_to_remove: int) -> Item:
	var removed_item = current.pop_at(index_to_remove)
	print("Removed item: ", removed_item.name)
	item_removed.emit(index_to_remove)
	return removed_item
	
## Returns the current number of items in the player's inventory
func size() -> int:
	return current.size()
