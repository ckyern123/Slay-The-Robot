# Action to exhaust selected cards
extends BaseCardsetAction

func perform_action() -> void:
	var picked_cards: Array[CardData] = _get_picked_cards()
	for card_data in picked_cards:
		# iterate over the card's values, adding to them where necessary
		var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action()
		for action_interceptor_processor: ActionInterceptorProcessor in action_interceptor_processors:
			var target: BaseCombatant = Global.get_player()
			if target == null:
				continue
			var rarity_factor: int = 0
			if (card_data.card_rarity == CardData.CARD_RARITIES.COMMON):
				rarity_factor = 1
			elif (card_data.card_rarity == CardData.CARD_RARITIES.UNCOMMON):
				rarity_factor = 2
			elif (card_data.card_rarity == CardData.CARD_RARITIES.RARE):
				rarity_factor = 4
			var upgrade_factor: int = card_data.card_upgrade_amount
			var health_amount: int = 1 + rarity_factor + (rarity_factor * upgrade_factor)

			target.add_health(health_amount, 0)
			Global.player_data.add_card_to_court(card_data)
	HandManager.exhaust_cards(picked_cards)
