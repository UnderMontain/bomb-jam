extends Node
class_name Deck

@export var cards: Array[CardData] = []

var draw_pile: Array[CardData] = []
var discard_pile: Array[CardData] = []

func reset() -> void:
	draw_pile.clear()
	discard_pile.clear()
	for i in 10:
		var card = cards[0].duplicate(true)
		draw_pile.append(card)
	draw_pile.shuffle()

func shuffle():
	draw_pile = discard_pile.duplicate()
	discard_pile.clear()
	draw_pile.shuffle()

func draw() -> CardData:
	if draw_pile.is_empty(): shuffle()
	var card = draw_pile.pop_front() 
	discard_pile.append(card)
	return card

func find_card_to_upgrade()-> bool:
	var all_cards := []
	all_cards = draw_pile + discard_pile
	all_cards.shuffle()
	for card in all_cards:
		if upgrade_card(card):
			return true
	return false
	


func upgrade_card(card:CardData) -> bool:
	
	var upgrades:= []
	
	if card.cost > 0:
		upgrades.append("cost")
	if card.damage < 5:
		upgrades.append("damage")
	if card.shape.size() < 9:
		upgrades.append("cell")
	
	if upgrades.is_empty():
		return false
	
	upgrades.shuffle()
	apply_upgrade(card,upgrades[0])
	return true

func apply_upgrade(card:CardData, type:String):
	match type:
		"cost":
			card.cost -= 1
		"damage":
			card.damage += 1
		"cell":
			add_random_cell(card)
	pass


func add_random_cell(card:CardData):
	var posible:= []
	for x in range(-1,2):
		for y in range(-1,2):
			var pos= Vector2i(x,y)
			if pos != Vector2i.ZERO and not card.shape.has(pos):
				posible.append(pos)
	if posible.is_empty():
		return
	posible.shuffle()
	card.shape.append(posible[0])
	pass
