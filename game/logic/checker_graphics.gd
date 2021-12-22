extends Control

class_name checker_graphics

onready var textures = [preload("res://gfx/checker_black.png"), preload("res://gfx/checker_white.png")]

onready var btn = $btn
onready var checker_texture = $checker_texture
onready var selected = $selected

signal on_checker_click(checker)

func set_graph_parameters(position, tex_id, min_size):
	selected.visible = false
	checker_texture.texture = textures[tex_id]
	self.rect_min_size = min_size
	self.rect_size = min_size
	self.rect_position = position * min_size

func _ready():
	btn.connect("gui_input", self, "btn_gui_input")

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("on_checker_click")
