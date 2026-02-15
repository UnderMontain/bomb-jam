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
var rotated:float
var position_preview 
var card_data: CardData

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
			#if tween:
				#tween.kill()
			#tween = create_tween()
			#tween.set_parallel(true) # que todo ocurra al mismo tiempo
			#var pera = get_node("../../PositionCard").global_position
			#tween.tween_property(self, "rotation", 0.0, 0.1)
			#tween.tween_property(self, "scale", Vector2(1,1), 0.1)
			#tween.tween_property(self, "global_position",pera , 0.1)
			#func add_card(card: CardData):
			
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#dragging = true
			#drag_offset = global_position - event.global_position
			#modulate = Color(1.0, 1.0, 1.0, 0)
		#else:
			#dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.global_position + drag_offset

func _set_data(card: CardData):
	for cell in card.shape:
		cells[cell+Vector2i(1,1)].modulate = Color.WHITE
	card_data = card
	cost.text = str(card.cost)
	damage.text = str(card.damage)

func _on_texture_rect_mouse_entered() -> void:
	if tween:
		tween.kill()
	rotated = rotation
	position_preview = position
	z_index = 100
	#rotation = 0
	#scale = Vector2(1.2,1.2)
	#position += Vector2(0,-50)
	
	tween = create_tween()
	tween.set_parallel(true) # que todo ocurra al mismo tiempo
	
	tween.tween_property(self, "rotation", 0.0, 0.1)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.1)
	


func _on_texture_rect_mouse_exited() -> void:
	#rotation = rotated
	z_index = 0
	#scale = Vector2(1,1)
	#position = position_preview
	
	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "rotation", rotated, 0.2)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(self, "position", position_preview, 0.2)


	
func animate_to(target_pos: Vector2, target_rot: float, filter_mouse:MouseFilter ):
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", target_pos, 0.25)
	tween.tween_property(self, "rotation", target_rot, 0.25)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)
	tween.finished.connect(func(): texture_rect.mouse_filter = filter_mouse)
