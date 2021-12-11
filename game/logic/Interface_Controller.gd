extends Control

onready var _black = $Panel
onready var _white = $Panel3
onready var _turn_counter = $Panel2/lable

onready var _win_screen = $Win_screen
onready var _end_game_lable = $Win_screen/End_game_message
onready var _restart_btn = $Win_screen/Restart_btn
onready var _restart_btn_text = $Win_screen/Restart_btn/btn_text

var _white_color = Color.white
var _black_color = Color(0.7, 0.7, 0.7, 1)

var _turn = 1

var _defaul_color = Color(1.0, 0.65, 0.05, 1.0)
var _select_color = Color(1.0, 1.0, 0.0, 1.0)

func _ready():
	_white.modulate = _select_color
	reset()

func get_turn():
	_change_active_player()
	_add_turn()

func _change_active_player():
	var temp = _white.modulate
	_white.modulate = _black.modulate
	_black.modulate = temp
	
func _add_turn():
	_turn += 1
	_turn_counter.text = "Turn: "+String(_turn)
	pass

func reset():
	_turn = 1
	_turn_counter.text = "Turn: "+String(_turn)
	pass

func end_game(winner):
	var winner_col
	var oposit_col
	if winner:
		winner_col = _white_color
		oposit_col = _black_color
	else:
		winner_col = _black_color
		oposit_col = _white_color
	
	_win_screen.modulate = winner_col
	_end_game_lable.modulate = oposit_col
	_restart_btn.modulate = oposit_col
	_restart_btn_text.modulate = winner_col
	
	_win_screen.visible = true
	pass
