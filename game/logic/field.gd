extends Control

class_name Field, "res://logic/field.gd"

var CELL_TEMPLATE = preload("res://logic/Cell.tscn")
var CHECKER_TEMPLATE = preload("res://logic/Checker.tscn")

var field = []
var size: int

var all_checkers = []
var active_checker: Checker

signal on_checker_click(checker)
signal try_move()

func init_field(new_field_size):
	# генерация поля
	generate_field(new_field_size)
	self.rect_scale *= 0.25

func generate_field(field_size: int):
	if field_size >= 7:
		size = field_size
	else:
		size = 7
	# заполнение поля
	for y in size:
		field.append([])
		for x in size:
			var cell = CELL_TEMPLATE.instance()
			field[y].append(cell)	
			add_child(cell)
			cell.connect("on_cell_click",self,"cell_click_react")
			cell.position = Vector2(x, y)
			cell.checker_on_cell = null
			cell.is_checker_contain = false
			if ((x + y) % 2 == 0):
				cell.set_color(Color.cornsilk)
			else:
				cell.set_color(Color.indianred)

func cell_click_react(cell: Cell):
	if cell.is_highlight:
		var pos = active_checker.position
		(field[pos.y][pos.x] as Cell).is_checker_contain = false
		active_checker.move_checker(cell.position)
		cell.checker_on_cell = active_checker
		cell.is_checker_contain = true
		
		emit_signal("try_move")

func spawn_checkers(player_owner: field_activs, texture_id: int):
	var checkers = []
	for y in 3:
		for x in 3:
			var a = CHECKER_TEMPLATE.instance()
			checkers.append(a)
			add_child(a)
			a.position = player_owner.start + Vector2(x, y)
			(field[a.position.y][a.position.x] as Cell).checker_on_cell = a
			(field[a.position.y][a.position.x] as Cell).is_checker_contain = true
			(a.checker_texture as TextureRect).texture = a.textures[texture_id]
			a.connect("on_checker_click",self, "checker_pressed")
			a.player_owner = player_owner
	
	all_checkers += checkers
	return checkers

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
			return
	else:
		active_checker = checker
		active_checker.is_selected = true

func cell_move_active():
	pass
	
func cell_jump_active():
	pass

func castling(checker_pos_1: Vector2, checker_pos_2: Vector2):
	var cell1 = (field[checker_pos_1.y][checker_pos_1.x] as Cell)
	var cell2 = (field[checker_pos_2.y][checker_pos_2.x] as Cell)
	
	var temp = cell1.checker_on_cell
	cell1.checker_on_cell.move_checker(checker_pos_2)
	cell1.checker_on_cell = cell2.checker_on_cell
	
	cell2.checker_on_cell.move_checker(checker_pos_1)
	cell2.checker_on_cell = temp
