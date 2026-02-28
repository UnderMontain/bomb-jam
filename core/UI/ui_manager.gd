extends Control
class_name UIManager


@onready var hand_ui: Control = $HandUI
var current_card: CardUi
const CARD_UI = preload("uid://b556hhae3hfcb")
var cards : Array[CardUi]

@onready var position_card: Control = $PositionCard
@onready var life: Label = $Life
@onready var cost: Label = $Cost
@onready var wave: Label = $Wave
@onready var game_over_label: Label = $GameOver
@onready var update_card: Label = $UpdateCard
var tween: Tween

func update_life(life_value:int):
	self.life.text = "Life" + str(life_value)

func update_cost(cost_value:int, max_cost:int):
	cost_value = clamp(cost_value,0,max_cost)
	self.cost.text = "Cost" + str(cost_value) + "/" + str(max_cost)
	pass

func update_wave(_wave:int):
	self.wave.text = "Wave " + str(_wave)
	pass

func game_over():
	game_over_label.visible = true

func selected_card(card_ui: CardUi):
	# Si hay una seleccionada, devolverla
	if current_card and current_card != card_ui:
		cards.append(current_card)
		current_card.reparent(hand_ui,true)
		update_layout()

	current_card = card_ui
	cards.erase(card_ui)
	card_ui.reparent(position_card)
	update_layout()

	# Animar carta seleccionada
	card_ui.animate_to(
		Vector2(0,0),
		0.0,
		MouseFilter.MOUSE_FILTER_IGNORE,
		MouseFilter.MOUSE_FILTER_IGNORE
	)

func discard_card(card:CardInstance):
	if card == current_card.card_instance:
		current_card.queue_free()

func add_card(card_ui: CardUi):
	hand_ui.add_child(card_ui)
	
	# empieza fuera de pantalla
	card_ui.global_position = Vector2(700, 200)

	cards.append(card_ui)
	update_layout()

func update_layout():
	var count := cards.size()
	if count == 0:
		return

	var spacing := 40.0
	var max_angle := deg_to_rad(5)

	var mid := (count - 1) / 2.0

	for i in range(count):
		var card : CardUi= cards[i]
		var idx := i - mid
		
		var t := 0.0 if mid == 0 else idx / mid
		var angle := t * max_angle

		var rotated = angle
		var target_position = Vector2(
			idx * spacing,
			abs(idx) * 6.0
		)
		card.set_parameter(target_position,rotated)
		card.animate_to(target_position,rotated,MouseFilter.MOUSE_FILTER_IGNORE,MouseFilter.MOUSE_FILTER_PASS)
