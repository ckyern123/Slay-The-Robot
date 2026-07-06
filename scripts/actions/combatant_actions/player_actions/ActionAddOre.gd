extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var ore_amount: int = action_interceptor_processor.get_shadowed_action_values("ore_amount", 0)
		Global.player_data.add_ore(ore_amount)

func _to_string():
	var ore_amount: int = get_action_value("ore_amount", 0)
	return "Add Ore Action: " + str(ore_amount)
