extends Control

class_name Cell_graphics, "res://logic/cell_graphics.gd"

# шаблон для доступа к картинкам стрелочек
const ARROWS_PATH_TEMPLATE = "res://gfx/%s.png"
var _color_highlighted = Color(211/255.0, 1.0, 0.0, 1.0)
var _color_normal: Color
# переменные-ноды для быстрого доступа к компонентам
onready var _cell_img = $cell_image
onready var _move_arrow = $move_arrow
onready var btn = $btn

signal on_cell_click()

func _ready():
	btn.connect("gui_input",self,"btn_gui_input")

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("on_cell_click")

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
		_move_arrow.texture = null
	
	_move_arrow.visible = value

# Установить цвет ячейки
func set_color(color: Color):
	_color_normal = color
	_cell_img.modulate = _color_normal
