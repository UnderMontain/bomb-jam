extends RefCounted
class_name ItemLocation

enum LocationType{
	INVENTORY,
	EQUIPMENT
}

var type: LocationType
var pos: Vector2i
var slot_name: String
