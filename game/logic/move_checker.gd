extends Object

var _field
var _field_size

var _cells_to_move_jump = []

# я пришёл к решению хранить сопостовимые данны в двух массивах, 
# для простоты итерации и чтобы избежать большого количества тернарных блоков
var _around = [Vector2(-1, -1),Vector2(0, -1), Vector2(1, -1), Vector2(-1, 0),Vector2(1, 0),Vector2(-1, 1),Vector2(0, 1),Vector2(1, 1)]
var _arrow_name = ["move_upleft","move_up","move_upright","move_left","move_right","move_downleft","move_down","move_downright","jump"]

func _init(field: Field):
	_field = field.field
	_field_size = sqrt(field.field.len())

func find_moves_arround_checker(checker_pos: Vector2):
	for i in _cells_to_move_jump:
		(i as Cell).highlight()
	pass

func _try_move(checker_pos: Vector2):
	for i in 8:
		var checking_pos = _around[i] + checker_pos
		# Если координаты в рамках поля
		var condition_a = (checker_pos.x >= 0 and checker_pos.x<_field_size)
		var condition_b = (checker_pos.y >= 0 and checker_pos.y<_field_size)
		if condition_a and condition_b:
			var current_cell = (_field[checker_pos.y][checker_pos.x] as Cell)
			# если отсутствует шашка на клетке
			if current_cell.checker_on_cell == null:
				# устанавливает соответствующую стрелочку на клетку
				current_cell.change_move_arrow(_arrow_name[i])
				_cells_to_move_jump.append(current_cell)
			else:
				# пробует перепрыгнуть
				_try_jump(checking_pos + _around[i])
	
	

func _try_jump(checker_pos: Vector2):
	var checking_pos = checker_pos
	# если индексы не выходят за пределы поля
	var condition_a = (checking_pos.x >= 0 and checking_pos.x<_field_size)
	var condition_b = (checking_pos.y >= 0 and checking_pos.y<_field_size)
	if condition_a and condition_b:
		var current_cell = (_field[checking_pos.y][checking_pos.x] as Cell)
		# если клетка пустая
		if current_cell.checker_on_cell == null:
			# и отсутствует в списке доступных для хода клеток
			if _cells_to_move_jump.find(current_cell) == -1:
				current_cell.change_move_arrow("move_jump")
				_cells_to_move_jump.append(current_cell)

# добавить функции try_move и try_jump
#
