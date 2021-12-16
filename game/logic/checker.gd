extends Control

class_name Checker, "res://logic/checker.gd"

onready var textures = [preload("res://gfx/checker_black.png"), preload("res://gfx/checker_white.png")]

onready var btn = $btn
onready var _checker_texture = $checker_texture
onready var _selected = $selected

var position setget _pos_set
func _pos_set(new_value: Vector2):
	position = new_value
	set_object_pos(new_value)

var is_selected setget _select
func _select(value: bool):
	is_selected = value
	_selected.visible = value

var player_owner
signal on_checker_click(checker)

func _ready():
	#btn.connect("gui_input", self, "btn_gui_input")
	btn.connect("gui_input", self, "btn_gui_input")

func btn_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# обрабатываем нажатия
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("on_checker_click", self)

func move_checker(pos: Vector2):
	self.position = pos
	
func set_object_pos(target: Vector2):
	print(target)
	self.rect_position = self.position*rect_min_size
	pass

func checker_init(tex_id, position, min_size, player_owner):
	_selected.visible = false
	_checker_texture.texture = textures[tex_id]
	rect_min_size = min_size
	rect_size = min_size
	self.position = position
	self.player_owner = player_owner
