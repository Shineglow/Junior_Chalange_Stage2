extends Node

onready var field = $Field
onready var player_instance = preload("res://logic/player.gd")

var player1
var player2
var current_player
var turn: int

var field_size = 8
var checkers_size = 3

func _ready():
	field.init_field(field_size)
	
	player1 = player_instance.new()
	player2 = player_instance.new()
	
	player1.start = Vector2(0, 0)
	player2.start = Vector2(field_size-checkers_size-1, field_size-checkers_size-1)
	
	field.spawn_checkers(player1, 0)
	field.spawn_checkers(player2, 1)
	
	pass


func end_turn(player):
	if player == player1:
		current_player = player2
	pass

func restart():
	pass

func start_new_game():
	pass
