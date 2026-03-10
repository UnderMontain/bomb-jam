extends Action
class_name DestroyEntityAction

var target: EntityState

func _init(_target:EntityState) -> void:
	target = _target


func execute(game_magener:GameManager) -> void:
	game_magener.current_board.deleate_entity(target)
	target.destroy(game_magener)
	print("Is DEATH")
