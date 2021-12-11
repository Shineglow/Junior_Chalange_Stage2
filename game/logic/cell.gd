extends Control

class_name Cell, "res://logic/cell.gd"

# шаблон для доступа к картинкам стрелочек
const ARROWS_PATH_TEMPLATE = "res://gfx/%s.png"
var _color_highlighted = Color(211/255.0, 1.0, 0.0, 1.0)
var _color_normal: Color
# переменные-ноды для быстрого доступа к компонентам
onready var cell_img = $cell_image
onready var _move_arrow = $move_arrow
onready var _btn = $btn

var is_highlight setget ,_highlight_get
func _highlight_get():
	return is_highlight

onready var path = []

var checker_on_cell # шашка на клетке. null если пустая
var is_checker_contain: bool

var position setget _pos_seter
func _pos_seter(new_value: Vector2):
	if (new_value is Vector2 and (new_value.x >= 0 and new_value.y >= 0)):
		position = new_value
		self.rect_position = self.position*256

signal on_cell_click(cell)

func _ready():
	is_highlight = false
	_btn.connect("gui_input", self, "btn_gui_input")

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
		cell_img.modulate = _color_highlighted
	else:
		cell_img.modulate = _color_normal
		(_move_arrow as TextureRect).texture = null
	
	is_highlight = value
	(_move_arrow as TextureRect).visible = value

# Установить цвет ячейки
func set_color(color: Color):
	_color_normal = color
	cell_img.modulate = _color_normal

