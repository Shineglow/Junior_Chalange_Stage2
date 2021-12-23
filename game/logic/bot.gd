extends "res://logic/field_activs.gd"

# класс который сопостовляет оригинал с копией, 
# чтобы после эмуляции хода можно было совершить итоговый ход оригиналом
class checkers_comparsion:
	var originals: Array
	var copies: Array

# класс который сопоставяет шашку и набор ходов для неё
class checker_moves_struct:
	var checker: Checker
	var moves: Array
	
	func _init(checker: Checker):
		self.checker = checker

class_name Bot, "res://logic/bot.gd"
# нужно определить возможные ходы для имеющихся шашек
# критериями выбора могут быть:
#               ход должен совершаться в направлении угла соперника
#               растояние до целевой позиции, чем дальше, тем лучше
#               количество ходов для шашки
#               блокировка своих шашек
#               блокировка шашек опонента
# Нужно попробовать совершить несколько ходов за себя и опонента
var replica: replicator

var oponent_checkers

var field_copy: Array
var self_copies: checkers_comparsion
var oponent_copies: checkers_comparsion

var ch_m_array: Array

var all_posible_moves_at_turn = []

var target_cells = []

# вызывается при передаче хода. обновляет необходимую информацию
func take_turn():
	field_copy = get_field_copy()
	path_finder.set_current_cell_array(field_copy)
	update_checkers_compare_array()
	#update_target_cells()
	find_moves(self_copies.copies)
	
	_turn()

func find_moves(checkers):
	ch_m_array.clear()
	
	# для каждой шашки ищем ходы приближающие к цели
	for i in checkers.size():
		var moves_from_current_checker = path_finder.find_moves_from_checker(checkers[i].position)
		if moves_from_current_checker.size() == 0:
			continue
		
		
		for y in moves_from_current_checker:
			# определять при помощи функции целевую позицию
			var target_position = self.target_position
			if (target_position - y).length() - (target_position - checkers[i].position).length() < 0:
				moves_from_current_checker.remove(moves_from_current_checker.find(checkers[i]))
		
		if moves_from_current_checker.size() == 0:
			continue
		
		ch_m_array.append(checker_moves_struct.new(checkers[i]))
		ch_m_array[i].moves = moves_from_current_checker

func find_farest_checker(checkers):
	var result = []
	for i in checkers.size()-1:
		checkers[i]

func _turn():
	for i in oponent_checkers:
		print(i.position)
	#_sort_by_lenght()
	for i in ch_m_array:
		(i as checker_moves_struct).moves

func _pass_turn():
	pass

func move_analize():
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

func get_moves_for_checker(checker: Checker):
	return path_finder.find_moves_from_checker(checker.position)

# рассчёт текущего хода
func calculate_move():
	path_finder.set_current_cell_array(field_copy)

func checker_click(checker: Checker):
	return false

#
# field - двумерный массив ячеек (Cell), которые могут содержать или не содержать шашки (Checkers)
# field содержит копии данных, графика не копируется. Для рассчётов нужны только условные параметры.
#
func get_field_copy():
	var copy = []
	for y in field.field.size():
		copy.append([])
		for x in field.field.size():
			var cell_copy = replica.create_cell_copy(field.field[y][x])
			copy[y].append(cell_copy)
	return copy

func update_checkers_compare_array():
	self_copies.originals.clear()
	self_copies.copies.clear()
	for i in checkers:
		self_copies.originals.append(i)
		self_copies.copies.append(field_copy[i.position.y][i.position.x].checker_on_cell)
	
	oponent_copies.originals.clear()
	oponent_copies.copies.clear()
	for i in oponent_checkers:
		oponent_copies.originals.append(i)
		oponent_copies.copies.append(field_copy[i.position.y][i.position.x].checker_on_cell)


func _init():
	replica = replicator.new()
	self_copies = checkers_comparsion.new()
	self_copies.originals = []
	self_copies.copies = []
	oponent_copies = checkers_comparsion.new()
	oponent_copies.originals = []
	oponent_copies.copies = []

func update_target_cells():
	var corner_size = sqrt(checkers.size())
	target_cells.clear()
	for y in corner_size:
		for x in corner_size:
			if !field.field[y][x].is_checker_contain:
				target_cells.append(Vector2(x,y))
