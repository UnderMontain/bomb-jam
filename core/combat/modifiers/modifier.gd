extends RefCounted
class_name Modifier

var owner

func _init(_owner) -> void:
	owner = _owner

func on_event(event_type:StringName, data: Dictionary) -> Action:
	return null

func modify_action(action: Action) -> void :
	pass
