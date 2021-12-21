extends Node

onready var field = $Alternative_Interface/desk
onready var _interface_manager = $Alternative_Interface
onready var _player_instance = preload("res://logic/player.gd")
onready var _bot_instance = preload("res://logic/bot.gd")

onready var _move_checker = load("res://logic/move_checker.gd")

var _player1#black
var _player2#white
var current_player: field_activs
var oponent: field_activs

var field_size = 7
var corner_size = 3

var path_finder: Path_finder

func _ready():
	start_new_game(field_size, corner_size)

func end_turn():
	if field.is_already_move:
		if !check_game_end():
			var temp = current_player
			current_player = oponent
			oponent = temp
			
			field.end_turn()
			_interface_manager.end_turn()
			path_finder.clear_old()
		else:
			if current_player == _player2:
				_interface_manager.end_game(true)
			elif current_player == _player1:
				_interface_manager.end_game(false)

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
	_interface_manager.set_winscreen_visibility(false)

func start_new_game(new_field_size, new_corner_size):
	field.init_field(field_size, new_corner_size)
	
	field.connect("on_checker_click",self,"checker_click_result")
	_interface_manager.connect("on_end_turn_click", self, "end_turn")
	_interface_manager.connect("on_restart_click", self, "restart")
	_interface_manager.connect("on_exit_click", self, "game_quit")
	
	
	
	_player2 = init_bot(Vector2(0,0), 1)
	oponent = _player2
	
	var corner_pos = field_size - corner_size 
	_player1 = init_player("White", Vector2(corner_pos, corner_pos), 0)
	current_player = _player1
	
	
	_player1.path_finder = Path_finder.new(field)
	_player2.path_finder = Path_finder.new(field)

func init_player(name, corner_start_pos, checkers_color):
	var player = _player_instance.new()
	player.name = name
	player.start = corner_start_pos
	player.checkers = field.spawn_checkers(corner_start_pos, checkers_color)
	player.path_finder = Path_finder.new(field)
	return player

func init_bot(corner_start_pos,checkers_color):
	var bot = _bot_instance.new()
	bot.name = "Bot"
	bot.start = corner_start_pos
	bot.checkers = field.spawn_checkers(corner_start_pos, checkers_color)
	bot.path_finder = Path_finder.new(field)
	return bot

func checker_click_result(checker):
	if current_player.checker_recognition(checker):
		if field.active_checker != checker:
			field.dehighlight_field()
			current_player.show_moves(checker)
		else:
			field.dehighlight_field()

func get_moves(checker):
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
			var cell = (field.field[current_end_pos.y][current_end_pos.x] as Cell)
			if cell.is_checker_contain:
				if cell.checker_on_cell.player_owner != current_player:
					return false
			else:
				return false
	return true

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE:
			for i in 9:
				var pos1 = current_player.checkers[i].position
				var pos2 = oponent.checkers[i].position
				field.castling(pos1, pos2)

func game_quit():
	get_tree().quit()
