extends Control

class custom_animator:
	var _target_cell: Cell
	var _moving_checker: Checker
	var _tween: Tween
	var _path = []
	
	func _init(cell: Cell, checker: Checker, tween: Tween, path):
		_target_cell = cell
		_moving_checker = checker
		_tween = tween
		_path = path
	
	func animate_move_checker():
		_path.invert()
		for i in _path:
			var end = i*_target_cell.rect_min_size
			var start = _moving_checker.rect_position
			var time = _get_lenght(start-end)*0.005
			_tween.interpolate_property(_moving_checker, "rect_position", null, end, 0.5, Tween.TRANS_QUAD)
			_tween.start()
			yield(_tween, "tween_completed")
		_moving_checker.position = _target_cell.position
	
	func _get_lenght(vec: Vector2):
		return sqrt(vec.x*vec.x + vec.y*vec.y)


class_name Field, "res://logic/field.gd"

var CELL_TEMPLATE = preload("res://Interface/Cell.tscn")
var CHECKER_TEMPLATE = preload("res://Interface/Checker.tscn")

onready var _field_vision = $field
onready var _checkers_vision = $checkers

var field = []
var size: int

var checkers = []
var active_checker: Checker
var is_already_move: bool
onready var ghost_checker = $ghost_checker
var gc_position

onready var _tween = $Tween

signal on_checker_click(checker)
signal try_move()

func init_field(new_field_size):
	is_already_move = false
	
	generate_field(new_field_size)
	
	ghost_checker.modulate = Color(1,1,1, 0.5)
	ghost_checker.visible = false
	ghost_checker.rect_min_size = field[0][0].rect_min_size

func cell_click_react(cell: Cell):
	if cell.is_highlight:
		ghost_checker.texture = active_checker.get_node("checker_texture").texture
		ghost_checker.rect_position = cell.rect_position
		ghost_checker.visible = true
		gc_position = cell.position
		is_already_move = true
	elif cell.checker_on_cell == active_checker:
		is_already_move = false
		ghost_checker.visible = false

func checker_pressed(checker):
	emit_signal("on_checker_click",checker)
	
func select_checker_logic(checker):
	if active_checker != null:
		if active_checker != checker:
			active_checker.is_selected = false
			active_checker = checker
			active_checker.is_selected = true
		else:
			active_checker = null
			checker.is_selected = false
	else:
		active_checker = checker
		active_checker.is_selected = true

func end_turn():
	var pos = active_checker.position
	(field[pos.y][pos.x] as Cell).is_checker_contain = false
	var cell = field[gc_position.y][gc_position.x] as Cell
	
	cell.checker_on_cell = active_checker
	cell.is_checker_contain = true
	
	var animator = custom_animator.new(cell, active_checker, _tween, _get_path(cell.position))
	animator.animate_move_checker()
	
	is_already_move = false
	active_checker.is_selected = false
	active_checker = null

func _get_path(current_pos: Vector2):
		var sub_path = []
		var _target_cell = (field[current_pos.y][current_pos.x] as Cell)
		sub_path.append(_target_cell.position)
	
		if _target_cell.path_lenght == 0:
			return sub_path
		
		for i in _get_path(_target_cell.previews_cell_pos):
			sub_path.append(i)
		
		return sub_path

func generate_field(field_size: int):
	if field_size >= 7:
		size = field_size
	else:
		size = 7
	var unit_size = 900/field_size
	# заполнение поля
	for y in size:
		field.append([])
		for x in size:
			var cell = CELL_TEMPLATE.instance()
			field[y].append(cell)	
			_field_vision.add_child(cell)
			cell.connect("on_cell_click",self,"cell_click_react")
			cell.rect_min_size = Vector2(unit_size, unit_size)
			cell.rect_size = Vector2(unit_size, unit_size)
			cell.position = Vector2(x, y)
			cell.checker_on_cell = null
			cell.is_checker_contain = false
			if ((x + y) % 2 == 0):
				cell.set_color(Color.cornsilk)
			else:
				cell.set_color(Color.indianred)

func spawn_checkers(player_owner: field_activs, texture_id: int):
	var checkers = []
	for y in 3:
		for x in 3:
			var a = CHECKER_TEMPLATE.instance()
			checkers.append(a)
			_checkers_vision.add_child(a)
			a.checker_init(texture_id, player_owner.start+Vector2(x,y), (field[0][0] as Cell).rect_min_size, player_owner)
			(field[a.position.y][a.position.x] as Cell).checker_on_cell = a
			(field[a.position.y][a.position.x] as Cell).is_checker_contain = true
			a.connect("on_checker_click",self, "checker_pressed")
	
	self.checkers += checkers
	return checkers

func castling(checker_pos_1: Vector2, checker_pos_2: Vector2):
	var cell1 = (field[checker_pos_1.y][checker_pos_1.x] as Cell)
	var cell2 = (field[checker_pos_2.y][checker_pos_2.x] as Cell)
	
	var temp = cell1.checker_on_cell
	cell1.checker_on_cell.move_checker(checker_pos_2)
	cell1.checker_on_cell = cell2.checker_on_cell
	
	cell2.checker_on_cell.move_checker(checker_pos_1)
	cell2.checker_on_cell = temp

func reset():
	if active_checker != null:
		active_checker.is_selected = false
		active_checker = null
	is_already_move = false
	ghost_checker.visible = false
	for y in field:
		for x in y:
			(x as Cell).reset()

func reset_checkers_of_player(player: field_activs):
	var i = 0
	for y in 3:
		for x in 3:
			var che = player.checkers[i]
			var pos = Vector2(x,y) + player.start
			player.checkers[i].position = pos
			field[pos.y][pos.x].checker_on_cell = che
			field[pos.y][pos.x].is_checker_contain = true
			i+=1
