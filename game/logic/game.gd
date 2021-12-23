extends Node

onready var field = $Alternative_Interface/desk
onready var _interface_manager = $Alternative_Interface
onready var _player_instance = preload("res://logic/player.gd")
onready var _bot_instance = preload("res://logic/bot.gd")

onready var _move_checker = load("res://logic/move_checker.gd")

var _player1
var _player2
var current_player: field_activs
var oponent: field_activs

var field_size = 7
var corner_size = 3

func _ready():
	start_new_game(field_size, corner_size)

func end_turn():
	if field.is_already_move:
		field.end_turn()
		_interface_manager.end_turn()
		print(current_player.name)
		if check_game_end():
			_interface_manager.end_game(current_player.is_playing_white)
		
		pass_turn()

func restart():
	field.reset()
	field.reset_checkers_of_player(current_player)
	field.reset_checkers_of_player(oponent)
	
	_interface_manager.reset()
	
	if _player1.is_playing_white:
		current_player = _player1
		oponent = _player2
	else:
		current_player = _player2
		oponent = _player1
	_interface_manager.set_winscreen_visibility(false)

func start_new_game(new_field_size, new_corner_size):
	field.init_field(field_size, new_corner_size)
	
	field.connect("on_checker_click",self,"checker_click_result")
	_interface_manager.connect("on_restart_click", self, "restart")
	_interface_manager.connect("on_exit_click", self, "game_quit")
	
	var corner_top = Vector2(0,0)
	var corner_pos = field_size - corner_size
	var corner_down = Vector2(field_size-1, field_size-1)
	
	_player1 = init_player("White", corner_top, corner_down, true)
	_interface_manager.connect("on_end_turn_click", _player1, "human_end_turn")
	_player1.connect("end_turn", self, "end_turn")
	
	_player2 = init_bot(corner_down, corner_top, false)
	_player2.connect("end_turn", self, "end_turn")
	
	current_player = _player2
	oponent = _player1
	print("start game")
	pass_turn()

func pass_turn():
	var temp = current_player
	current_player = oponent
	oponent = temp
	
	current_player.take_turn()

# возможно стоит переименовать
func checker_click_result(checker: Checker):
	if current_player.checker_click(checker):
		select_checker(checker)

func select_checker(checker: Checker):
	if field.active_checker != null:
		if field.active_checker != checker:
			field.dehighlight_field()
			_select_checker_highlight_moves(checker)
		else:
			field.select_checker_logic(checker)
			field.dehighlight_field()
	else:
		_select_checker_highlight_moves(checker)

func _select_checker_highlight_moves(checker: Checker):
	field.select_checker_logic(checker)
	for i in current_player.get_checker_moves(checker):
		field.field[i.y][i.x].is_highlight = true

func check_game_end():
	var cells_to_win = current_player.checkers.size()
	var end_start = current_player.target_position
	var multiplier = current_player.target_multiplier
	
	for y in 3:
		for x in 3:
			var current_end_pos = end_start + Vector2(x,y) * multiplier
			var cell = (field.field[current_end_pos.y][current_end_pos.x] as Cell)
			if cell.is_checker_contain:
				if !current_player.checker_recognition(cell.checker_on_cell):
					return false
			else:
				return false
	return true

#
# Инициализация классов игроков
#
func _init_base(base: field_activs, name, corner_start_pos, oponent_corner, is_playing_white):
	base.name = name
	base.is_playing_white = is_playing_white
	var multiplier
	if corner_start_pos.length() - oponent_corner.length() > 0: 
		multiplier = -1 
	else: 
		multiplier = 1
	
	base.start_position = corner_start_pos
	base.start_multiplier = multiplier
	base.target_position = oponent_corner
	base.target_multiplier = multiplier*-1
	
	if is_playing_white:
		base.checkers = field.spawn_checkers(corner_start_pos, multiplier, 1)
	else:
		base.checkers = field.spawn_checkers(corner_start_pos, multiplier, 0)
	
	base.path_finder = Path_finder.new(field.field)
	base.field = field

func init_player(name, corner_start_pos, oponent_corner, is_playing_white):
	var player = _player_instance.new()
	_init_base(player, name, corner_start_pos, oponent_corner, is_playing_white)
	return player

func init_bot(corner_start_pos, oponent_corner,is_playing_white):
	var bot = _bot_instance.new()
	_init_base(bot, "bot", corner_start_pos, oponent_corner, is_playing_white)
	var oponent_checkers = []
	for i in field.checkers:
		if !bot.checker_recognition(i):
			oponent_checkers.append(i)
	bot.oponent_checkers = oponent_checkers
	return bot



func game_quit():
	get_tree().quit()

func check_end_game_process():
	var size = field.field.size()
	for y in 3:
		for x in 3:
			var pos1 = Vector2(x,y)
			var pos2 = Vector2(size-1,size-1) - pos1
			field.castling(pos1, pos2)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE:
			for i in 9:
				var pos1 = current_player.checkers[i].position
				var pos2 = oponent.checkers[i].position
				field.castling(pos1, pos2)
		if event.scancode == KEY_Q:
			for i in current_player.oponent_checkers:
				print(i.position)
