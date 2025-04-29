extends Node
var spotlight_spotted_player : bool 
var goal_reached: bool
var level_alerts: int
var total_alerts: int
var level_complete_time: String
var vent_entered: bool
var is_game_over : bool
var results_table: Dictionary = {"level_0": {"time": [500,2000,3000,4000,5000], "alerts": [0,1,2,3,4]},
								"level_1": {"time": [1000,1500,2000,2500,3000], "alerts": [0,1,2,3,4]},
								"level_2": {"time": [2000,3000,3500,4000,4500], "alerts": [0,1,2,3,4]},
								"level_3": {"time": [1500,2500,3000,4000,5000], "alerts": [0,1,2,3,4]},
								"level_4": {"time": [3000,5000,10000,10500,11000], "alerts": [0,1,2,3,4]},
								"level_5": {"time": [10000,11000,12000,13000,14000], "alerts": [0,1,2,3,4]},
								"level_6": {"time": [1000,2000,3000,4000,5000], "alerts": [0,1,2,3,4]},
								}
