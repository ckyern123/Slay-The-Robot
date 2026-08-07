extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var books_amount: int = action_interceptor_processor.get_shadowed_action_values("books_amount", 0)
		Global.player_data.add_books(books_amount)

func _to_string():
	var books_amount: int = get_action_value("books_amount", 0)
	return "Add books Action: " + str(books_amount)
