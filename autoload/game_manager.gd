extends Node

enum GameState{
	IDLE,
	AIMING,
	RESOLVING_CARD,
	ENEMIES_REACTING,
	DRAWING_CARD
}
var state: GameState

var current_main : Main
var current_board : Board
var deck: Deck
var hand: Hand
var card: Card
var player: Player
var round_cost = 0
var cost_max = 5
var init_cost_max = 5
const ENEMY = preload("uid://bn4yfwn686x1i")
const MAIN = preload("uid://crfdvfd3ero57")
@onready var cost_2: Label = $Control/Cost2

var has_hovered_cell: bool
var last_coord_cell: Vector2i

var wave: int = 0
var enemy_hp_base = 1

signal wave_changed (wave:int)
signal cost_changed (current_cost:int, cost_max: int)

func _ready() -> void:
	state = GameState.IDLE

func _start():
	deck.reset()
	next_wave()
	_Play()

func _Play():
	state = GameState.DRAWING_CARD
	hand._pick_card(deck)
	hand._pick_card(deck)
	hand._pick_card(deck)
	#card.show_preview(hand.current_card)
	state = GameState.AIMING

func _add_enemy():
	var enemy = ENEMY.instantiate()
	current_board.add_enemy(Vector2i(2,2),enemy)
	var other = ENEMY.instantiate()
	current_board.add_enemy(Vector2i(2,1),other)


func _input(event: InputEvent) -> void:
	if state == GameState.AIMING:
		if event is InputEventKey and event.is_pressed() and not event.is_echo():
			if event.keycode == Key.KEY_R:
				if has_hovered_cell:
					hand.shape_rotated()
					current_board.show_preview(last_coord_cell, hand.current_card)

func _on_cell_hovered(coord: Vector2i):
	
	has_hovered_cell = true
	last_coord_cell = coord
	current_board.show_preview(coord,hand.current_card)

func _on_cell_unhovered(coord: Vector2i):
	if has_hovered_cell:
		has_hovered_cell = false
		last_coord_cell = coord
		current_board.clear_preview()

func _on_cell_clicked (coord: Vector2i):
	if state == GameState.AIMING:
		print_debug(coord)
		state = GameState.RESOLVING_CARD
		current_board.clear_preview()
		round_cost += hand.current_card.cost
		cost_changed.emit(round_cost,cost_max)
		await current_board.aplay_card(coord,hand.current_card)
		if round_cost >= cost_max:
			var enemies = current_board.get_enemies()
			for enemie in enemies:
				enemie.attack(player)
			if player.life <= 0 :
				game_over()
				return
			round_cost = 0
			cost_changed.emit(round_cost,cost_max)
			
			
			next_wave()
		else:
			var enemis = current_board.get_enemies()
			if enemis.is_empty() :
				next_wave()
				round_cost = 0
		_Play()

func next_wave():
	wave += 1
	wave_changed.emit(wave)

	if wave % 5 == 0 : 
		cost_max += 1
	cost_changed.emit(round_cost,cost_max)
	
	#Updatecard
	var is_update = deck.find_card_to_upgrade()
	current_main.card_update(is_update)

	var lifeenemy = enemy_hp_base + int(wave/15)
	var cells_empty = current_board.get_cell_empty()
	cells_empty.shuffle()
	var enemies_to_spawn := int(1 + wave / 5)
	for i in enemies_to_spawn:
		if cells_empty.is_empty(): return
		var random_cell = cells_empty.pop_front()
		var enemy = ENEMY.instantiate() as Enemy
		current_board.add_enemy(random_cell,enemy)
		enemy.init_life(lifeenemy)

func game_over():
	current_main.game_over()
	wave = 0
	round_cost = 0
	deck.reset()
	cost_max = init_cost_max
	#next_wave()
	#_Play()
	
	await create_tween().tween_interval(1.3).finished
	SceneManager.change_to("res://core/main_menu.tscn")
	#get_tree().change_scene_to_file("res://core/main.tscn")
	
	#_Play()
