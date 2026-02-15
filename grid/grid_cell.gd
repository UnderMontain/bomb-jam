extends Area2D
class_name GridCell

var coord: Vector2i

@onready var sprite_2d: Sprite2D = $Sprite2D
var color_sprite
signal clicked(coord)

signal hovered(coord: Vector2i)
signal unhovered(coord: Vector2i)

func _ready() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0)
	color_sprite = sprite_2d.texture
	
func _on_pressed() -> void:
	clicked.emit(coord)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse and event.is_pressed():
		clicked.emit(coord)

func preview(condition: bool):
	if condition:
		sprite_2d.modulate = Color(1, 1, 1, 0.2)
	else:
		sprite_2d.modulate = Color(1, 1, 1, 0)

func _on_mouse_entered() -> void:
	hovered.emit(coord)

func _on_mouse_exited() -> void:
	unhovered.emit(coord)
