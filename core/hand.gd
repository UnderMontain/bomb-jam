extends Node
class_name Hand

var current_card: CardData

func _pick_card(deck: Deck):
	current_card = deck.draw()
	
