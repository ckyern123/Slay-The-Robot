# Retains all cards in hand at end of turn
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.player_insight_changed.connect(_on_player_insight_changed)
	
func _on_player_insight_changed(delta: int):
	var action_data: Array[Dictionary] = [{Scripts.ACTION_CHANGE_ARTIFACT_CHARGE:{"artifact_id": "artifact_improve_explore","artifact_charges": (1+Global.player_data.player_insight/5)}}]
	var charge_actions: Array[BaseAction] = ActionGenerator.create_actions(null, null, [], action_data, null)
#
	ActionHandler.add_actions(charge_actions)
		#
		#Signals.artifact_proc.emit(artifact_data)
