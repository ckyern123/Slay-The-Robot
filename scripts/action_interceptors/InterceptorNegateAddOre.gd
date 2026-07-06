## Prevents gaining food.
extends BaseActionInterceptor

func process_action_interception(action_interceptor_processor: ActionInterceptorProcessor, preview_mode: bool = false) -> int:
	var ore_amount: int = action_interceptor_processor.get_shadowed_action_values("ore_amount", 0)
	ore_amount = min(ore_amount, 0) # cannot gain food
	action_interceptor_processor.set_shadowed_action_values("ore_amount", food_amount)
	
	return ACTION_ACCEPTENCES.CONTINUE
