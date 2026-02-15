extends Node2D
class_name Board

@export var grid_size :Vector2i
@export var cell_scene: PackedScene

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var grid: Node2D = $Grid
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var cells : Dictionary[Vector2i,GridCell]
var cell_data: Dictionary[Vector2i, CellData] = {}

const EXPLOTION = preload("uid://cnngjbksnqusx")


func _ready() -> void:
	build_grid()

func _process(delta: float) -> void:
	get_cell()

func build_grid():
	var cell_size = Vector2(16,16)
	#board_sprite.texture.get_size()
	var origin = (board_sprite.texture.get_size() / -2) + cell_size 
	origin += Vector2(0,3)
	for y in grid_size.y:
		for x in grid_size.x:
			var cell = cell_scene.instantiate() as GridCell
			cell.coord = Vector2i(x,y)
			cell.position = origin + Vector2(
				x * cell_size.x,
				y * cell_size.y
			)
			cell.clicked.connect(_on_cell_clicked)
			cell.hovered.connect(GameManager._on_cell_hovered)
			cell.unhovered.connect(GameManager._on_cell_unhovered)
			grid.add_child(cell)
			cells[cell.coord] = cell
			cell_data[cell.coord] = CellData.new()
			cell_data[cell.coord].conent = null
			cell_data[cell.coord].coord_world = cell.position

func show_preview(hovered_cell:Vector2i, card: CardData):
	clear_preview()
	var result = check_cells(hovered_cell,card.shape_rotated)
	for cell in result:
		cells[cell].preview(true)

func get_cell():
	var mouse_position = get_global_mouse_position()
	var cell = tile_map_layer.to_local(mouse_position)
	cell = tile_map_layer.local_to_map(cell)
	print(cell)

func clear_preview():
	for cell in cells:
		cells[cell].preview(false)

func _on_cell_clicked(coord: Vector2i):
	GameManager.on_cell_clicked(coord)

func add_enemy(coord: Vector2i, enemy: Node2D):
	var current_cell = cell_data[coord]
	
	if current_cell.conent == null:
		current_cell.conent = enemy
		enemy.global_position = current_cell.coord_world
		add_child(enemy)

func aplay_card(origin:Vector2i, card:CardData):
	var cells_aplay = check_cells(origin, card.shape_rotated)
	print_debug(cells_aplay)
	for cell in cells_aplay:
		var explotion = EXPLOTION.instantiate() as AnimatedSprite2D
		explotion.global_position = cell_data[cell].coord_world
		add_child(explotion)
		explotion.get_node("GPUParticles2D").restart()
		explotion.animation_finished.connect(explotion.queue_free)
	for cell in cells_aplay:
		if cell_data[cell].conent != null:
			cell_data[cell].conent.died.connect(on_enemy_die)
			await cell_data[cell].conent.take_damage(cell,card.damage)

func on_enemy_die(cell_position : Vector2i):
	cell_data[cell_position].conent = null

func get_enemies()-> Array[Enemy]:
	var result:Array[Enemy]
	for cell in cell_data:
		if cell_data[cell].conent != null:
			result.append(cell_data[cell].conent)
	return result

func get_cell_empty()-> Array[Vector2i]:
	var result:Array[Vector2i]
	for cell in cell_data:
		if cell_data[cell].conent == null:
			result.append(cell)
	return result

func check_cells(origin: Vector2i, shape: Array[Vector2i]) -> Array[Vector2i]:
	var results : Array[Vector2i]
	for coord in shape:
		var result = origin + coord
		if cell_data.has(result):
			results.append(result) 
	return results
