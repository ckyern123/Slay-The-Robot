# Modifies the damage output of attack actions by strength amount
extends BaseActionInterceptor

const DAMAGE_INCREASE_STATUS_EFFECT_ID: String = "status_effect_damage_increase"

func process_action_interception(action_interceptor_processor: ActionInterceptorProcessor, _preview_mode: bool = false) -> int:
	var parent_combatant: BaseCombatant = action_interceptor_processor.parent_action.parent_combatant
	var food_increase_charges: int = parent_combatant.get_status_charges("status_effect_food_increase")
	var food: int = action_interceptor_processor.get_shadowed_action_values("food_amount", 0)
	var modified_food: int = food + food_increase_charges
	action_interceptor_processor.set_shadowed_action_values("food_amount", modified_food)
	
	return ACTION_ACCEPTENCES.CONTINUE
