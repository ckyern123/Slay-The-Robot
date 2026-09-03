# a utility object for Combat to allow asynchronous turn ending with hierarchical levels of end turn immediacy
# if a higher level of immediacy is detected in Combat a new object will be created, replacing the await
extends RefCounted
class_name CombatEndTurn

var _combat = null	# the parent combat ui node, just used for a callback
enum END_TURN_QUEUE_IMMEDIACY {	# Do not rearrange
	WAIT_FOR_ALL_CARD_PLAYS,
	WAIT_FOR_ACTIONS,
	IMMEDIATE
	}
var end_turn_queue_immediacy: int = END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS

func _init(combat, _end_turn_queue_immediacy = END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS):
	_combat = combat
	end_turn_queue_immediacy = _end_turn_queue_immediacy

func wait() -> void:
	match end_turn_queue_immediacy:
		END_TURN_QUEUE_IMMEDIACY.IMMEDIATE:
			# forces the turn to instantly end, removing all remaining card plays and actions
			HandManager.refund_card_queue()
			ActionHandler.clear_all_actions()
			var food_count: int = 0 - (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			Global.player_data.add_food(food_count/10)
			
			Global.player_data.add_food(Global.player_data.blight/99)
			Global.player_data.blight -= 0		
			if Global.player_food <= 0:
				Global.end_run(Global.RUN_ENDS.LOSS)
			if Global.player_data.player_deck.size() >= 100:
				Global.end_run(Global.RUN_ENDS.VICTORY)
			end_turn()
		END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ACTIONS:
			# prevents further card plays but finishes the rest of the current action stack
			HandManager.refund_card_queue()
			HandManager.set_disable_hand(true)
			var sprawl_count: int = Global.player_data.player_size - (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			if (sprawl_count < 0):
				var influence_action_data: Array[Dictionary] = [{
				Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [
				{
				Scripts.VALIDATOR_CARD_PROPERTIES:
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				},{Scripts.VALIDATOR_CARD_RARITY:{"card_rarities_exclude":[CardData.CARD_RARITIES.GENERATED]}}
			],
				"action_data": [
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel"
					},
				}
				]
			}},{
				Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": abs(sprawl_count)/3,
				"max_card_amount": abs(sprawl_count)/3,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [
					{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
				],
				"action_data": [
				{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
					"card_influence": -1
				}}]
			}}]
				var influence_actions: Array = ActionGenerator.create_actions(null, null, [], influence_action_data, null)
				ActionHandler.add_actions(influence_actions)
				
				#tween animation discard pile
				Signals.tween_discard.emit()
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			var food_count: int = 0 - (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			Global.player_data.add_food(food_count/10)
			
			Global.player_data.add_food(Global.player_data.blight/99)
			Global.player_data.blight -= 0
			if Global.player_food <= 0:
				Global.end_run(Global.RUN_ENDS.LOSS)
			var deck_total = (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			if deck_total >= 60 and Global.player_data.get_player_artifacts().size() >= 17 and Global.player_data.player_books >= 5:
				Global.end_run(Global.RUN_ENDS.VICTORY)
			end_turn()
		END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS, _:
			# default
			# continuously wait for all card plays to finish before ending the player's turn
			HandManager.set_disable_hand(true)
			var sprawl_count: int = Global.player_data.player_size - (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			if (sprawl_count < 0):
				var influence_action_data: Array[Dictionary] = [{
				Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [
				{
				Scripts.VALIDATOR_CARD_PROPERTIES:
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				},{Scripts.VALIDATOR_CARD_RARITY:{"card_rarities_exclude":[CardData.CARD_RARITIES.GENERATED]}}
			],
				"action_data": [
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel"
					},
				}
				]
			}},{
				Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": abs(sprawl_count)/3,
				"max_card_amount": abs(sprawl_count)/3,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [
					{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
				],
				"action_data": [
				{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
					"card_influence": -1
				}},
				]
			}}]
				var influence_actions: Array = ActionGenerator.create_actions(null, null, [], influence_action_data, null)
				ActionHandler.add_actions(influence_actions)
				Signals.tween_discard.emit()
			while len(HandManager.card_play_queue) > 0 or ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
				
			var food_count: int = 0 - (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			Global.player_data.add_food(food_count/10)
			
			if Global.player_data.player_food <= 0:
				Global.end_run(Global.RUN_ENDS.LOSS)
			var deck_total = (HandManager.player_draw.size() + HandManager.player_discard.size() + HandManager.player_hand.size())
			if deck_total >= 60 and Global.player_data.get_player_artifacts().size() >= 17 and Global.player_data.player_books >= 5:
				Global.end_run(Global.RUN_ENDS.VICTORY)
			end_turn()

func disable():
	_combat = null

func end_turn():
	if _combat != null:
		_combat.end_turn_animation()
