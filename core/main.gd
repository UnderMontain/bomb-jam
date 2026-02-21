extends Node2D
class_name Main

@onready var board: Board = $Board
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var player:Player

#@onready var card: Card = $Card

@export var GUI: UIManager
@onready var hand_ui: Control = $CanvasLayer/GUI/HandUI
var cards : Array[CardUi]
@export var radius := 180.0
@export var max_angle := 25.0 # grados
@export var y_offset := 20.0
const CARD_UI = preload("uid://b556hhae3hfcb")

func _ready() -> void:
	GameManager.current_main = self
	GameManager.deck = deck
	GameManager.hand = hand
	GameManager.current_board = board
	board.hovered.connect(GameManager._on_cell_hovered)
	board.cell_clicked.connect(GameManager._on_cell_clicked)
	#GameManager.card = card
	#GameManager._add_enemy()
	hand.card_drawed.connect(add_card)
	GameManager.wave_changed.connect(GUI.update_wave)
	GameManager.cost_changed.connect(GUI.update_cost)
	player.player_life_changed.connect(GUI.update_life)
	GameManager._start()
	
func scene_load():
	pass

func card_update(is_posiblie:bool):
	#if is_posiblie:
		#cost_4.text = "Card random updated"
	#else: cost_4.text = "All card are full update"
	#cost_4.visible = true
	#await create_tween().tween_interval(2).finished
	#cost_4.visible = false
	pass

#UI
func add_card(card: CardData):
	var cardUI = CARD_UI.instantiate() as CardUi
	cardUI.card_clicked.connect(hand.set_card_seleted)
	cardUI.card_clicked.connect(GUI.selected_card)
	GUI.add_card(cardUI)
	cardUI._set_data(card)

#func update_layout():
	#var count := cards.size()
	#if count == 0:
		#return
#
	#var spacing := 40.0
	#var max_angle := deg_to_rad(5)
#
	#var mid := (count - 1) / 2.0
#
	#for i in range(count):
		#var card := cards[i] as Control
		#var idx := i - mid
#
		#var t := 0.0 if mid == 0 else idx / mid
		#var angle := t * max_angle
#
		#card.rotation = angle
		#card.position = Vector2i(
			#idx * spacing,
			#abs(idx) * 6.0
		#)
