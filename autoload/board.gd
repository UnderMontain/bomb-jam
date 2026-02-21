extends Node2D
class_name Board

@export var grid_size :Vector2i
@export var cell_scene: PackedScene

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var grid: Node2D = $Grid
@onready var tile_map_board: TileMapLayer = $TileMapBoard
@onready var tile_map_preview: TileMapLayer = $TileMapPreview

#var cells : Dictionary[Vector2i,GridCell]
var last_cell_under_mouse: Vector2i = Vector2i(0,0)
var cell_data: Dictionary[Vector2i, CellData] = {}

signal hovered(coord: Vector2i)
signal cell_clicked(coord: Vector2i)

const EXPLOTION = preload("uid://cnngjbksnqusx")

func _ready() -> void:
	build_grid()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_cell:Vector2i = get_cell()
		if is_inside_grid(new_cell):
			if new_cell != last_cell_under_mouse:
				last_cell_under_mouse = new_cell
				hovered.emit(last_cell_under_mouse)
				print(new_cell)


func _input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed():
		var cell_click = get_cell()
		if is_inside_grid(cell_click):
			cell_clicked.emit(cell_click)

func build_grid():
	var cell_size = Vector2(16,16)
	#board_sprite.texture.get_size()
	#var origin = (cell_size * 2 / -2) + cell_size 
	#origin += Vector2(0,3)
	var half_grid = floor(grid_size / 2)
	for y in grid_size.y:
		for x in grid_size.x:
			var cell = CellData.new()
			var position = Vector2i(
				x - half_grid.x,
				y - half_grid.y
			)
			#cell.position = origin + Vector2(
				#x * cell_size.x,
				#y * cell_size.y
			#)
			#cell.clicked.connect(_on_cell_clicked)
			#cell.hovered.connect(GameManager._on_cell_hovered)
			#cell.unhovered.connect(GameManager._on_cell_unhovered)
			#grid.add_child(cell)
			#cells[cell.coord] = cell
			cell_data[position] = cell
			cell_data[position].conent = null
			cell_data[position].coord_world = position

func show_preview(hovered_cell:Vector2i, card: CardData):
	clear_preview()
	var result = check_cells(hovered_cell,card.shape_rotated)
	for cell in result:
		tile_map_preview.set_cell(cell,2,Vector2i.ZERO)
		#cells[cell].preview(true)

func get_cell() -> Vector2i:
	var mouse_position = get_global_mouse_position()
	var cell_position = tile_map_board.to_local(mouse_position)
	cell_position = tile_map_board.local_to_map(cell_position)
	return cell_position

func is_inside_grid(cell : Vector2i)->bool:
	var result = false
	var grid_size_parameter = floor(grid_size / 2)
	if cell.x >= -grid_size_parameter.x and cell.y >= -grid_size_parameter.y:
		if cell.x <= grid_size_parameter.x and cell.y <= grid_size_parameter.y :
			result = true
	return result

func clear_preview():
	tile_map_preview.clear()
	#for cell in cells:
		#cells[cell].preview(false)

func _on_cell_clicked(coord: Vector2i):
	GameManager.on_cell_clicked(coord)

func add_enemy(coord: Vector2i, enemy: Node2D):
	var current_cell = cell_data[coord]
	
	if current_cell.conent == null:
		current_cell.conent = enemy
		enemy.global_position = tile_map_board.map_to_local(coord) 
		add_child(enemy)

func aplay_card(origin:Vector2i, card:CardData):
	var cells_aplay = check_cells(origin, card.shape_rotated)
	print_debug(cells_aplay)
	for cell in cells_aplay:
		var explotion = EXPLOTION.instantiate() as AnimatedSprite2D
		explotion.global_position = tile_map_board.map_to_local(cell)
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
