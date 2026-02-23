extends Control
class_name CardUi

signal card_clicked(CardUi)
@onready var cost: Label = $Cost
@onready var damage: Label = $Damage
@onready var grid_container: GridContainer = $GridContainer
var cells: Dictionary[Vector2i, TextureRect]
@onready var texture_rect: TextureRect = $TextureRect

var tween: Tween
var dragging: bool
var drag_offset: Vector2
var rotated_preview: float
var position_preview: Vector2
var card_data: CardData

func set_parameter(pos:Vector2, rotated: float):
	position_preview = pos
	rotated_preview = rotated
	pass

func _ready() -> void:
	pivot_offset = size / 2
	
	var gridsize = Vector2i(3,3)
	var childs = grid_container.get_children()
	var index = 0
	for y in gridsize.y:
		for x in gridsize.x:
			childs[index].modulate = Color.TRANSPARENT
			cells[Vector2i(x,y)] = childs[index]
			index +=1
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			card_clicked.emit(self)

func _set_data(card: CardData):
	for cell in card.shape:
		cells[cell+Vector2i(1,1)].modulate = Color.WHITE
	card_data = card
	cost.text = str(card.cost)
	damage.text = str(card.damage)

func _on_texture_rect_mouse_entered() -> void:
	animate_to(position_preview + Vector2(0, -50), 0,MouseFilter.MOUSE_FILTER_PASS,MouseFilter.MOUSE_FILTER_PASS)

func _on_texture_rect_mouse_exited() -> void:
	animate_to(position_preview, rotated_preview ,MouseFilter.MOUSE_FILTER_PASS,MouseFilter.MOUSE_FILTER_PASS)

func animate_to(target_pos: Vector2, target_rot: float, filter_mouse_init:MouseFilter, filter_mouse_finish: MouseFilter ):
	texture_rect.mouse_filter = filter_mouse_init
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", target_pos, 0.25)
	tween.tween_property(self, "rotation", target_rot, 0.25)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)
	tween.finished.connect(func(): texture_rect.mouse_filter = filter_mouse_finish)
