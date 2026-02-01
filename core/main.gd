extends Node2D
class_name Main

@onready var board: Board = $Board
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@onready var card: Card = $Card
@onready var label: Label = $Control/Label
@onready var cost_label: Label = $Control/Cost
@onready var cost_3: Label = $Control/Cost3
@onready var cost_4: Label = $Control/Cost4


func _ready() -> void:
	GameManager.current_main = self
	GameManager.deck = deck
	GameManager.hand = hand
	GameManager.card = card
	GameManager.current_board = board
	#GameManager._add_enemy()
	GameManager._start()

func update_life(life:int):
	label.text = "Life" + str(life)

func update_cost(cost:int, max_cost:int):
	cost = clamp(cost,0,max_cost)
	cost_label.text = "Cost" + str(cost) + "/" + str(max_cost)

func update_wave(wave:int):
	cost_3.text = "Wave " + str(wave)

func game_over():
	$Control/Cost2.visible = true

func card_update(is_posiblie:bool):
	if is_posiblie:
		cost_4.text = "Card random updated"
	else: cost_4.text = "All card are full update"
	cost_4.visible = true
	await create_tween().tween_interval(2).finished
	cost_4.visible = false
