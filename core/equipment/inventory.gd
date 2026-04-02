extends RefCounted
class_name Inventory

var grid: Dictionary[Vector2i,Item]

signal inventory_updated(grid)

func _init(size_grid: Vector2i) -> void:
	for y in size_grid:
		for x in size_grid:
			grid[Vector2i(x,y)] = null

#func can_place(item:Item, pos:Vector2i)-> Dictionary:
	##var items: Array[Item] = {}
	##for x in item.item_data.size.x:
		##for y in item.item_data.size.y:
	#return 

#func add_item_at_pos(item:Item, pos:Vector2i):
	#for cell in item.item_data.size:
		#var target = cell + pos
		#pass
