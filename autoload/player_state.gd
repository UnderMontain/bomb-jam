extends Node


var inventory : Inventory


func _ready() -> void:
	inventory = Inventory.new(Vector2i(10,8))

func can_move(item:Item, from: ItemLocation, to: ItemLocation)-> MoveItemResult:
	var move_item_result: MoveItemResult = MoveItemResult.new()
	
	match to.type:
		ItemLocation.LocationType.INVENTORY:
			move_item_result = inventory.can_place(item, to.pos)
	
	return move_item_result

func request_move_item(item:Item, from:ItemLocation, to: ItemLocation) -> MoveItemResult:
	var move_item_result: MoveItemResult
	move_item_result = can_move(item,from,to)
	
	if !move_item_result.success:
		return move_item_result
	
	match to.type:
		ItemLocation.LocationType.INVENTORY:
			inventory.place_item(item, to.pos)
	
	return move_item_result
	
