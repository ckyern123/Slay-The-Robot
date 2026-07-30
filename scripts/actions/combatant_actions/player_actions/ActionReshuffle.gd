extends BaseAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	
	for action_interceptor_processor in action_interceptor_processors:
		var shuffle_discard_into_draw: bool = action_interceptor_processor.get_shadowed_action_values("shop_refresh", true)
		var shop_data: ShopData = Global.get_shop_at_player_location()
		shop_data.shop_is_visited = false
		shop_data.refresh_shop = true
		shop_overlay.populate_shop()
		Global.player_data.player_refresh = 5
		
func _to_string():
	return "Reshuffle Action"
