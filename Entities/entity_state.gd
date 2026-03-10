extends RefCounted
class_name EntityState


var entity_data: EntityData
var position_in_board:Vector2i


func _init(_data:EntityData,_position) -> void:
	entity_data = _data
	position_in_board = _position

func destroy(game_manager: GameManager):
	pass
