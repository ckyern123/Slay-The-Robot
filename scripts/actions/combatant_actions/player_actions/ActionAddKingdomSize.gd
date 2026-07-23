extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var size_amount: int = action_interceptor_processor.get_shadowed_action_values("size_amount", 0)
		Global.player_data.add_size(size_amount)

func _to_string():
	var size_amount: int = get_action_value("size_amount", 0)
	return "Add Food Action: " + str(size_amount)
