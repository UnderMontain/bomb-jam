extends Node2D
class_name Board

@export var grid_size :Vector2i
@export var cell_scene: PackedScene

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var grid: Node2D = $Grid

var cells := {}
var cell_data: Dictionary[Vector2i, CellData] = {}

func _ready() -> void:
	build_grid()

func build_grid():
	var cell_size = Vector2(16,16)
	var origin = (board_sprite.texture.get_size() / -2) + cell_size / 2
	for y in grid_size.y:
		for x in grid_size.x:
			var cell = cell_scene.instantiate() as GridCell
			cell.coord = Vector2i(x,y)
			cell.position = origin + Vector2(
				x * cell_size.x,
				y * cell_size.y
			)
			cell.clicked.connect(_on_cell_clicked)
			grid.add_child(cell)
			cells[cell.coord] = cell
			cell_data[cell.coord] = CellData.new()
			cell_data[cell.coord].conent = null
			cell_data[cell.coord].coord_world = cell.position

func _on_cell_clicked(coord: Vector2i):
	GameManager.on_cell_clicked(coord)

func add_enemy(coord: Vector2i, enemy: Node2D):
	var current_cell = cell_data[coord]
	
	if current_cell.conent == null:
		current_cell.conent = enemy
		enemy.global_position = current_cell.coord_world
		add_child(enemy)

func aplay_card(origin:Vector2i, card:CardData):
	var cells_aplay = check_cells(origin, card.shape)
	print_debug(cells_aplay) 
	for cell in cells_aplay:
		if cell_data[cell].conent != null:
			cell_data[cell].conent.take_damage()
	
	pass

func check_cells(origin: Vector2i, shape: Array[Vector2i]) -> Array[Vector2i]:
	var results : Array[Vector2i]
	for coord in shape:
		var result = origin + coord
		if cell_data.has(result):
			results.append(result) 
	return results
