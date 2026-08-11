# Validator for checking a card's subtype
# useful for filtering cards down for pick 
# This will fail (result in banish) if used on a card currently in play
extends BaseValidator

func _validation(card_data: CardData, _action: BaseAction, values: Dictionary[String, Variant]) -> bool:
	if card_data == null:
		return false
	
	var card_subtypes: Array[int] = []
	card_subtypes.assign(_get_validator_value("card_subtypes", values, _action, []))
	
	var card_subtypes_exclude: Array[int] = []
	card_subtypes_exclude.assign(_get_validator_value("card_subtypes_exclude", values, _action, []))
	
	# whitelist; empty whitelist counts ALL cards
	if len(card_subtypes) > 0:
		if not card_subtypes.has(card_data.card_subtype):
			return false
	# blacklist; Useful to exclude GENERATED cards
	if card_subtypes_exclude.has(card_data.card_subtype):
		return false
	return true
