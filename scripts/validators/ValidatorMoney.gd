# Validator for checking player money
extends BaseValidator

func _validation(_card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var money_amount: int = values.get("money_required", 0)
	print("money_required:" + str(money_amount))
	print("money_amount:" + str(Global.player_data.player_money))
	return Global.player_data.player_money >= money_amount
