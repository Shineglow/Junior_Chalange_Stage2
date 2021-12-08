extends Control

var CELL_TEMPLATE = preload("res://logic/Cell.tscn")
var CHECKER_TEMPLATE = preload("res://logic/Checker.tscn")

var field = []
var size: int
var active_checker: Checker

func _ready():
	size = 8
	# генерация поля
	generate_field(8)
	self.rect_scale *= 0.25

func generate_field(field_size: int):
	if field_size >= 7:
		size = field_size
	else:
		size = 7
	# заполнение поля
	for y in size:
		field.append([])
		for x in size:
			var cell = CELL_TEMPLATE.instance()
			field[y].append(cell)	
			add_child(cell)
			cell.position = Vector2(x, y)
			
			if ((x + y) % 2 == 0):
				(cell.cell_img as TextureRect).modulate = Color.cornsilk
			else:
				(cell.cell_img as TextureRect).modulate = Color.indianred

func spawn_checkers(player_owner: field_activs, color_id: int):
	for y in size:
		for x in size:
			var a = CHECKER_TEMPLATE.instance()
			a.set_parent(self)
			a.connect("on_checker_click",self, "checker_pressed")
			

func checker_pressed(checker):
	if active_checker != checker:
		active_checker.is_selected = false
		active_checker = checker
		active_checker.is_selected = true
	elif active_checker == null:
		active_checker.is_selected = false
		active_checker = null
	else:
		active_checker = checker
		active_checker.is_selected = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
