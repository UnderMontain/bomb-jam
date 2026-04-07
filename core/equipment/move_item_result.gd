extends RefCounted
class_name MoveItemResult

enum ResultType {
	OK,
	OUT_OF_BOUNDS,
	NO_SPACE,
	INVALID_SLOT,
	MULTIPLE_ITEMS_CONFLICT
}

var success: bool
var type: ResultType
var replaced_items: Array = []
var message: String = ""
