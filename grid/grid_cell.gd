extends Area2D
class_name GridCell

var coord: Vector2i

signal clicked(coord)

func _on_pressed() -> void:
	clicked.emit(coord)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse and event.is_pressed():
		clicked.emit(coord)
