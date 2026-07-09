# Validator for checking player ore
extends BaseValidator

func _validation(_card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var ore_amount: int = values.get("ore_amount", 0)
	return Global.player_data.player_ore >= ore_amount
