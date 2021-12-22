extends "res://logic/field_activs.gd"

class_name Player, "res://logic/player.gd"

signal highlight_cells(cells_positions)

func human_end_turn():
	_pass_turn()

func checker_click(checker: Checker):
	print("asdfasdfasdf")
	return checker_recognition(checker)
