extends Object

class_name Path_finder, "res://logic/move_checker.gd"


var _field
var _field_size

var _jump_cells = []
var _move_cells = []
var cell

# я пришёл к решению хранить сопостовимые данны в двух массивах, 
# для простоты итерации и чтобы избежать большого количества тернарных блоков
var _arround = [Vector2(-1, -1),Vector2(0, -1), Vector2(1, -1), Vector2(-1, 0),Vector2(1, 0),Vector2(-1, 1),Vector2(0, 1),Vector2(1, 1)]
var _arrow_name = ["move_upleft","move_up","move_upright","move_left","move_right","move_downleft","move_down","move_downright","move_jump"]

func set_new(field: Field):
	_field = field
	_field_size = field.field.size()

func clear_old():
	for i in _field.field:
		for y in i:
			(y as Cell).highlight(false)

func find_moves_from_checker(checker_pos: Vector2):
	clear_old()
	
	if cell == checker_pos:
		cell = null
		return
	cell = checker_pos
	var _jump_cells = _try_jump(checker_pos, [])
	var _move_cells = _get_empty_cells_arround(checker_pos)
	
	for i in _jump_cells:
		(_field.field[i.y][i.x] as Cell).highlight(true)
	for i in _move_cells:
		(_field.field[i.y][i.x] as Cell).highlight(true)

func _get_empty_cells_arround(current: Vector2):
	var result_array = []
	
	for i in 8:
		var cell_pos = current + _arround[i]
		var condition_a = cell_pos.x >= 0 and cell_pos.x < _field_size
		var condition_b = cell_pos.y >= 0 and cell_pos.y < _field_size
		if condition_a and condition_b:
			var current_cell = (_field.field[cell_pos.y][cell_pos.x] as Cell)
			if !current_cell.is_checker_contain:
				current_cell.change_move_arrow(_arrow_name[i])
				result_array.append(cell_pos)
	
	return result_array

func _try_jump(current: Vector2, last_path):	
	for i in 8:
		# координаты ячейки рядом с центральной по радиусу 1
		var cell_pos = current + _arround[i]
		var condition_a = cell_pos.x >= 0 and cell_pos.x < _field_size
		var condition_b = cell_pos.y >= 0 and cell_pos.y < _field_size
		# если координаты в рамках поля
		if condition_a and condition_b:
			# переменная проверяемой ячейки
			var current_cell = (_field.field[cell_pos.y][cell_pos.x] as Cell)
			if current_cell.is_checker_contain:
				var next_pos = current + _arround[i]*2
				condition_a = next_pos.x >= 0 and next_pos.x < _field_size
				condition_b = next_pos.y >= 0 and next_pos.y < _field_size
				# если координаты клетки для прыжка в рамках поля
				if condition_a and condition_b:
					
					var next_cell = (_field.field[next_pos.y][next_pos.x] as Cell)
					if !next_cell.is_checker_contain:
						# если маршрут больше нуля
						if last_path.size() > 0:
							if last_path.find(next_pos) == -1:
								next_cell.change_move_arrow(_arrow_name[8])
								last_path.append(next_pos)
								
								# если маршрут к следующей ячейке уже есть
								var path_size = next_cell.path.size()
								if path_size > 0:
									# и если этот маршрут длиннее текущего
									if path_size > last_path.size():
										# заменяем путь к клетке на текущий
										next_cell.path = last_path
								else:
									next_cell.path = last_path
								
								for y in _try_jump(next_pos, last_path):
									if last_path.find(y) == -1:
										last_path.append(y)
						else:
							last_path.append(next_pos)
							next_cell.change_move_arrow(_arrow_name[8])
								
							var path_size = next_cell.path.size()
							if path_size > 0:
								if path_size > last_path.size():
									next_cell.path = last_path
							else:
								next_cell.path = last_path
							
							for y in _try_jump(next_pos, last_path):
								if last_path.find(y) == -1:
									last_path.append(y)
	
	return last_path



