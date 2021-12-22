extends Object

class_name Path_finder, "res://logic/move_checker.gd"

var _field
var _field_size

var current_cell_pos: Vector2

# я пришёл к решению хранить сопостовимые данны в двух массивах, 
# для простоты итерации и чтобы избежать большого количества тернарных блоков
const _arround = [Vector2(-1, -1),Vector2(0, -1), Vector2(1, -1), Vector2(-1, 0),Vector2(1, 0),Vector2(-1, 1),Vector2(0, 1),Vector2(1, 1)]
const _arrow_name = ["move_upleft","move_up","move_upright","move_left","move_right","move_downleft","move_down","move_downright","move_jump"]

func _init(field: Field):
	_field = field
	_field_size = field.size

func find_moves_from_checker(checker_pos: Vector2):
	current_cell_pos = checker_pos
	var jump_cells = _try_jump(checker_pos, 0)
	var move_cells = _get_empty_cells_arround(checker_pos)
	jump_cells.append_array(move_cells)
	return jump_cells

func _get_empty_cells_arround(current: Vector2):
	var result_array = []
	
	for i in 8:
		var cell_pos = current + _arround[i]
		if _is_coordinates_is_valid(cell_pos):
			var current_cell = (_field.field[cell_pos.y][cell_pos.x] as Cell)
			if !current_cell.is_checker_contain:
				current_cell.change_move_arrow(_arrow_name[i])
				current_cell.path_lenght = 1
				current_cell.previews_cell_pos = current
				result_array.append(cell_pos)
	
	return result_array

func _try_jump(current: Vector2, last_path):
	var jump_cells = []
	_field.field[current.y][current.x].is_jump_arround_checking = true
	
	for i in 8:
		var cell_pos = current + _arround[i]
		
		if _is_coordinates_is_valid(cell_pos):
			var current_cell = (_field.field[cell_pos.y][cell_pos.x] as Cell)
			if current_cell.is_checker_contain:
				var next_pos = cell_pos + _arround[i]
				if next_pos == current_cell_pos:
					continue
				
				if _is_coordinates_is_valid(next_pos):
					var next_cell = (_field.field[next_pos.y][next_pos.x] as Cell)
					if !next_cell.is_checker_contain:
						if next_cell.path_lenght == 0 or next_cell.path_lenght > last_path + 1:
							next_cell.previews_cell_pos = current
							next_cell.path_lenght = last_path + 1
						
						if !next_cell.is_jump_arround_checking:
							next_cell.change_move_arrow(_arrow_name[8])
							jump_cells.append(next_pos)
							jump_cells.append_array(_try_jump(next_pos, last_path+1))
	
	return jump_cells

func _is_coordinates_is_valid(cell_pos: Vector2):
	var condition_a = cell_pos.x >= 0 and cell_pos.x < _field_size
	var condition_b = cell_pos.y >= 0 and cell_pos.y < _field_size
	return condition_a and condition_b
