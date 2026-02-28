extends Node
class_name Hand

var current_card: CardInstance
var current_hand: Array[CardInstance]

signal card_drawed(card:CardInstance)
signal card_use(card:CardInstance)


func get_selected_card()-> CardInstance:
	return current_card

func _pick_card(card: CardInstance):
	card.card_data.shape_rotated = card.card_data.shape
	current_hand.append(card)
	card_drawed.emit(card)
	
func set_card_seleted(card_ui :CardUi):
	current_card = card_ui.card_instance
	current_card.card_data.shape_rotated = current_card.card_data.shape

func use_card():
	card_use.emit(current_card)

func shape_rotated():
	for i in current_card.card_data.shape_rotated.size():
		var p = current_card.card_data.shape_rotated[i]
		current_card.card_data.shape_rotated[i] = Vector2i (-p.y,p.x)
