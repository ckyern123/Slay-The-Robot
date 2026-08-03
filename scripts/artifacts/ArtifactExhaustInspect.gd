# Retains all cards in hand at end of turn
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.card_exhausted.connect(_on_card_exhausted)
	
func _on_card_exhausted(_card_data: CardData):
b	ActionGenerator.generate_artifact_counter_increment_action(artifact_data, 1)
