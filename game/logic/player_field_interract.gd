extends Object

class_name Field_interact

var _field: Field

func _init(field):
	_field = field

func get_field():
	return _field.field

func get_checkers():
	return _field.checkers

func is_oponent_corner_have_empty_cells(pos, mul):
	var result = []
	for y in _field.corner_size:
		for x in _field.corner_size:
			var a = _field.field[pos.y+y][pos.x+x]
			if !a.is_checker_contain:
				result.append(a)
	return result

func is_cell_contain_checker(x,y):
	return _field.field[y][x].is_checker_contain


