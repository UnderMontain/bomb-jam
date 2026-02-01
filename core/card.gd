extends Node2D
class_name Card

@onready var cost: Label = $Control/Cost
@onready var damage: Label = $Control/Damage
@onready var marker_2d: Marker2D = $Marker2D
const FORM = preload("uid://dl4hpqa3pi5bs")

var grid_size :Vector2i

var cells_preview := {}

func _ready() -> void:
	var card = CardData.new()
	card.cost = 0
	card.damage = 2
	var forma: Array[Vector2i] = [
		Vector2i(0,0),
		Vector2i(0,1),
		Vector2i(1,0)
	]
	card.shape = forma
	build()

func build():
	grid_size = Vector2i(3,3)
	var cell_size = Vector2(16,16)
	var center = Vector2 (
		(grid_size.x -1) /2,
		(grid_size.y -1) /2 
		) * cell_size
	for y in grid_size.y:
		for x in grid_size.x:
			var cell = Sprite2D.new()
			cell.texture = FORM
			cell.position = Vector2(
				x * cell_size.x,
				y * cell_size.y
			) - center
			marker_2d.add_child(cell)
			cell.modulate = Color(1.0, 1.0, 1.0, 0.2)
			var coord = Vector2i(x,y)
			cells_preview[coord] = cell

func show_preview(card_data: CardData):
	for i in cells_preview:
		cells_preview[i].modulate = Color(1.0, 1.0, 1.0, 0.2)
	cost.text = str(card_data.cost)
	damage.text = str(card_data.damage) 
	for i in card_data.shape:
		cells_preview[i + Vector2i(1,1)].modulate = Color(1.0, 1.0, 1.0, 1.0)

func discard():
	pass
