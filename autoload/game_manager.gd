extends Node

var current_board : Board
var deck: Deck
var hand: Hand

const ENEMY = preload("uid://bn4yfwn686x1i")


func _ready() -> void:
	pass

func _Play():
	hand._pick_card(deck)

func _add_enemy():
	var enemy = ENEMY.instantiate()
	current_board.add_enemy(Vector2i(2,2),enemy)
	
func on_cell_clicked (coord: Vector2i):
	print_debug(coord)
	current_board.aplay_card(coord,hand.current_card)
