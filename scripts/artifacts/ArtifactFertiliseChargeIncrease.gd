# Retains all cards in hand at end of turn
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.player_fertilise.connect(_on_player_fertilise)
	
func _on_player_fertilise(delta: int):
	var action_data: Array[Dictionary] = [{Scripts.ACTION_CHANGE_ARTIFACT_CHARGE:{"artifact_id": "artifact_fertiliser","artifact_charges": (delta)}}]
	var charge_actions: Array[BaseAction] = ActionGenerator.create_actions(null, null, [], action_data, null)
#
	ActionHandler.add_actions(charge_actions)
		#
	Signals.artifact_proc.emit(artifact_data)
