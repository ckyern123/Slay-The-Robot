## Artifact which generates block after a set number of attack cards are played.
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.player_insight_changed.connect(_on_player_insight_changed)

func _on_player_insight_changed(delta: int) -> void:
	if (delta < 0):
		var sift_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PICK_CARDS:
		{
		"min_card_amount":1,
		"max_card_amount":1,
		"min_cards_are_required_for_action": false,
		"random_selection": false,
		"right_most": true,
		"card_pick_type": HandManager.HAND_PILE,
		"card_pick_text": "Choose up to {0} card(s) to discard. {1} cards selected",
		"action_data": [
		{Scripts.ACTION_DISCARD_CARDS:{}}
		]
		}
		},
		{Scripts.ACTION_DRAW_GENERATOR:{"draw_count":1}}]
		var sift_actions: Array[BaseAction] = ActionGenerator.create_actions(null, null, [], sift_action_data, null)
#
		ActionHandler.add_actions(sift_actions)
