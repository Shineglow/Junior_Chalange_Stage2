extends Control

class_name Cell, "res://logic/cell.gd"

# шаблон для доступа к картинкам стрелочек
const ARROWS_PATH_TEMPLATE = "res://gfx/%s.png"
var _color_highlighted = Color(211/255.0, 1, 0, 1)
var _color_normal: Color
# переменные-ноды для быстрого доступа к компонентам
onready var cell_img = $cell_image
onready var move_arrow = $move_arrow

var checker_on_cell: Checker # шашка на клетке. null если пустая

var position setget _pos_seter
func _pos_seter(new_value: Vector2):
	if (new_value is Vector2 and (new_value.x >= 0 and new_value.y >= 0)):
		position = new_value
		self.rect_position = self.position*256

func change_move_arrow(img_name: String):
	if img_name == null:
		move_arrow.texture(null)
	move_arrow.texture(load(ARROWS_PATH_TEMPLATE % (img_name)))

# вкл/выкл подсвечивание 
func highlight():
	if cell_img.self_modulate == _color_normal:
		cell_img.self_modulate = _color_highlighted
	else:
		cell_img.self_modulate = _color_normal

# Установить цвет ячейки
func set_color(color: Color):
	_color_normal = color
	cell_img.self_modulate = _color_normal
