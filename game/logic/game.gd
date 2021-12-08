extends Node

onready var field = $Field
onready var player_instance = preload("res://logic/player.gd")

var player1
var player2
var current_player
var turn: int



func _ready():
	player1 = player_instance.new()
	player2 = player_instance.new()
	pass


func end_turn(player):
	if player == player1:
		current_player = player2
	pass

func restart():
	pass

func start_new_game():
	pass
