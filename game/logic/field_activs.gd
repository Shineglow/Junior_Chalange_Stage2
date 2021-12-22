extends Control

class_name field_activs, "res://logic/field_activs.gd"

var path_finder: Path_finder

var start: Vector2 # позиция на поле из которой будут генерироваться шашки
var checkers = []

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
