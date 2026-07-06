extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var influence_amount: int = action_interceptor_processor.get_shadowed_action_values("influence_amount", 0)
		Global.player_data.add_influence(influence_amount)

func _to_string():
	var influence_amount: int = get_action_value("influence_amount", 0)
	return "Add Influence Action: " + str(influence_amount)
