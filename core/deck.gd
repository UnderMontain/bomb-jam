extends Node
class_name Deck


var draw_pile: Array[CardInstance] = []
var discard_pile: Array[CardInstance] = []


func create_deck(cards: Array[CardData]):
	draw_pile.clear()
	discard_pile.clear()
	for card in cards:
		var new_card = CardInstance.new(card)
		draw_pile.append(new_card)

##TODO Corregir retorno de draw si no hay mas cartas ni en la pila ni en el descarte
func draw() -> CardInstance:
	if draw_pile.is_empty(): shuffle()
	var card = draw_pile.pop_front() 
	return card

func shuffle():
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
	draw_pile.shuffle()

func discard(card: CardInstance):
	discard_pile.append(card)

func find_card_to_upgrade()-> bool:
	var all_cards: Array[CardInstance]
	all_cards = draw_pile + discard_pile
	all_cards.shuffle()
	for card in all_cards:
		if upgrade_card(card):
			return true
	return false
	

##TODO Corregir Update Card Instance
func upgrade_card(card_instance:CardInstance) -> bool:
	var card = card_instance.card_data
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
