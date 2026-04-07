extends RefCounted
class_name Inventory

var grid: Dictionary[Vector2i,Item]

signal inventory_updated(grid)

func _init(size_grid: Vector2i) -> void:
	for y in size_grid:
		for x in size_grid:
			grid[Vector2i(x,y)] = null

func can_place(item:Item, pos:Vector2i)-> MoveItemResult:
	var result: MoveItemResult = MoveItemResult.new()
	var overlapping_items: Array[Item]
	var target: Vector2i = Vector2i.ZERO
	
	for x in item.item_data.size.x:
		for y in item.item_data.size.y:
			target = Vector2i(pos.x + x, pos.y + y)
			if !grid.has(target): ## Fuera del tablero
				result.success = false
				result.type = result.ResultType.OUT_OF_BOUNDS
				return result
			if grid[target] != null: ## Existe un item
				if grid[target] == item: ## Es el mismo item que se esta intentando mover
					if !overlapping_items.has(grid[target]): ## El item no existe en items
						overlapping_items.append(grid[target])
	
	if !overlapping_items.is_empty(): ## hay mas de un item para intercambiar
		result.success = false
		result.type = result.ResultType.MULTIPLE_ITEMS_CONFLICT
		return result
	
	result.success = true
	result.type = result.ResultType.OK
	result.replaced_items = overlapping_items
	
	return result


func place_item(item:Item, pos:Vector2i):
	for x in item.item_data.size.x:
		for y in item.item_data.size.y:
			var target_pos = Vector2i(
				x + pos.x,
				y + pos.y
			)
			grid[target_pos] = item
