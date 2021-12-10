extends Node

onready var field = $Field
onready var _player_instance = preload("res://logic/player.gd")

onready var _move_checker = load("res://logic/move_checker.gd")

var _player1
var _player2
var _current_player
var _turn: int

var field_size = 7
var checkers_size = 3

var path_finder: Path_finder

func _ready():
	start_new_game()

func end_turn(player):
	if player == _player1:
		_current_player = _player2
	else:
		_current_player = _player1

func restart():
	pass

func start_new_game():
	field.init_field(field_size)
	field.connect("on_checker_click",self,"checker_click_result")
	
	_player1 = _player_instance.new()
	_player2 = _player_instance.new()
	
	_player1.start = Vector2(0, 0)
	_player2.start = Vector2(field_size-checkers_size, field_size-checkers_size)
	
	_player1.checkers = field.spawn_checkers(_player1, 0)
	_player2.checkers = field.spawn_checkers(_player2, 1)
	
	_current_player = _player1
	
	path_finder = Path_finder.new()

func checker_click_result(checker):
	if _current_player == checker.player_owner:
		print("on checker click")
		path_finder.set_new(field)
		path_finder.find_moves_arround_checker(checker.position)
		pass
