# Validator for checking player food
extends BaseValidator

func _validation(_card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var food_amount: int = values.get("food_amount", 0)
	return Global.player_data.player_food >= food_amount
