extends ActionDefinition
class_name DealDamageActionDefinition

@export var damage : int = 0

func create_action(source, targets):
	return DealDamageAction.new(source, targets, damage)
