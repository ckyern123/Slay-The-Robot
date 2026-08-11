# Validator for checking a card's type
# useful for filtering cards down for pick 
# This will fail (result in banish) if used on a card currently in play
extends BaseValidator

func _validation(card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	if card_data == null:
		return false
	var card_types: Array[int] = []
	card_types.assign(_get_validator_value("card_types", values, _action, []))
	
	var card_types_exclude: Array[int] = []
	card_types_exclude.assign(_get_validator_value("card_types_exclude", values, _action, []))
	
	# whitelist; empty whitelist counts ALL cards
	if len(card_types) > 0:
		if not card_types.has(card_data.card_type):
			return false
	# blacklist; Useful to exclude GENERATED cards
	if card_types_exclude.has(card_data.card_type):
		return false
	return true
