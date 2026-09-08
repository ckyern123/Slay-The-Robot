## Artifact which generates block after a set number of attack cards are played.
extends BaseArtifact

func connect_signals() -> void:
	super()
	Signals.card_created.connect(_on_card_created)

func _on_card_created(card_data: CardData) -> void:
	if (card_data.card_type == CardData.CARD_TYPES.CRAFT):
		ActionGenerator.generate_artifact_counter_increment_action(artifact_data, 1)
