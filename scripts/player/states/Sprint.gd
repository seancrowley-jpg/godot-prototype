extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var run_state: State
@export
var jump_state: State
@export
var roll_state: State
@export
var grapple_state: State
@export
var in_vehicle_state: State

func enter() -> void:
	super()
	parent.stand_collision()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed('jump') and parent.is_on_floor():
		return jump_state
	elif event.is_action_pressed('crouch') and parent.is_on_floor():
		return roll_state
	return null

func process_physics(delta: float) -> State:
	parent.movement(parent.sprint_speed,delta)

	if !Input.is_action_pressed("sprint") && parent.velocity:
		return run_state

	if !parent.velocity:
		return idle_state
		
	if !parent.is_on_floor():
		return fall_state
	
	if parent.in_vehicle:
		return in_vehicle_state
	return null
	
