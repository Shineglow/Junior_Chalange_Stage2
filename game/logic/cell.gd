extends Control

const ARROWS_PATH_TEMPLATE = "res://gfx/%s.png"

onready var cell_img = $cell_image
onready var move_arrow = $move_arrow

var position setget pos_seter

func pos_seter(new_value: Vector2):
	if (new_value is Vector2 and (new_value.x >= 0 and new_value.y >= 0)):
		position = new_value
		self.rect_position = self.position*256

func _ready():
	pass

func change_move_arrow(img_name: String):
	move_arrow.texture(load(ARROWS_PATH_TEMPLATE % (img_name)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
