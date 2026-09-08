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
			if Global.player_food <= 0:
				Global.end_run(Global.RUN_ENDS.LOSS)
			if Global.player_data.player_deck.size() >= 100:
				Global.end_run(Global.RUN_ENDS.VICTORY)
			end_turn()
		END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ACTIONS:
			# prevents further card plays but finishes the rest of the current action stack
			HandManager.refund_card_queue()
			HandManager.set_disable_hand(true)
				
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
				
			if Global.player_data.player_health >= Global.player_data.threshold_mark:
				Global.player_data.threshold_mark += 30
				var threshold_action_data = [{Scripts.ACTION_CREATE_CARDS:{"created_card_object_id":"card_hubris","action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}],"number_of_cards":1}}]
				var threshold_actions: Array = ActionGenerator.create_actions(null, null, [], threshold_action_data, null)
				ActionHandler.add_actions(threshold_actions)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			var food_count: int = 0 - Global.player_data.player_size
			Global.player_data.add_food(food_count/10)
			
			if Global.player_data.player_food <= 0:
				Signals.player_killed.emit(Global.get_player())
			if Global.player_data.player_health >= Global.player_data.player_health_max:
				Signals.run_victory.emit()
			end_turn()
		END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS, _:
			# default
			# continuously wait for all card plays to finish before ending the player's turn
			HandManager.set_disable_hand(true)
			while len(HandManager.card_play_queue) > 0 or ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			if Global.player_data.player_health >= Global.player_data.threshold_mark:
				Global.player_data.threshold_mark += 30
				var threshold_action_data: Array[Dictionary] = [{Scripts.ACTION_CREATE_CARDS:{"created_card_object_id":"card_hubris","action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}],"number_of_cards":1}}]
				var threshold_actions: Array = ActionGenerator.create_actions(null, null, [], threshold_action_data, null)
				ActionHandler.add_actions(threshold_actions)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			var food_count: int = 0 - Global.player_data.player_size
			Global.player_data.add_food(food_count/10)
			
			if Global.player_data.player_food <= 0:
				Signals.player_killed.emit(Global.get_player())
			if Global.player_data.player_health >= Global.player_data.player_health_max:
				Signals.run_victory.emit()
			end_turn()

func disable():
	_combat = null

func end_turn():
	if _combat != null:
		_combat.end_turn_animation()
