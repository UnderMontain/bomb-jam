extends ActionDefinition
class_name DealDamageActionDefinition

@export var damage : int = 0

func create_action(source, target:CellData)->Action:
	return DealDamageAction.new(source, target, damage)
