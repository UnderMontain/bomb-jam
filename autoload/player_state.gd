extends Node


var inventory : Inventory


func _ready() -> void:
	inventory = Inventory.new(Vector2i(10,8))
