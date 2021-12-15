extends Control

onready var _black_selected = $Curent_player/Black/Selected
onready var _white_selected = $Curent_player/White/Selected
onready var _turn_counter = $turn_info/VBoxContainer/turn_counter

onready var _win_screen = $win_screen
onready var _win_screen_background = $win_screen/ColorRect
onready var _end_game_lable = $win_screen/end_game_message
onready var _exit_btn = $win_screen/VBoxContainer/btn_exit

onready var _end_turn_btn = $control_buttons/VBoxContainer/btn_end_turn
onready var _restart_btn = $control_buttons/VBoxContainer/btn_restart

var _white_color = Color("c5c5c5")
var _black_color = Color("232323")

var _turn = 1

var _defaul_color = Color(1.0, 0.65, 0.05, 1.0)
var _select_color = Color(1.0, 1.0, 0.0, 1.0)

signal end_game_block()
signal on_end_turn_click()
signal on_restart_click()

func _ready():
	_end_turn_btn.connect("button_down",self,"end_turn_click")
	_restart_btn.connect("button_down",self,"restart_click")

func restart_click():
	emit_signal("on_restart_click")

func end_turn_click():
	emit_signal("on_end_turn_click")
	
func end_turn():
	_change_active_player()
	_add_turn()
	pass

func _change_active_player():
	_black_selected.visible = !_black_selected.visible
	_white_selected.visible = !_white_selected.visible
	
func _add_turn():
	_turn += 1
	_turn_counter.text = "Ход: "+String(_turn)
	pass

func reset():
	_turn = 1
	_turn_counter.text = "Ход: "+String(_turn)
	pass

func end_game(winner):
	emit_signal("end_game_block")
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
	
	_win_screen.visible = true
	pass
