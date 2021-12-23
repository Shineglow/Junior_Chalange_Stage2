extends Object

class_name Checker, "res://logic/checker.gd"

var graph: checker_graphics setget _set_with_position
func _set_with_position(value):
	graph = value
	self.position = self.position
	graph.connect("on_checker_click", self, "on_checker_click")

var position: Vector2 setget _pos_set
func _pos_set(new_value: Vector2):
	position = new_value
	if graph:
		graph.rect_position = position * graph.rect_min_size

var is_selected setget _select
func _select(value: bool):
	is_selected = value
	if graph:
		graph.selected.visible = value

signal clicked(checker)

func _init(position):
	self.position = position
	self.is_selected = false

func on_checker_click():
	emit_signal("clicked", self)

func set_position_safe(value):
	position = value
