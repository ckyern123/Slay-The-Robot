extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var room_amount: int = action_interceptor_processor.get_shadowed_action_values("room_amount", 0)
		Global.player_data.add_room(room_amount)

func _to_string():
	var room_amount: int = get_action_value("room_amount", 0)
	return "Add room Action: " + str(room_amount)
