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

signal player_activate_checker(checker)

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
	
	_player1 = _player_instance.new()
	_player2 = _player_instance.new()
	
	_player1.start = Vector2(0, 0)
	_player2.start = Vector2(field_size-checkers_size, field_size-checkers_size)
	
	_player1.checkers = field.spawn_checkers(_player1, 0)
	_player2.checkers = field.spawn_checkers(_player2, 1)
	
	_current_player = _player1
