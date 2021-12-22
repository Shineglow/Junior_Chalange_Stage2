extends Control

onready var _black_selected = $Curent_player/Black/Selected
onready var _white_selected = $Curent_player/White/Selected
onready var _turn_counter = $turn_info/VBoxContainer/turn_counter

onready var _win_screen = $win_screen
onready var _win_screen_background = $win_screen/ColorRect
onready var _end_game_lable = $win_screen/end_game_message
onready var _exit_btn = $win_screen/VBoxContainer/btn_exit
onready var _restart_winscreen_btn = $win_screen/VBoxContainer/btn_restart

onready var _end_turn_btn = $control_buttons/VBoxContainer/btn_end_turn
onready var _restart_btn = $control_buttons/VBoxContainer/btn_restart
onready var _exit_winscreen_btn = $win_screen/VBoxContainer/btn_exit

onready var _black_theme = preload("res://Interface/Theme/Black/win_screen_black_theme.tres")
onready var _white_theme = preload("res://Interface/Theme/White/win_screen_white_theme.tres")

var _white_color = Color("e7e7e7")
var _black_color = Color("232323")

var _turn = 1

signal end_game_block()
signal on_end_turn_click()
signal on_restart_click()
signal on_exit_click()

func _ready():
	_end_turn_btn.connect("button_down",self,"end_turn_click")
	_restart_btn.connect("button_down",self,"restart_click")
	
	_restart_winscreen_btn.connect("button_down",self,"restart_click")
	_exit_winscreen_btn.connect("button_down",self,"exit_click")

func exit_click():
	emit_signal("on_exit_click")

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
	
	if winner:
		_win_screen.modulate = _white_color
		
		_end_game_lable.theme = _white_theme
		_end_game_lable.text = "Белые выиграли!"
		
		_restart_winscreen_btn.theme = _white_theme
		_exit_winscreen_btn.theme = _white_theme
	else:
		_win_screen.modulate = _black_color
		
		_end_game_lable.theme = _black_theme
		_end_game_lable.text = "Чёрные выиграли!"
		
		_restart_winscreen_btn.theme = _black_theme
		_exit_winscreen_btn.theme = _black_theme
	
	set_winscreen_visibility(true)

func set_winscreen_visibility(value: bool):
	_win_screen.visible = value
