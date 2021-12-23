extends Object

class_name replicator

func create_cell_copy(cell):
	var copy = Cell.new()
	copy.position = cell.position
	copy.is_highlight = cell.is_highlight
	copy.previews_cell_pos = cell.previews_cell_pos
	copy.path_lenght = cell.path_lenght
	copy.is_jump_arround_checking = cell.is_jump_arround_checking
	if cell.is_checker_contain:
		copy.checker_on_cell = create_checker_copy(cell.checker_on_cell)
	else:
		copy.checker_on_cell = null
	copy.is_checker_contain = cell.is_checker_contain
	return copy

func create_checker_copy(checker):
	var copy = Checker.new(checker.position)
	return copy
