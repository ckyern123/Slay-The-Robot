extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var insight_amount: int = action_interceptor_processor.get_shadowed_action_values("insight_amount", 0)
		Global.player_data.add_insight(insight_amount)

func _to_string():
	var insight_amount: int = get_action_value("insight_amount", 0)
	return "Add Insight Action: " + str(insight_amount)
