extends PathFollow3D

@export var _speed : float
@export var _pauseTimeAtWaypoints : float
@export var _jumpToStart : bool

var _totalCurveLength : float
var _nWaypoints : int
var _curWaypointIdx : int
var _waypointRatios : Array

var _moving := false
var _moveFrom := 0.0
var _moveTo := 0.0
var _moveTime := 0.0
var _moveDelay := 0.0
var _moveDirection := 1 # 1: forward, -1: backward

func _ready():
	var c = get_parent().curve
	_nWaypoints = c.get_point_count()
	_totalCurveLength = c.get_baked_length()
	_waypointRatios = []

	var curLength := 0.0
	for i in range(_nWaypoints):
		if i > 0:
			var r1 = c.get_closest_offset(c.get_point_position(i - 1))
			var r2 = c.get_closest_offset(c.get_point_position(i))
			curLength += r2 - r1
		_waypointRatios.append(curLength / _totalCurveLength)

	progress_ratio = 0
	_curWaypointIdx = 0

	# wait if need be
	if _pauseTimeAtWaypoints > 0:
		await(get_tree().create_timer(_pauseTimeAtWaypoints)).timeout

	_start_move()

func _process(delta: float):
	if not _moving:
		return

	if _moveDelay < _moveTime:
		_moveDelay += delta

		var t := _moveDelay / _moveTime
		progress_ratio = lerp(_moveFrom, _moveTo, t)
	else:
		progress_ratio = _moveTo
		_moving = false
		_reach_waypoint()

func _reach_waypoint():
	# wait if need be
	if _pauseTimeAtWaypoints > 0:
		await(get_tree().create_timer(_pauseTimeAtWaypoints)).timeout

	# restart movement
	_start_move()

func _start_move():
	_curWaypointIdx += _moveDirection
	if _curWaypointIdx == _nWaypoints:
		if _jumpToStart:
			_curWaypointIdx = 1
		else:
			_moveDirection = -1
			_curWaypointIdx -= 2
	elif _curWaypointIdx == -1:
		_moveDirection = 1
		_curWaypointIdx += 2

	_moveFrom = _waypointRatios[_curWaypointIdx - _moveDirection]
	_moveTo = _waypointRatios[_curWaypointIdx]
	_moveTime = abs(_moveTo - _moveFrom) * _totalCurveLength / _speed
	_moveDelay = 0
	_moving = true
