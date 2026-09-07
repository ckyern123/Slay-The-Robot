extends Button

var ascend_action_data: Array[Dictionary] = [
	{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 1,
		"max_card_amount": 1,
		"min_cards_are_required_for_action": true,
		"random_selection": false,
		"card_pick_type": HandManager.HAND_PILE,
		"card_pick_text": "Choose {0} card to ascend. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_TYPE: {"card_types": [CardData.CARD_TYPES.FACTION]}},				{
				Scripts.VALIDATOR_CARD_PROPERTIES:
					{
					"card_property_name": "card_influence",
					"operator": ">=",
					"comparison_value": 2,
					"invert_validation": false,
					}
				}
		],
		"action_data": [{Scripts.ACTION_ASCEND_CARDS:{}},{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":-1}}
			]
		}
	}]
# Called when the node enters the scene tree for the first time.

func _ready():
	Signals.player_insight_changed.connect(_on_player_insight_changed)
	disabled = true
	pressed.connect(_button_pressed)
	pass # Replace with function body.

func _on_player_insight_changed(delta:int):
	if (Global.player_data.player_insight>0):
		disabled = false
	else:
		disabled = true
		
func _button_pressed():
	print("buttons")
	var ascend_actions: Array = ActionGenerator.create_actions(null, null, [], ascend_action_data, null)
	ActionHandler.add_actions(ascend_actions)
