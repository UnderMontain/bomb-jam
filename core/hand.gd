extends Node
class_name Hand

var current_card: CardData

signal card_drawed(card:CardData)

func _pick_card(deck: Deck):
	current_card = deck.draw()
	current_card.shape_rotated = current_card.shape
	card_drawed.emit(current_card)
	
func set_card_seleted(card_ui :CardUi):
	current_card = card_ui.card_data
	current_card.shape_rotated = current_card.shape

func shape_rotated():
	for i in current_card.shape_rotated.size():
		var p = current_card.shape_rotated[i]
		current_card.shape_rotated[i] = Vector2i (-p.y,p.x)
