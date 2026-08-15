extends BaseAction

func perform_action():
	#var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	Signals.tween_discard.emit()

func _to_string():
	return "Tween Discard"
