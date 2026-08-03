## A simple animated sprite that plays over Cardants then frees itself.
## Primarily used for impacts during Card
## See ActionAttackGenerator and ActionCreateEffectAnimation
extends AnimatedSprite2D
class_name AnimatedCardEffect

## Every Card effect animation should have a track with this name
const CARD_EFFECT_ANIMATION_NAME: String = AnimationData.ANIMATION_VFX

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)

func init(animation_data: AnimationData) -> void:
	if animation_data == null:
		DebugLogger.log_error("AnimatedCardEffect.init(): animation \"{0}\" not defined".format([animation_data.object_id]))
		queue_free()
		return
	
	sprite_frames = animation_data.animations
	if sprite_frames.has_animation(CARD_EFFECT_ANIMATION_NAME):
		play(CARD_EFFECT_ANIMATION_NAME)
	else:
		DebugLogger.log_error("AnimatedCardEffect.init(): animation \"{0}\" missing \"{1}\"".format([animation_data.object_id, CARD_EFFECT_ANIMATION_NAME]))
	

func _on_animation_finished():
	queue_free()
