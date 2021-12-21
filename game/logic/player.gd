extends "res://logic/field_activs.gd"

class_name Player, "res://logic/player.gd"

signal highlight_cells(cells_positions)

func checker_recognition(checker: Checker):
	return checkers.find(checker) != -1
		

func show_moves(checker):
	var moves = check_checker_moves(checker)
	emit_signal("highlight_cell")
