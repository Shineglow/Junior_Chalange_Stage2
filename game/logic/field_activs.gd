extends Control

class_name field_activs, "res://logic/field_activs.gd"

var field_interface: Field_interact
var path_finder: Path_finder

var start_position: Vector2
var start_multiplier: int

var target_position: Vector2
var target_multiplier: int

var checkers = []
var is_playing_white: bool

signal end_turn()

func get_checker_moves(checker: Checker):
	return path_finder.find_moves_from_checker(checker.position)

func take_turn():
	pass

func _turn():
	pass

func _pass_turn():
	emit_signal("end_turn")
	pass

func checker_recognition(checker: Checker):
	return checkers.find(checker) != -1

func checker_click(checker):
	pass
