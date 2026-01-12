extends Node
class_name Deck

@export var cards: Array[CardData] = []

var draw_pile: Array[CardData] = []

func reset():
	draw_pile = cards.duplicate()
	draw_pile.shuffle()

func draw() -> CardData:
	if draw_pile.is_empty(): reset()
	return draw_pile.pop_front() 
