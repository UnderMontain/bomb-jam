extends Node

enum GameState{
	IDLE,
	AIMING,
	RESOLVING_CARD,
	ENEMIES_REACTING,
	DRAWING_CARD
}
var state: GameState

var action_queue: Array[Action] = []
var global_modifires: Array[Modifier] = []

var current_main : Main
var current_board : Board
var deck: Deck
var hand: Hand
var player: Player
var round_cost = 0
var cost_max = 5
var init_cost_max = 5
const ENEMY = preload("uid://bn4yfwn686x1i")
const MAIN = preload("uid://crfdvfd3ero57")
const DECK_DEFAULT = preload("uid://do4mp2duh8ga5")



var has_hovered_cell: bool
var last_coord_cell: Vector2i

var wave: int = 0
var enemy_hp_base = 1

signal wave_changed (wave:int)
signal cost_changed (current_cost:int, cost_max: int)

func _ready() -> void:
	state = GameState.IDLE

func _start():
	var cards: Array[CardData] = DECK_DEFAULT.cards as Array[CardData]
	deck.create_deck(cards)
	next_wave()
	for i in 2:
		var card:CardInstance = deck.draw()
		hand._pick_card(card)
		i += 1
	_Play()

func _Play():
	state = GameState.DRAWING_CARD
	var card:CardInstance = deck.draw()
	hand._pick_card(card)
	state = GameState.AIMING

func _use_card(source,target:Array[CellData], card:CardInstance):
	card.Play(source,target,self)
	process_enqueue()

#region Actions and Reactions
func enqueue_action(action: Action) -> void:
	action_queue.append(action)

func process_enqueue():
	while action_queue.size() > 0:
		var action = action_queue.pop_front()
		for mod in get_all_modifiers():
			mod.modify_action(action)
		
		action.execute(self)

func emit_event(event_type:StringName, data:Dictionary):
	for mod in get_all_modifiers():
		var reation:Action = mod.on_event(event_type,data)
		
		if reation != null:
			enqueue_action(reation)

func get_all_modifiers() -> Array[Modifier]:
	var all_mods: Array = [Modifier]
	for mod in global_modifires:
		all_mods.append(mod)
	return all_mods
#endregion


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
		state = GameState.RESOLVING_CARD
		current_board.clear_preview()
		var card_used = hand.get_selected_card()
		var matching_cells = current_board.check_cells(coord,card_used.card_data.shape)
		var cells = current_board.get_cell_data(matching_cells)
		_use_card(player,cells,card_used)
		deck.discard(card_used)
		hand.use_card()
		round_cost += card_used.card_data.cost
		cost_changed.emit(round_cost,cost_max)
		await current_board.apply_card(coord,card_used)
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

	var lifeenemy: int = enemy_hp_base + int(wave/15.0)
	var cells_empty = current_board.get_cell_empty()
	cells_empty.shuffle()
	var enemies_to_spawn: int = 1 + floori(wave / 5.0)
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
	cost_max = init_cost_max
	
	await create_tween().tween_interval(1.3).finished
	SceneManager.change_to("res://core/main_menu.tscn")
