extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var refresh_amount: int = action_interceptor_processor.get_shadowed_action_values("refresh_amount", 0)
		Global.player_data.add_refresh(refresh_amount)

func _to_string():
	var refresh_amount: int = get_action_value("refresh_amount", 0)
	return "Add Refresh Action: " + str(refresh_amount)
