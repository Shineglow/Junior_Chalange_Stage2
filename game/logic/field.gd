extends Control

class_name Field, "res://logic/field.gd"

var CELL_TEMPLATE = preload("res://logic/Cell.tscn")
var CHECKER_TEMPLATE = preload("res://logic/Checker.tscn")

var field = []
var size: int

var all_checkers = []
var active_checker: Checker

signal on_checker_click(checker)

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
			cell.position = Vector2(x, y)
			cell.checker_on_cell = null
			cell.is_checker_contain = false
			if ((x + y) % 2 == 0):
				(cell.cell_img as TextureRect).modulate = Color.cornsilk
			else:
				(cell.cell_img as TextureRect).modulate = Color.indianred

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
	emit_signal("on_checker_click",checker)
