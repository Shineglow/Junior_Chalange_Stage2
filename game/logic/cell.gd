extends Control

class_name Cell, "res://logic/cell.gd"

var graph: Cell_graphics setget _set_with_connect
func _set_with_connect(value):
	graph = value
	graph.connect("on_cell_click",self, "cell_click")

var move_arrow: String setget _set_arrow_name
func _set_arrow_name(value):
	move_arrow = value
	if graph:
		graph.change_move_arrow(move_arrow)

var previews_cell_pos: Vector2
var path_lenght: int
var is_jump_arround_checking: bool

var checker_on_cell: Checker
var is_checker_contain: bool

var position setget _pos_seter
func _pos_seter(new_value: Vector2):
	if (new_value is Vector2 and (new_value.x >= 0 and new_value.y >= 0)):
		position = new_value
	if graph:
		graph.rect_position = self.position * graph.rect_min_size

var is_highlight: bool setget _highlight
func _highlight(value):
	is_highlight = value
	if graph:
		graph.highlight(value)

signal on_cell_click(cell)

func cell_click():
	emit_signal("on_cell_click", self)

func _ready():
	path_lenght = 0

func reset():
	checker_on_cell = null
	is_checker_contain = false
	self.is_highlight = false
	path_clear()

func path_clear():
	previews_cell_pos = Vector2.ZERO
	path_lenght = 0
	is_jump_arround_checking = false


