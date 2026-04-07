extends Control
class_name InventoryUI


func _ready() -> void:
	PlayerState.inventory.inventory_updated.connect(refresh_update)


func refresh_update(grid:Dictionary):
	pass
