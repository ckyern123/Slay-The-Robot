# Validator for checking player room
extends BaseValidator

func _validation(_card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	var room_amount: int = values.get("room_amount", 0)
	return Global.player_data.player_food >= room_amount
