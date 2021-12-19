extends Control

class_name Cell, "res://logic/cell.gd"

# шаблон для доступа к картинкам стрелочек
const ARROWS_PATH_TEMPLATE = "res://gfx/%s.png"
var _color_highlighted = Color(211/255.0, 1.0, 0.0, 1.0)
var _color_normal: Color
# переменные-ноды для быстрого доступа к компонентам
onready var _cell_img = $cell_image
onready var _move_arrow = $move_arrow
onready var btn = $btn

var is_highlight

var previews_cell_pos: Vector2
var path_lenght: int
var is_jump_arround_checking: bool

var checker_on_cell: Checker
var is_checker_contain: bool

var position setget _pos_seter
func _pos_seter(new_value: Vector2):
	if (new_value is Vector2 and (new_value.x >= 0 and new_value.y >= 0)):
		position = new_value
		self.rect_position = self.position*rect_min_size

signal on_cell_click(cell)

func _ready():
	btn.connect("gui_input",self,"btn_gui_input")
	path_lenght = 0

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("on_cell_click", self)

func change_move_arrow(img_name):
	if !img_name is String:
		_move_arrow.texture(null)
		return
	(_move_arrow as TextureRect).texture = load(ARROWS_PATH_TEMPLATE % (img_name))

# вкл/выкл подсвечивание 
func highlight(value: bool):
	if value:
		_cell_img.modulate = _color_highlighted
	else:
		_cell_img.modulate = _color_normal
		(_move_arrow as TextureRect).texture = null
	
	is_highlight = value
	(_move_arrow as TextureRect).visible = value

# Установить цвет ячейки
func set_color(color: Color):
	_color_normal = color
	_cell_img.modulate = _color_normal

func reset():
	checker_on_cell = null
	is_checker_contain = false
	highlight(false)
	path_clear()

func path_clear():
	previews_cell_pos = Vector2.ZERO
	path_lenght = 0
	is_jump_arround_checking = false
