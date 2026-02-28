extends Resource
class_name CardData

@export var name: String
@export var shape: Array[Vector2i]
var shape_rotated: Array[Vector2i]
@export var damage: int
@export var cost: int

@export var actions: Array[ActionDefinition]
