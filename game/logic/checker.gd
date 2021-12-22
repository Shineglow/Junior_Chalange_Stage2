extends Object

class_name Checker, "res://logic/checker.gd"

var _checker_graph = preload("res://Interface/Checker.tscn")

var _graph: checker_graphics

var position: Vector2 setget _pos_set
func _pos_set(new_value: Vector2):
	position = new_value
	if _graph:
		_graph.rect_position = position * _graph.rect_min_size

var is_selected setget _select
func _select(value: bool):
	is_selected = value
	if _graph:
		_graph.selected.visible = value

signal clicked(checker)

func _init(position):
	self.position = position
	self.is_selected = false

func init_graphics(graph):
	_graph = graph
	_graph.connect("on_checker_click", self, "on_checker_click")
	self.position = position
	self.is_selected = false

func on_checker_click():
	emit_signal("clicked", self)
