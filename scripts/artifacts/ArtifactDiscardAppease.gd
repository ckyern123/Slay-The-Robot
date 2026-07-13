# Retains all cards in hand at end of turn
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.card_discarded.connect(_on_card_discarded)
	
func _on_card_discarded(_card_data: CardData, _is_manual_discard: bool):
	if (_is_manual_discard):
		var action_data: Array[Dictionary] = [{
		Scripts.ACTION_CHANGE_CARD_INFUENCE: {"card_influence": 1}
		}]
		var appease_actions: Array[BaseAction] = ActionGenerator.create_actions(null, null, [], action_data, null)

		ActionHandler.add_actions(appease_actions)
		
		Signals.artifact_proc.emit(artifact_data)
