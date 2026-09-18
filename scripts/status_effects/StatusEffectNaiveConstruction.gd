## Grants energy whenever heat overflows
extends BaseStatusEffect


func _connect_signals() -> void:
	Signals.card_created.connect(_on_card_created)

func _on_card_created(card_data: CardData):
	if (card_data.card_type == CardData.CARD_TYPES.CRAFT):
		var card_play_request: CardPlayRequest = _generate_status_effect_card_play_request()
	
		var action_data: Array[Dictionary] = [
			{
			Scripts.ACTION_ADD_ORE: {"ore_amount": -1}
		}]
		var generated_actions: Array[BaseAction] = ActionGenerator.create_actions(Global.get_player(), null, [],  action_data, null)
		ActionHandler.add_actions(generated_actions)
