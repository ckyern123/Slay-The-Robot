extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var food_amount: int = action_interceptor_processor.get_shadowed_action_values("food_amount", 0)
		Global.player_data.add_food(food_amount)

func _to_string():
	var food_amount: int = get_action_value("food_amount", 0)
	return "Add Food Action: " + str(food_amount)
