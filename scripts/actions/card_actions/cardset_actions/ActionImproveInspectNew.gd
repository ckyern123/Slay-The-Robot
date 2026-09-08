## Improves cards' card_values by a given amount, adding where necessary.
## This can target a list of cards, or their parent cards (making it permanent if in player's deck)
## See ActionChangeCardValues for setter version
extends BaseCardsetAction

func perform_action():
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([null])
	for action_interceptor_processor in action_interceptor_processors:
		var modify_parent_card: bool = action_interceptor_processor.get_shadowed_action_values("modify_parent_card", false)
		var ore_amount: int = action_interceptor_processor.get_shadowed_action_values("ore_amount", 0)
		var money_amount: int = action_interceptor_processor.get_shadowed_action_values("money_amount", 0)
		var picked_cards: Array[CardData] = _get_picked_cards()
		
		# iterate over the cards, improving them and/or their parent
		for card_data in picked_cards:
			# get parent card if improving that
			var parent_card_data: CardData = null
			if modify_parent_card:
				if card_data.parent_card == null:
					DebugLogger.log_error("No parent card found. Are you modifying the permanent version?")
				else:
					parent_card_data = card_data.parent_card
			var exhaust_factor: int = 0
			if (HandManager.player_exhaust.size()>=3):
				exhaust_factor = 2
				var temp_cards: Array[CardData] = []
				for i in range(0,3):		
					temp_cards.append(HandManager.player_exhaust[i])
				HandManager.banish_cards(temp_cards,false)
			# iterate over the card's values, adding to them where necessary
			var i: int = 1 + exhaust_factor
			var card_value_improvements: Dictionary[String, int] = {"ore_amount": ore_amount + i,"money_amount": money_amount + i}
			#card_value_improvements.assign(action_interceptor_processor.get_shadowed_action_values("card_value_improvements", {})) # assign to force typed dict
			
			if card_data != null:
				card_data.improve_card_values(card_value_improvements)
			if parent_card_data != null:
				parent_card_data.improve_card_values(card_value_improvements)

func _to_string():
	return "Improve Card Action"
