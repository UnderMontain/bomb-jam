extends Node2D


@onready var board: Board = $Board
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand

func _ready() -> void:
	GameManager.deck = deck
	GameManager.hand = hand
	GameManager.current_board = board
	GameManager._add_enemy()
	GameManager._Play()
