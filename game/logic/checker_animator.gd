extends Node

class_name checker_animator, "res://logic/checker_animator.gd"

class checker_data:
	var checker: Checker
	var target: Vector2

var play_time = 1.0
var _timer: Timer
var _curent_data


func _init():
	_curent_data = checker_data.new()
	_timer = Timer.new()
	_timer.one_shot = true
	

func _process(delta):
	if _timer.time_left > 0:
		_curent_data.checker.set_object_pos(_curent_data.checker.rect_position + _curent_data.target * (play_time - _timer.time_left))

func animation_start(checker: Checker, target: Vector2, play_time = 1.0):
	self.play_time = play_time
	
	_curent_data = checker_data.new()
	_curent_data.checker = checker
	_curent_data.target = target
	
	_timer.wait_time = self.play_time
	_timer.connect("timeout", self, "_timer_end")
	_timer.start()

func _timer_end():
	_curent_data.checker.position = _curent_data.target
	_curent_data = null

func animation_brake():
	_timer.stop()
	_curent_data.checker.position = _curent_data.target
	_curent_data = null
