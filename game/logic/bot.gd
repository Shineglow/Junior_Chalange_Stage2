extends "res://logic/field_activs.gd"

class_name Bot, "res://logic/bot.gd"
# нужно определить возможные ходы для имеющихся шашек
# критериями выбора могут быть:
#               ход должен совершаться в направлении угла соперника
#               растояние до целевой позиции, чем дальше, тем лучше
#               количество ходов для шашки
#               блокировка своих шашек
#               блокировка шашек опонента
# Нужно попробовать совершить несколько ходов за себя и опонента
class checker_moves_struct:
	var checker: Checker
	var moves: Array
	
	func _init(checker: Checker):
		self.checker = checker

var ch_m_array: Array

var all_posible_moves_at_turn = []

var target_cells = []

func update_target_cells():
	var corner_size = sqrt(checkers.size())
	target_cells.clear()
	for y in corner_size:
		for x in corner_size:
			if !field_interface.is_cell_contain_checker(x,y):
				target_cells.append(Vector2(x,y))

# вызывается при передаче хода. содержит основную логику
func take_turn():
	update_target_cells()
	ch_m_array.clear()
	
	for i in checkers.size():
		ch_m_array.append(checker_moves_struct.new(checkers[i]))
		var moves_from_current_checker = path_finder.find_moves_from_checker(checkers[i].position)
		for y in moves_from_current_checker:
			if (target_position - y).length() - (target_position - checkers[i].position).length():
				moves_from_current_checker.remove(moves_from_current_checker.find(checkers[i]))
		ch_m_array[i].moves = moves_from_current_checker
		
	_turn()

func _turn():
	#_sort_by_lenght()
	for i in ch_m_array:
		(i as checker_moves_struct).moves

func _pass_turn():
	pass

func move_analize():
	var moves = []
	for y in checkers:
		var curent_moves = get_checker_moves(y)
		moves.append(curent_moves)
		for i in curent_moves:
			
			pass

func _sort_moves_by_lenght(array):
		array.sort_custom(self, "distance_comparsion")

func distance_comparsion(a: Vector2, b: Vector2):
	return (target_position-a).length() < (target_position-b).length()

# сравнивает длинну возможных ходов
func _compare_moves_lenght():
	pass

# сравнивает растояние до целевых клеток
func _compare_target_cells():
	pass

func _cut_negative_lenght_moves():
	pass

# эмитирует ход соперника
func _predict_player():
	pass

# рассчёт текущего хода
func calculate_move():
	pass

func checker_click(checker: Checker):
	return false
