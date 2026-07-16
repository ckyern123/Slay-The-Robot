# Validator for checking player ore
extends BaseValidator

func _validation(_card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var insight_amount: int = values.get("insight_amount", 0)
	return Global.player_data.player_insight >= insight_amount
