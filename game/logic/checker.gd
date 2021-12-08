extends Control

class_name Checker, "res://logic/checker.gd"

onready var textures = [preload("res://gfx/checker_black.png"), preload("res://gfx/checker_white.png")]

onready var btn = $btn
onready var checker_texture = $checker_texture
onready var selected = $selected

var position setget pos_set
func pos_set(new_value: Vector2):
	if (new_value.x >= 0 and new_value.y >= 0):
		position = new_value
		self.rect_position = self.position*256

var is_selected setget select
func select(value: bool):
	is_selected = value
	selected.visible = value

var player_owner
signal on_checker_click(checker)

func _ready():
	btn.connect("gui_input", self, "btn_gui_input")

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("on_checker_click", self)
				print("on checker click")
