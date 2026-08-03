# Action to add cards to your draw pile
extends BaseCardsetAction

func perform_action() -> void:
	
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	for action_interceptor_processor in action_interceptor_processors:
		var picked_cards: Array[CardData] = _get_picked_cards()
		var animation_id: String = action_interceptor_processor.get_shadowed_action_values("card_animation_id", HandManager.PILE_INSERTION_STRATEGIES.TOP)
#		for card in picked_cards:
#			HandManager.add_cards_to_draw(picked_cards, card_destination_strategy)
