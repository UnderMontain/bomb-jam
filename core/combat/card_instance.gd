extends RefCounted
class_name CardInstance

var card_data: CardData

func _init(_card_data:CardData) -> void:
	card_data = _card_data

func Play(souce, targets:Array[CellData], game_manager:GameManager) -> void:

	var all_action: Array[Action]
	for action in card_data.actions:
		if action is DealDamageActionDefinition:
				for target in targets:
					if target.conent != null:
						game_manager.enqueue_action(action.create_action(souce, target.conent)) 
