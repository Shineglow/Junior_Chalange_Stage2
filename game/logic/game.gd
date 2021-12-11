extends Node

onready var field = $Field
onready var _interface_manager = $Interface
onready var _player_instance = preload("res://logic/player.gd")

onready var _move_checker = load("res://logic/move_checker.gd")

var _player1#black
var _player2#white
var current_player: field_activs
var oponent: field_activs
var _turn: int

var field_size = 7
var checkers_size = 3

var path_finder: Path_finder

func _ready():
	start_new_game()

func end_turn():
	if !check_game_end():
		var temp = current_player
		current_player = oponent
		oponent = temp
		path_finder.clear_old()
		_interface_manager.get_turn()
		return
	else:
		pass

func check_end_game_process():
	var size = field.field.size()
	for y in 3:
		for x in 3:
			var pos1 = Vector2(x,y)
			var pos2 = Vector2(size-1,size-1) - pos1
			field.castling(pos1, pos2)

func restart():
	pass

func start_new_game():
	field.init_field(field_size)
	path_finder = Path_finder.new()
	field.connect("on_checker_click",self,"checker_click_result")
	field.connect("try_move",self, "end_turn")
	_player1 = _player_instance.new()
	_player2 = _player_instance.new()
	
	_player1.start = Vector2(0, 0)
	_player2.start = Vector2(field_size-checkers_size, field_size-checkers_size)
	
	_player1.checkers = field.spawn_checkers(_player1, 0)
	_player2.checkers = field.spawn_checkers(_player2, 1)
	
	current_player = _player2
	oponent = _player1

func checker_click_result(checker):
	if current_player == checker.player_owner:
		field.select_checker_logic(checker)
		path_finder.set_new(field)
		path_finder.find_moves_from_checker(checker.position)
		pass

func check_game_end():
	var cells_to_win = current_player.checkers.size()
	var end_start = oponent.start
	
	for y in 3:
		for x in 3:
			var current_end_pos = end_start + Vector2(x,y)
			print(current_end_pos)
			var cell = (field.field[current_end_pos.y][current_end_pos.x] as Cell)
			if cell.is_checker_contain:
				if cell.checker_on_cell.player_owner != current_player:
					return false
			else:
				return false
	return true

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		check_end_game_process()
		if check_game_end():
			if current_player == _player2:
				_interface_manager.end_game(false)
			else:
				_interface_manager.end_game(true)
