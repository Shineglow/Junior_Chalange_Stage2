extends Node

enum {CELL_SIZE,MAP_SIZE}
var _parameters = [128,7]

onready var field = $Alternative_Interface/desk
onready var _interface_manager = $Alternative_Interface
onready var _player_instance = preload("res://logic/player.gd")

onready var _move_checker = load("res://logic/move_checker.gd")

var _player1#black
var _player2#white
var current_player: field_activs
var oponent: field_activs

var field_size = 7
var checkers_size = 3

var path_finder: Path_finder

func _ready():
	start_new_game()

func end_turn():
	if field.is_already_move:
		if !check_game_end():
			var temp = current_player
			current_player = oponent
			oponent = temp
			
			path_finder.clear_old()
			field.end_turn()
			_interface_manager.end_turn()

func check_end_game_process():
	var size = field.field.size()
	for y in 3:
		for x in 3:
			var pos1 = Vector2(x,y)
			var pos2 = Vector2(size-1,size-1) - pos1
			field.castling(pos1, pos2)

func restart():
	path_finder.clear_old()
	
	field.reset()
	field.reset_checkers_of_player(current_player)
	field.reset_checkers_of_player(oponent)
	
	_interface_manager.reset()
	
	current_player = _player2
	oponent = _player1

func start_new_game():
	field.init_field(field_size)
	path_finder = Path_finder.new()
	
	field.connect("on_checker_click",self,"checker_click_result")
	_interface_manager.connect("on_end_turn_click", self, "end_turn")
	_interface_manager.connect("on_restart_click", self, "restart")
	
	_player1 = _player_instance.new()
	_player2 = _player_instance.new()
	
	_player1.name = "Black"
	_player2.name = "White"
	
	_player1.start = Vector2(0, 0)
	_player2.start = Vector2(field_size-checkers_size, field_size-checkers_size)
	
	_player1.checkers = field.spawn_checkers(_player1, 0)
	_player2.checkers = field.spawn_checkers(_player2, 1)
	
	current_player = _player2
	oponent = _player1

func checker_click_result(checker):
	if current_player == checker.player_owner:
		if !field.is_already_move:
			field.select_checker_logic(checker)
			path_finder.set_new(field)
			path_finder.find_moves_from_checker(checker.position)

func check_game_end():
	var cells_to_win = current_player.checkers.size()
	var end_start = oponent.start
	
	for y in 3:
		for x in 3:
			var current_end_pos = end_start + Vector2(x,y)
			#print(current_end_pos)
			var cell = (field.field[current_end_pos.y][current_end_pos.x] as Cell)
			if cell.is_checker_contain:
				if cell.checker_on_cell.player_owner != current_player:
					return false
			else:
				return false
	return true

func get_parameter(parameter):
	if parameter >= 0 and parameter < _parameters.size():
		return _parameters[parameter]
