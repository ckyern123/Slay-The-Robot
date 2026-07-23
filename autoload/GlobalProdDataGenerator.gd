 ## Singleton for data generation in actual production.
## This is used to make content programmatically instead of messing with more fragile external JSON files.
extends Node

## Wrapper method used to generate all data used in production.
## After running this you can use Fileloader.export_read_only_data() to output to json files.
func generate_production_data() -> void:
	add_rest_actions()
	add_consumables()
	
	add_status_effects() # must be defined before enemies
	add_action_interceptors()
	
	add_enemies()
	add_events()
	add_dialogue()
	add_acts()
	
	add_colors()
	add_keywords()
	
	add_combat_vfx_animations()
	
	add_characters()
	add_player_data()
	
	add_run_modifiers()
	add_run_start_options()
	
	add_custom_ui()
	add_custom_signals()
	
	add_artifacts()
	add_card_decorators()
	add_cards()
	
	add_card_packs()
	add_artifact_packs()
	add_consumable_packs()


#region Artifacts
func add_artifacts() -> void:
	var artifact_add_money: ArtifactData = ArtifactData.new("artifact_add_money")
	artifact_add_money.artifact_name = "Artifact Add Money"
	artifact_add_money.artifact_description = "Adds money when obtained"
	artifact_add_money.artifact_add_actions = [{Scripts.ACTION_ADD_MONEY: {"money_amount": 20}}]
	
	Global.register_rod(artifact_add_money)
	
	var artifact_negate_money_gain: ArtifactData = ArtifactData.new("artifact_negate_money_gain")
	artifact_negate_money_gain.artifact_name = "Artifact Negate Money Gain"
	artifact_negate_money_gain.artifact_description = "Gain 1 energy per turn. You can no longer gain money"
	artifact_negate_money_gain.artifact_add_actions = [{Scripts.ACTION_ADD_ENERGY:{
		"target_overrides": BaseAction.TARGET_OVERRIDES.PLAYER,
		"energy_amount_max": 1,
	}}]
	artifact_negate_money_gain.artifact_remove_actions = [{Scripts.ACTION_ADD_ENERGY:{
		"target_overrides": BaseAction.TARGET_OVERRIDES.PLAYER,
		"energy_amount_max": -1,
	}}]
	artifact_negate_money_gain.artifact_interceptor_ids = ["interceptor_negate_add_money"]
	
	Global.register_rod(artifact_negate_money_gain)
	
	var artifact_heal_on_combat_ended: ArtifactData = ArtifactData.new("artifact_heal_on_combat_ended")
	artifact_heal_on_combat_ended.artifact_name = "Artifact Heal On Combat End"
	artifact_heal_on_combat_ended.artifact_description = "Grants 5 health when combat is over"
	artifact_heal_on_combat_ended.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_heal_on_combat_ended.artifact_end_of_combat_actions = [{
			Scripts.ACTION_ADD_HEALTH: {"target_override": BaseAction.TARGET_OVERRIDES.PLAYER, "health_amount": 5}
			}]
	
	Global.register_rod(artifact_heal_on_combat_ended)
	
	var artifact_discard_appease: ArtifactData = ArtifactData.new("artifact_discard_appease")
	artifact_discard_appease.artifact_name = "Artifact Waiting Bench"
	artifact_discard_appease.artifact_description = "When a Faction card is discarded, appease that card"
	artifact_discard_appease.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.RARE
	artifact_discard_appease.artifact_add_actions = [{
			Scripts.ACTION_HEAL_PERCENT: {
				"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
				"percentage_heal_amount": 1.0
				}
			}]
	
	Global.register_rod(artifact_discard_appease)
	
	var artifact_draw_on_kill: ArtifactData = ArtifactData.new("artifact_draw_on_kill")
	artifact_draw_on_kill.artifact_name = "Artifact Draw on Kill"
	artifact_draw_on_kill.artifact_description = "Draws a card when an enemy is killed"
	artifact_draw_on_kill.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.UNCOMMON
	artifact_draw_on_kill.artifact_script_path = "res://scripts/artifacts/ArtifactDrawOnKill.gd"
	Global.register_rod(artifact_draw_on_kill)
	
	
	var artifact_draw_on_combat_start: ArtifactData = ArtifactData.new("artifact_draw_on_combat_start")
	artifact_draw_on_combat_start.artifact_name = "Artifact Draw on Combat"
	artifact_draw_on_combat_start.artifact_description = "Draws 2 extra cards on the first turn"
	artifact_draw_on_combat_start.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.UNCOMMON
	artifact_draw_on_combat_start.artifact_color_id = "color_green"
	artifact_draw_on_combat_start.artifact_texture_path = "external/sprites/artifacts/artifact_green.png"
	artifact_draw_on_combat_start.artifact_first_turn_actions = [{Scripts.ACTION_DRAW_GENERATOR: {"draw_count": 2}}]
	
	Global.register_rod(artifact_draw_on_combat_start)
	
	var artifact_energy_on_combat_start: ArtifactData = ArtifactData.new("artifact_energy_on_combat_start")
	artifact_energy_on_combat_start.artifact_name = "Artifact Energy On Combat Start"
	artifact_energy_on_combat_start.artifact_description = "Gain 1 energy on the first turn"
	artifact_energy_on_combat_start.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.UNCOMMON
	artifact_energy_on_combat_start.artifact_color_id = "color_white"
	artifact_energy_on_combat_start.artifact_texture_path = "external/sprites/artifacts/artifact_white.png"
	artifact_energy_on_combat_start.artifact_first_turn_actions = [{Scripts.ACTION_ADD_ENERGY: {"energy_amount": 1}}]
	
	Global.register_rod(artifact_energy_on_combat_start)
	
	
	var artifact_easy_mode: ArtifactData = ArtifactData.new("artifact_easy_mode")
	artifact_easy_mode.artifact_name = "Artifact Easy Mode"
	artifact_easy_mode.artifact_description = "Sets enemy HP to 1"
	artifact_easy_mode.artifact_counter = 999
	artifact_easy_mode.artifact_counter_max = 999
	artifact_easy_mode.artifact_counter_reset_on_combat_end = -1
	artifact_easy_mode.artifact_counter_reset_on_turn_start = -1
	artifact_easy_mode.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.EVENT
	artifact_easy_mode.artifact_script_path = "res://scripts/artifacts/ArtifactEasyMode.gd"
	
	Global.register_rod(artifact_easy_mode)
	
	var artifact_block_on_attacks: ArtifactData = ArtifactData.new("artifact_block_on_attacks")
	artifact_block_on_attacks.artifact_name = "Artifact Block on Attacks"
	artifact_block_on_attacks.artifact_description = "Grants 5 block every 3 attacks"
	artifact_block_on_attacks.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_block_on_attacks.artifact_color_id = "color_red"
	artifact_block_on_attacks.artifact_texture_path = "external/sprites/artifacts/artifact_red.png"
	artifact_block_on_attacks.artifact_script_path = "res://scripts/artifacts/ArtifactBlockOnAttacks.gd"
	artifact_block_on_attacks.artifact_counter_max = 3
	artifact_block_on_attacks.artifact_counter_wraparound = true
	artifact_block_on_attacks.artifact_counter_reset_on_turn_start = 0
	artifact_block_on_attacks.artifact_counter_reset_on_combat_end = 0
	artifact_block_on_attacks.artifact_max_counter_actions = [{
			Scripts.ACTION_BLOCK: {"block": 5, "target_override": BaseAction.TARGET_OVERRIDES.PLAYER}
			}]
	
	Global.register_rod(artifact_block_on_attacks)
	
	var artifact_retain_hand: ArtifactData = ArtifactData.new("artifact_retain_hand")
	artifact_retain_hand.artifact_name = "Artifact Retain Hand"
	artifact_retain_hand.artifact_description = "Cards will be retained end of turn"
	artifact_retain_hand.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_retain_hand.artifact_script_path = "res://scripts/artifacts/ArtifactRetainHand.gd"
	
	Global.register_rod(artifact_retain_hand)
	
	# preserves energy between turns
	var artifact_preserve_energy: ArtifactData = ArtifactData.new("artifact_preserve_energy")
	artifact_preserve_energy.artifact_name = "Artifact Preserve Energy"
	artifact_preserve_energy.artifact_description = "Energy will be preserved between turns"
	artifact_preserve_energy.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.RARE
	artifact_preserve_energy.artifact_first_turn_actions = [{
		Scripts.ACTION_APPLY_STATUS: {
			"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
			"status_effect_object_id": "status_effect_preserve_energy"
			}
		}]
	artifact_preserve_energy.artifact_script_path = "res://scripts/artifacts/BaseArtifact.gd"
	
	Global.register_rod(artifact_preserve_energy)
	
	# Enables a rest action when obtained, which grants a damage increase at the start of combat
	var artifact_increase_attack_on_rest: ArtifactData = ArtifactData.new("artifact_increase_attack_on_rest")
	artifact_increase_attack_on_rest.artifact_name = "Artifact Increase Attack on Rest"
	artifact_increase_attack_on_rest.artifact_description = "Allows a permanent attack boost at rest sites"
	artifact_increase_attack_on_rest.artifact_counter = 0
	artifact_increase_attack_on_rest.artifact_counter_max = 3
	artifact_increase_attack_on_rest.artifact_color_id = "color_orange"
	artifact_increase_attack_on_rest.artifact_texture_path = "external/sprites/artifacts/artifact_orange.png"
	artifact_increase_attack_on_rest.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_increase_attack_on_rest.artifact_add_actions = [{
		Scripts.ACTION_UPDATE_REST_ACTIONS: {"add_rest_action_object_ids": ["rest_action_increase_attack_on_rest"]}
	}]
	artifact_increase_attack_on_rest.artifact_first_turn_actions = [{
			Scripts.ACTION_APPLY_STATUS: {
				"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
				"status_effect_object_id": "status_effect_damage_increase",
				"custom_key_names": {
					# convert artifact counter passed in from BaseArtifact, into the status charges
					"status_charge_amount": "artifact_counter"
				}}
			}]
	
	Global.register_rod(artifact_increase_attack_on_rest)
	
	var artifact_see_top_of_draw_pile: ArtifactData = ArtifactData.new("artifact_see_top_of_draw_pile")
	artifact_see_top_of_draw_pile.artifact_name = "Artifact See Draw Pile"
	artifact_see_top_of_draw_pile.artifact_description = "See the top cards in your draw pile"
	artifact_see_top_of_draw_pile.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_see_top_of_draw_pile.artifact_color_id = "color_blue"
	artifact_see_top_of_draw_pile.artifact_texture_path = "external/sprites/artifacts/artifact_blue.png"
	artifact_see_top_of_draw_pile.artifact_first_turn_actions = [{
		Scripts.ACTION_CUSTOM_UI: {"enable_custom_ui": true, "custom_ui_object_id": "custom_ui_see_top_of_draw_pile", "target_override": BaseAction.TARGET_OVERRIDES.PLAYER}
		}]
	
	Global.register_rod(artifact_see_top_of_draw_pile)
	
	# Makes an attack card top deck when obtained
	var artifact_top_deck_attack_card: ArtifactData = ArtifactData.new("artifact_top_deck_attack_card")
	artifact_top_deck_attack_card.artifact_name = "Artifact Make Attack Card Innate"
	artifact_top_deck_attack_card.artifact_description = "Select an attack card to make appear at the top of your deck."
	artifact_top_deck_attack_card.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_top_deck_attack_card.artifact_add_actions = [
	{
	Scripts.ACTION_PICK_CARDS: {
		"max_card_amount": 1,
		"min_card_amount": 1,
		"min_cards_are_required_for_action": true,
		"random_selection": false,
		"quick_pick": true,
		"card_pick_type": HandManager.DECK,
		"card_pick_text": "Choose a card to make top deck",
		"action_data": [
			# convert the card to top deck
			{Scripts.ACTION_CHANGE_CARD_PROPERTIES: 
				{
				"modify_parent_card": false,
				"card_properties": {"card_unremovable_from_deck": true, "card_untransformable_from_deck": true, "card_first_shuffle_priority": 1, }
				}
				},
			],
		# only non-generated removable attack cards allowed
		"validator_data": [
			{Scripts.VALIDATOR_CARD_TYPE: {"card_types": [CardData.CARD_TYPES.ATTACK]}},
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}},
			{Scripts.VALIDATOR_CARD_PROPERTIES: {"card_property_name": "card_unremovable_from_deck", "operator": "==", "comparison_value": false}},
		],
		}
	},
	]
	
	Global.register_rod(artifact_top_deck_attack_card)
	
	
	var artifact_right_click_shuffle_deck: ArtifactData = ArtifactData.new("artifact_right_click_shuffle_deck")
	artifact_right_click_shuffle_deck.artifact_name = "Artifact Reshuffle"
	artifact_right_click_shuffle_deck.artifact_description = "Right click to shuffle discard into draw pile."
	artifact_right_click_shuffle_deck.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.COMMON
	artifact_right_click_shuffle_deck.artifact_color_id = "color_green"
	artifact_right_click_shuffle_deck.artifact_texture_path = "external/sprites/artifacts/artifact_green.png"
	artifact_right_click_shuffle_deck.artifact_script_path = "res://scripts/artifacts/BaseArtifact.gd"
	artifact_right_click_shuffle_deck.artifact_right_click_actions = [
		{Scripts.ACTION_RESHUFFLE:{}}
	]
	
	Global.register_rod(artifact_right_click_shuffle_deck)
	
	### Filler Artifacts
	var artifact_boss_red: ArtifactData = ArtifactData.new("artifact_boss_red")
	artifact_boss_red.artifact_name = "Artifact Red Boss"
	artifact_boss_red.artifact_description = "Test Red Boss Artifact."
	artifact_boss_red.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_boss_red.artifact_color_id = "color_red"
	artifact_boss_red.artifact_texture_path = "external/sprites/artifacts/artifact_red.png"
	
	Global.register_rod(artifact_boss_red)
	
	var artifact_shop_red: ArtifactData = ArtifactData.new("artifact_shop_red")
	artifact_shop_red.artifact_name = "Artifact Red Shop"
	artifact_shop_red.artifact_description = "Test Red Shop Artifact."
	artifact_shop_red.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_shop_red.artifact_color_id = "color_red"
	artifact_shop_red.artifact_texture_path = "external/sprites/artifacts/artifact_red.png"
	
	Global.register_rod(artifact_shop_red)
	
	var artifact_boss_blue: ArtifactData = ArtifactData.new("artifact_boss_blue")
	artifact_boss_blue.artifact_name = "Artifact Blue Boss"
	artifact_boss_blue.artifact_description = "Test Blue Boss Artifact."
	artifact_boss_blue.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_boss_blue.artifact_color_id = "color_blue"
	artifact_boss_blue.artifact_texture_path = "external/sprites/artifacts/artifact_blue.png"
	
	Global.register_rod(artifact_boss_blue)
	
	var artifact_shop_blue: ArtifactData = ArtifactData.new("artifact_shop_blue")
	artifact_shop_blue.artifact_name = "Artifact Blue Shop"
	artifact_shop_blue.artifact_description = "Test Blue Shop Artifact."
	artifact_shop_blue.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_shop_blue.artifact_color_id = "color_blue"
	artifact_shop_blue.artifact_texture_path = "external/sprites/artifacts/artifact_blue.png"
	
	Global.register_rod(artifact_shop_blue)
	
	var artifact_boss_green: ArtifactData = ArtifactData.new("artifact_boss_green")
	artifact_boss_green.artifact_name = "Artifact Green Boss"
	artifact_boss_green.artifact_description = "Test Green Boss Artifact."
	artifact_boss_green.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_boss_green.artifact_color_id = "color_green"
	artifact_boss_green.artifact_texture_path = "external/sprites/artifacts/artifact_green.png"
	
	Global.register_rod(artifact_boss_green)
	
	var artifact_shop_green: ArtifactData = ArtifactData.new("artifact_shop_green")
	artifact_shop_green.artifact_name = "Artifact Green Shop"
	artifact_shop_green.artifact_description = "Test Green Shop Artifact."
	artifact_shop_green.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_shop_green.artifact_color_id = "color_green"
	artifact_shop_green.artifact_texture_path = "external/sprites/artifacts/artifact_green.png"
	
	Global.register_rod(artifact_shop_green)
	
	var artifact_boss_orange: ArtifactData = ArtifactData.new("artifact_boss_orange")
	artifact_boss_orange.artifact_name = "Artifact Orange Boss"
	artifact_boss_orange.artifact_description = "Test Orange Boss Artifact."
	artifact_boss_orange.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_boss_orange.artifact_color_id = "color_orange"
	artifact_boss_orange.artifact_texture_path = "external/sprites/artifacts/artifact_orange.png"
	
	Global.register_rod(artifact_boss_orange)
	
	var artifact_shop_orange: ArtifactData = ArtifactData.new("artifact_shop_orange")
	artifact_shop_orange.artifact_name = "Artifact Orange Shop"
	artifact_shop_orange.artifact_description = "Test Orange Shop Artifact."
	artifact_shop_orange.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_shop_orange.artifact_color_id = "color_orange"
	artifact_shop_orange.artifact_texture_path = "external/sprites/artifacts/artifact_orange.png"
	
	Global.register_rod(artifact_shop_orange)
	
	var artifact_boss_white: ArtifactData = ArtifactData.new("artifact_boss_white")
	artifact_boss_white.artifact_name = "Artifact White Boss"
	artifact_boss_white.artifact_description = "Test White Boss Artifact."
	artifact_boss_white.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BOSS
	artifact_boss_white.artifact_color_id = "color_white"
	artifact_boss_white.artifact_texture_path = "external/sprites/artifacts/artifact_white.png"
	
	Global.register_rod(artifact_boss_white)
	
	var artifact_shop_white: ArtifactData = ArtifactData.new("artifact_shop_white")
	artifact_shop_white.artifact_name = "Artifact White Shop"
	artifact_shop_white.artifact_description = "Test White Shop Artifact."
	artifact_shop_white.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_shop_white.artifact_color_id = "color_white"
	artifact_shop_white.artifact_texture_path = "external/sprites/artifacts/artifact_white.png"
	
	Global.register_rod(artifact_shop_white)
	
	

#endregion

#region Consumables
func add_consumables() -> void:
	# health consumable
	var consumable_heal: ConsumableData = ConsumableData.new("consumable_heal")
	consumable_heal.consumable_name = "Heal Item"
	consumable_heal.consumable_color_id = "color_white"
	consumable_heal.consumable_description = "Heals 20%"
	consumable_heal.consumable_use_text = "Drink"
	consumable_heal.consumable_requires_target = false
	consumable_heal.consumable_rarity = ConsumableData.CONSUMABLE_RARITIES.COMMON
	consumable_heal.consumable_texture_path = "external/sprites/consumables/consumable_red.png"
	consumable_heal.consumable_values = {
		"percentage_heal_amount": 0.20
	}
	consumable_heal.consumable_actions = [
		{
		Scripts.ACTION_HEAL_PERCENT: {
			"target_override": BaseAction.TARGET_OVERRIDES.PLAYER
		}
		}
	]
	Global.register_rod(consumable_heal)
	
	# block consumable
	var consumable_block: ConsumableData = ConsumableData.new("consumable_block")
	consumable_block.consumable_name = "Block Item"
	consumable_block.consumable_color_id = "color_white"
	consumable_block.consumable_description = "Adds 10 block"
	consumable_block.consumable_use_text = "Drink"
	consumable_block.consumable_requires_target = false
	consumable_block.consumable_rarity = ConsumableData.CONSUMABLE_RARITIES.COMMON
	consumable_block.consumable_texture_path = "external/sprites/consumables/consumable_green.png"
	consumable_block.consumable_values = {
		"block": 10,
	}
	consumable_block.consumable_actions = [
		{
		Scripts.ACTION_BLOCK: {
			"target_override": BaseAction.TARGET_OVERRIDES.PLAYER
			}
		}
	]
	Global.register_rod(consumable_block)
	
	# damaging consumable
	var consumable_damaging: ConsumableData = ConsumableData.new("consumable_damaging")
	consumable_damaging.consumable_name = "Damage Item"
	consumable_damaging.consumable_color_id = "color_white"
	consumable_damaging.consumable_description = "Damages a target for 10"
	consumable_damaging.consumable_use_text = "Throw"
	consumable_damaging.consumable_requires_target = true
	consumable_damaging.consumable_rarity = ConsumableData.CONSUMABLE_RARITIES.COMMON
	consumable_damaging.consumable_texture_path = "external/sprites/consumables/consumable_orange.png"
	consumable_damaging.consumable_values = {
		"damage": 10,
		"bypass_block": false,
	}
	consumable_damaging.consumable_actions = [
		{
		Scripts.ACTION_DIRECT_DAMAGE: {
			"target_override": BaseAction.TARGET_OVERRIDES.SELECTED_TARGETS
			}
		}
	]
	Global.register_rod(consumable_damaging)
	
	# multi enemy damaging consumable
	var consumable_multi_damaging: ConsumableData = ConsumableData.new("consumable_multi_damaging")
	consumable_multi_damaging.consumable_name = "Multiple Damage Item"
	consumable_multi_damaging.consumable_color_id = "color_white"
	consumable_multi_damaging.consumable_use_text = "Throw"
	consumable_multi_damaging.consumable_description = "Damages all enemies for 10"
	consumable_multi_damaging.consumable_requires_target = false
	consumable_multi_damaging.consumable_rarity = ConsumableData.CONSUMABLE_RARITIES.COMMON
	consumable_multi_damaging.consumable_texture_path = "external/sprites/consumables/consumable_yellow.png"
	consumable_multi_damaging.consumable_values = {
		"damage": 10,
		"bypass_block": false,
	}
	consumable_multi_damaging.consumable_actions = [
		{
		Scripts.ACTION_DIRECT_DAMAGE: 
			{
			"target_override": BaseAction.TARGET_OVERRIDES.ALL_ENEMIES,
			}
		}
	]
	Global.register_rod(consumable_multi_damaging)


#endregion

#region Rest Actions
func add_rest_actions() -> void:
	# rest action
	var rest_action_rest: RestActionData = RestActionData.new("rest_action_rest")
	rest_action_rest.rest_action_name = "Rest"
	rest_action_rest.rest_action_stat_name = "REST_REST_COUNT"
	rest_action_rest.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.EXCLUSIVE
	rest_action_rest.rest_actions = [
		{
		Scripts.ACTION_HEAL_PERCENT: {
			"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
			"percentage_heal_amount": 0.40
			}
		}
	]
	
	Global.register_rod(rest_action_rest)
	
	# upgrade card rest action
	# example of a cancelable rest action
	var rest_action_upgrade_card: RestActionData = RestActionData.new("rest_action_upgrade_card")
	rest_action_upgrade_card.rest_action_name = "Upgrade"
	rest_action_upgrade_card.rest_action_stat_name = "REST_UPGRADE_CARDS_COUNT"
	rest_action_upgrade_card.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.INCLUSIVE_REPEATABLE
	rest_action_upgrade_card.rest_action_auto_end = false # allows canceling
	rest_action_upgrade_card.rest_actions = [
	{
	Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 1,
		"max_card_amount": 1,
		"card_pick_type": HandManager.DECK,
		"card_pick_text": "Choose up to {0} card(s) to upgrade. {1} cards selected",
		"min_cards_are_required_for_action": true, # won't fire if you cancel it
		"quick_pick": false,
		"can_back_out": true, # allows rest action to be canceled
		"random_selection": false,
		# only upgradeable cards allowed
		"validator_data": [
			{Scripts.VALIDATOR_CARD_UPGRADEABLE: {}}
		],
		"action_data": [
			# embed the rest action end in the pick card action payload
			{Scripts.ACTION_REST_ACTION_END: {"rest_action_id": "rest_action_upgrade_card"}},
			{Scripts.ACTION_UPGRADE_CARDS: {"upgrade_parent_card": true}}
			]
		}
	}
	]
	
	rest_action_upgrade_card.rest_action_validators = [
		{
		Scripts.VALIDATOR_DECK_HAS_UPGRADEABLE_CARD: {}
		}
	]
	
	Global.register_rod(rest_action_upgrade_card)
	
	# remove cards action
	# example of a cancelable rest action
	var rest_action_remove_cards: RestActionData = RestActionData.new("rest_action_remove_cards")
	rest_action_remove_cards.rest_action_name = "Remove Cards"
	rest_action_remove_cards.rest_action_stat_name = "REST_REMOVE_CARDS_COUNT"
	rest_action_remove_cards.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.INCLUSIVE
	rest_action_remove_cards.rest_action_auto_end = false # can be cancelled
	rest_action_remove_cards.rest_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"use_parent_card": false,
			"min_card_amount": 1,
			"max_card_amount": 2,
			"min_cards_are_required_for_action": true,
			"quick_pick": false,
			"can_back_out": true, # allows rest action to be canceled
			"random_selection": false,
			"card_pick_text": "Choose {0} card(s) to remove. {1} cards selected",
			"card_pick_type": HandManager.DECK,
			"action_data": [
				# embed the rest action end in the pick card action payload
				{Scripts.ACTION_REST_ACTION_END: {"rest_action_id": "rest_action_remove_cards"}},
				{Scripts.ACTION_REMOVE_CARDS_FROM_DECK: {}}
				]
			}
		}
	]
	rest_action_remove_cards.rest_action_validators = [
		{
		Scripts.VALIDATOR_PILE_SIZE: 
			{
			"card_pick_type": HandManager.DECK,
			"card_type_maximum": 4,
			"card_types": CardData.CARD_TYPES.values(),	# any card
			"invert_validation": false,
			}
		}
	]
	
	Global.register_rod(rest_action_remove_cards)
	
	# enchant a selected card from your deck
	# randomly chooses an enchant
	# must have at least one card that can be decorated and enough money
	# NOTE: To add more random enchants, you must update the random selection, the pick validator, and the rest action deck validator
	var rest_action_enchant_cards: RestActionData = RestActionData.new("rest_action_enchant_cards")
	rest_action_enchant_cards.rest_action_name = "Enchant Cards (25)"
	rest_action_enchant_cards.rest_action_stat_name = "REST_ENCHANT_CARDS_COUNT"
	rest_action_enchant_cards.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.INCLUSIVE
	rest_action_enchant_cards.rest_action_auto_end = false
	rest_action_enchant_cards.rest_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"use_parent_card": false,
			"min_card_amount": 1,
			"max_card_amount": 2,
			"min_cards_are_required_for_action": true,
			"quick_pick": false,
			"can_back_out": true, # allows rest action to be canceled
			"random_selection": false,
			"card_pick_text": "Choose a card to enchant",
			"card_pick_type": HandManager.DECK,
			# only decoratable cards allowed, must be able to slot one of the provided decorators
			"validator_data": [
				{Scripts.VALIDATOR_CARD_IS_DECORATABLE: {
					"card_decorator_ids": 
					[
						"card_decorator_extra_draw",
						"card_decorator_block_on_play"
					]
				}}
			],
			"action_data": [
				# finish rest action
				{Scripts.ACTION_REST_ACTION_END: {"rest_action_id": "rest_action_enchant_cards"}},
				# remove money
				{Scripts.ACTION_ADD_MONEY:{"money_amount": -25}},
				# randomly decorate the card
				{Scripts.ACTION_DECORATE_CARDS: 
				{
					"decorate_parent_card": false, # already selecting the deck card
					"random_card_decorators": 
						{
							"card_decorator_extra_draw": {},
							"card_decorator_block_on_play": {}
						}
				}}
				]
			}
		}
	]
	rest_action_enchant_cards.rest_action_validators = [
		{
		# must have enough money
		Scripts.VALIDATOR_MONEY:
			{
				"money_amount": 25
			}
		},
		{
		# must have at least one card that can slot a decorator
		Scripts.VALIDATOR_DECK_HAS_DECORATABLE_CARD: 
			{
			"card_pick_type": HandManager.DECK,
			"card_decorator_ids": 
				[
					"card_decorator_extra_draw",
					"card_decorator_block_on_play"
				],
			"card_types": CardData.CARD_TYPES.values(),	# any card
			"invert_validation": false,
			}
		}
	]
	
	Global.register_rod(rest_action_enchant_cards)
	
	# add random consumable action
	var rest_action_add_random_consumable: RestActionData = RestActionData.new("rest_action_add_random_consumable")
	rest_action_add_random_consumable.rest_action_name = "Add Random\nConsumable"
	rest_action_add_random_consumable.rest_action_stat_name = "REST_GAIN_CONSUMABLE_COUNT"
	rest_action_add_random_consumable.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.EXCLUSIVE
	rest_action_add_random_consumable.rest_actions = [
		{Scripts.ACTION_ADD_CONSUMABLE: {"random_consumable": true}},
	]
	
	Global.register_rod(rest_action_add_random_consumable)
	
	# increase damage artifact action
	# paired with corresponding artifact
	var rest_action_increase_attack_on_rest: RestActionData = RestActionData.new("rest_action_increase_attack_on_rest")
	rest_action_increase_attack_on_rest.rest_action_name = "Increase Damage"
	rest_action_increase_attack_on_rest.rest_action_stat_name = "REST_INCREASE_DAMAGE_COUNT"
	rest_action_increase_attack_on_rest.rest_action_cost_type = RestActionData.REST_ACTION_COST_TYPES.EXCLUSIVE
	rest_action_increase_attack_on_rest.rest_actions = [
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE: {"artifact_id": "artifact_increase_attack_on_rest"}},
	]
	
	Global.register_rod(rest_action_increase_attack_on_rest)
	



#endregion

#region Status Effects
func add_status_effects() -> void:
	var status_effect_overshield: StatusEffectData = StatusEffectData.new("status_effect_overshield")
	status_effect_overshield.status_effect_name = "Overshield"
	status_effect_overshield.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_overshield.status_effect_decay_rate = -5
	status_effect_overshield.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_overshield.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_overshield.status_effect_interceptor_ids = ["interceptor_overshield"]
	status_effect_overshield.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.ZERO
	status_effect_overshield.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	
	Global.register_rod(status_effect_overshield)
	
	# Preserve Energy
	var status_effect_preserve_energy: StatusEffectData = StatusEffectData.new("status_effect_preserve_energy")
	status_effect_preserve_energy.status_effect_name = "Preserve Energy"
	status_effect_preserve_energy.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_preserve_energy.status_effect_charge_upper_bound = 1
	status_effect_preserve_energy.status_effect_is_visible = false
	status_effect_preserve_energy.status_effect_decay_rate = 0
	status_effect_preserve_energy.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_preserve_energy.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_preserve_energy.status_effect_interceptor_ids = ["interceptor_preserve_energy"]
	status_effect_preserve_energy.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.ZERO
	status_effect_preserve_energy.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_preserve_energy)
	
	var status_effect_preserve_overshield: StatusEffectData = StatusEffectData.new("status_effect_preserve_overshield")
	status_effect_preserve_overshield.status_effect_name = "Preserve Overshield"
	status_effect_preserve_overshield.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_preserve_overshield.status_effect_decay_rate = 0
	status_effect_preserve_overshield.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_preserve_overshield.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_preserve_overshield.status_effect_interceptor_ids = ["interceptor_preserve_overshield"]
	status_effect_preserve_overshield.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.ZERO
	status_effect_preserve_overshield.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_preserve_overshield)
	
	var status_effect_pointy: StatusEffectData = StatusEffectData.new("status_effect_pointy")
	status_effect_pointy.status_effect_name = "Pointy"
	status_effect_pointy.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_pointy.status_effect_decay_rate = 0
	status_effect_pointy.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_pointy.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_pointy.status_effect_interceptor_ids = ["interceptor_pointy"]
	status_effect_pointy.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.ZERO
	status_effect_pointy.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_pointy)
	
	# damages the player at the start of their turn and increases number of cards drawn
	var status_effect_pollen: StatusEffectData = StatusEffectData.new("status_effect_pollen")
	status_effect_pollen.status_effect_name = "Pollen"
	status_effect_pollen.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_pollen.status_effect_decay_rate = 0
	status_effect_pollen.status_effect_priority = 10
	status_effect_pollen.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_pollen.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_pollen.status_effect_interceptor_ids = []
	status_effect_pollen.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.ZERO
	status_effect_pollen.status_effect_action_process_times = [StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_DRAW_PLAYER_START_TURN]
	status_effect_pollen.status_effect_player_process_actions = [
		{
		Scripts.ACTION_DRAW_GENERATOR: {
			"custom_key_names": {
						# convert the secondary status charges, passed in from BaseStatusEffect, into card draw
						"draw_count": "invoking_status_effect_secondary_charges"
					},
			"time_delay": 0.0,
			"is_start_of_turn_draw": false,
			}
		},
		{
		Scripts.ACTION_DIRECT_DAMAGE: {
			"custom_key_names": {
						# convert the status charges, passed in from BaseStatusEffect, into poison damage
						"damage": "invoking_status_effect_charges"
					},
			"time_delay": 0.2,
			"bypass_block": true,
			"target_override": BaseAction.TARGET_OVERRIDES.PARENT
			}
		},
	]
	
	Global.register_rod(status_effect_pollen)
	
	# poison like effect
	# example of status effect that reserves health bar
	var status_effect_corrosion: StatusEffectData = StatusEffectData.new("status_effect_corrosion")
	status_effect_corrosion.status_effect_name = "Corrosion"
	status_effect_corrosion.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_corrosion.status_effect_decay_rate = -2
	# status_effect_corrosion.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.HALF_LIFE_ROUND_UP # uncomment to change to half life decay
	status_effect_corrosion.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.DEBUFF
	status_effect_corrosion.status_effect_interceptor_ids = []
	status_effect_corrosion.status_effect_healthbar_layer_color = Color.DARK_GREEN.to_html(false)
	status_effect_corrosion.status_effect_healthbar_reserve_type = StatusEffectData.STATUS_EFFECT_HEALTHBAR_RESERVE_TYPES.STATUS_CHARGES
	status_effect_corrosion.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DISCARD_PLAYER_END_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_ENEMY_TURN,
	]
	status_effect_corrosion.status_effect_player_process_actions = [
		{
		Scripts.ACTION_DIRECT_DAMAGE: {
			"custom_key_names": {
						# convert the status charges, passed in from BaseStatusEffect, into poison damage
						"damage": "invoking_status_effect_charges"
					},
			"time_delay": 0.5,
			"bypass_block": true,
			"target_override": BaseAction.TARGET_OVERRIDES.PARENT
			}
		}
	]
	status_effect_corrosion.status_effect_enemy_process_actions = status_effect_corrosion.status_effect_player_process_actions.duplicate()
	
	Global.register_rod(status_effect_corrosion)
	
	# status effect that grants overheat each turn
	var status_effect_critical: StatusEffectData = StatusEffectData.new("status_effect_critical")
	status_effect_critical.status_effect_name = "Critical"
	status_effect_critical.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_critical.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_critical.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_critical.status_effect_charge_upper_bound = 100
	status_effect_critical.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_ENEMY_INTENT,
	]
	status_effect_critical.status_effect_player_process_actions = [
		{
				Scripts.ACTION_APPLY_STATUS: {
					"custom_key_names": {
						"status_charge_amount": "invoking_status_effect_charges"
					},
					"time_delay": 0.1,
					"status_effect_object_id": "status_effect_overheat",
					"target_override": BaseAction.TARGET_OVERRIDES.PARENT
					}
				}
	]
	status_effect_critical.status_effect_enemy_process_actions = []
	status_effect_critical.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_critical)
	
	# status effect that damages all combatants when overflowed
	var status_effect_overheat: StatusEffectData = StatusEffectData.new("status_effect_overheat")
	status_effect_overheat.status_effect_name = "Overheat"
	status_effect_overheat.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_overheat.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.HALF_LIFE_ROUND_UP
	status_effect_overheat.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_overheat.status_effect_charge_upper_bound = 10
	status_effect_overheat.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_overheat.status_effect_charge_overflows = true
	status_effect_overheat.status_effect_player_flow_actions = [
		{
			Scripts.ACTION_EMIT_CUSTOM_SIGNAL: {
				"custom_signal_object_id": "custom_signal_overheated",
				"custom_signal_value": 1,
			}
		},
		{
			Scripts.ACTION_DIRECT_DAMAGE: {
				"damage": 10,
				"bypass_block": false,
				"time_delay": 0.5,
				"target_override": BaseAction.TARGET_OVERRIDES.ALL_COMBATANTS,
			}
		}
	]
	status_effect_overheat.status_effect_enemy_process_actions = []
	status_effect_overheat.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_overheat)
	
	# grants energy on overheat
	var status_effect_feedback_loop: StatusEffectData = StatusEffectData.new("status_effect_feedback_loop")
	status_effect_feedback_loop.status_effect_name = "Feedback Loop"
	status_effect_feedback_loop.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_feedback_loop.status_effect_script_path = "res://scripts/status_effects/StatusEffectFeedbackLoop.gd"
	status_effect_feedback_loop.status_effect_decay_rate = 0
	status_effect_feedback_loop.status_effect_allows_multiples = false
	status_effect_feedback_loop.status_effect_action_process_times = [] # does not process or decay normally. See status script
	status_effect_feedback_loop.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_feedback_loop.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_feedback_loop)
	
	# bomb effect that counts down and damages all enemies
	# uses unique status logic
	var status_effect_bomb: StatusEffectData = StatusEffectData.new("status_effect_bomb")
	status_effect_bomb.status_effect_name = "Bomb"
	status_effect_bomb.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_bomb.status_effect_script_path = "res://scripts/status_effects/StatusEffectBomb.gd"
	status_effect_bomb.status_effect_decay_rate = -1
	status_effect_bomb.status_effect_allows_multiples = true
	status_effect_bomb.status_effect_secondary_charge_collision_strategy = StatusEffectData.STATUS_EFFECT_SECONDARY_CHARGE_COLLISION_STRATEGIES.KEEP
	status_effect_bomb.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DISCARD_PLAYER_END_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_bomb.status_effect_player_process_actions = [
				{
				Scripts.ACTION_DIRECT_DAMAGE: {
					"custom_key_names": {
						# convert the bomb's status secondary charges, passed in from BaseStatusEffect, into bomb damage
						"damage": "invoking_status_effect_secondary_charges"
					},
					"bypass_block": false,
					"time_delay": 0.5,
					"target_override": BaseAction.TARGET_OVERRIDES.ALL_ENEMIES # player bombs hit all enemies
					}
				}
			]
	status_effect_bomb.status_effect_enemy_process_actions = [
				{
				Scripts.ACTION_DIRECT_DAMAGE: {
					"custom_key_names": {
						# convert the bomb's status secondary charges, passed in from BaseStatusEffect, into bomb damage
						"damage": "invoking_status_effect_secondary_charges"
					},
					"bypass_block": false,
					"time_delay": 0.5,
					"target_override": BaseAction.TARGET_OVERRIDES.PLAYER # enemy bombs hit player
					}
				}
			]
	status_effect_bomb.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_bomb.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_bomb)
	
	# increases attack damage by charge amount
	# uses an interceptor
	var status_effect_damage_increase: StatusEffectData = StatusEffectData.new("status_effect_damage_increase")
	status_effect_damage_increase.status_effect_name = "Damage Increase"
	status_effect_damage_increase.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_damage_increase.status_effect_decay_rate = 0
	status_effect_damage_increase.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_damage_increase.status_effect_interceptor_ids = ["interceptor_damage_increase"]
	
	Global.register_rod(status_effect_damage_increase)
	
	# decreases damage done by attackers
	# uses an interceptor
	var status_effect_weaken: StatusEffectData = StatusEffectData.new("status_effect_weaken")
	status_effect_weaken.status_effect_name = "Weaken"
	status_effect_weaken.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_weaken.status_effect_decay_rate = -1
	status_effect_weaken.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.DEBUFF
	status_effect_weaken.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DISCARD_PLAYER_END_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_weaken.status_effect_interceptor_ids = ["interceptor_weaken"]
	
	Global.register_rod(status_effect_weaken)
	
	# increases attack damage on attacked combatant
	# uses an interceptor
	var status_effect_vulnerable: StatusEffectData = StatusEffectData.new("status_effect_vulnerable")
	status_effect_vulnerable.status_effect_name = "Vulnerable"
	status_effect_vulnerable.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_vulnerable.status_effect_decay_rate = -1
	status_effect_vulnerable.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.DEBUFF
	status_effect_weaken.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_vulnerable.status_effect_interceptor_ids = ["interceptor_vulnerable"]
	
	Global.register_rod(status_effect_vulnerable)
	
	# gain block at the end of the turn
	# doesn't use an interceptor
	var status_effect_block_on_turn_end: StatusEffectData = StatusEffectData.new("status_effect_block_on_turn_end")
	status_effect_block_on_turn_end.status_effect_name = "Block On Turn End"
	status_effect_block_on_turn_end.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_block_on_turn_end.status_effect_decay_rate = 0
	status_effect_block_on_turn_end.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_block_on_turn_end.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_DISCARD_PLAYER_END_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_block_on_turn_end.status_effect_player_process_actions = [
		{
			Scripts.ACTION_BLOCK: {
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT,
				"custom_key_names": {"block": "invoking_status_effect_charges"},
				"time_delay": 0.5,
			}
		}
	]
	status_effect_block_on_turn_end.status_effect_enemy_process_actions = [
		{
			Scripts.ACTION_BLOCK: {
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT,
				"custom_key_names": {"block": "invoking_status_effect_charges"},
				"time_delay": 0.5,
			}
		}
	]
	status_effect_block_on_turn_end.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_block_on_turn_end)
	
	# gain energy at the start of next turn
	# doesn't use an interceptor
	var status_effect_energy_next_turn: StatusEffectData = StatusEffectData.new("status_effect_energy_next_turn")
	status_effect_energy_next_turn.status_effect_name = "Energy Next Turn"
	status_effect_energy_next_turn.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_energy_next_turn.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.ZERO_OUT
	status_effect_energy_next_turn.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_energy_next_turn.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT,
	]
	status_effect_energy_next_turn.status_effect_player_process_actions = [
		{
			Scripts.ACTION_ADD_ENERGY: {
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT,
				"custom_key_names": {"energy_amount": "invoking_status_effect_charges"},
				"time_delay": 0.5,
			}
		}
	]
	status_effect_energy_next_turn.status_effect_enemy_process_actions = []
	status_effect_energy_next_turn.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_energy_next_turn)
	
	# draws extra cards next turn
	# uses an interceptor
	# this status does not decay naturally. It is removed after turn draw
	var status_effect_increase_turn_draw: StatusEffectData = StatusEffectData.new("status_effect_increase_turn_draw")
	status_effect_increase_turn_draw.status_effect_name = "Increase Draw"
	status_effect_increase_turn_draw.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_increase_turn_draw.status_effect_decay_rate = 0
	status_effect_increase_turn_draw.status_effect_allows_multiples = false
	status_effect_increase_turn_draw.status_effect_charge_upper_bound = 10
	status_effect_increase_turn_draw.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_increase_turn_draw.status_effect_action_process_times = []
	status_effect_increase_turn_draw.status_effect_interceptor_ids = ["interceptor_increase_turn_draw"]
	
	Global.register_rod(status_effect_increase_turn_draw)
	
	# status that binds a card to an enemy, adding it to the player's hand when killed
	var status_effect_attached_card: StatusEffectData = StatusEffectData.new("status_effect_attached_card")
	status_effect_attached_card.status_effect_name = "Attached Card"
	status_effect_attached_card.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_attached_card.status_effect_script_path = "res://scripts/status_effects/StatusEffectAttachedCard.gd"
	status_effect_attached_card.status_effect_decay_rate = 0
	status_effect_attached_card.status_effect_allows_multiples = true
	status_effect_attached_card.status_effect_charge_upper_bound = 1
	status_effect_attached_card.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.NEUTRAL
	status_effect_attached_card.status_effect_interceptor_ids = []
	
	Global.register_rod(status_effect_attached_card)
	
	# uses an interceptor to stop an attack from processing
	var status_effect_negate_damage: StatusEffectData = StatusEffectData.new("status_effect_negate_damage")
	status_effect_negate_damage.status_effect_name = "Negate Damage"
	status_effect_negate_damage.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_negate_damage.status_effect_decay_rate = 0
	status_effect_negate_damage.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_negate_damage.status_effect_interceptor_ids = ["interceptor_negate_damage"]
	
	Global.register_rod(status_effect_negate_damage)
	
	# uses an interceptor to cap incoming damage
	var status_effect_cap_damage: StatusEffectData = StatusEffectData.new("status_effect_cap_damage")
	status_effect_cap_damage.status_effect_name = "Cap Damage"
	status_effect_cap_damage.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_cap_damage.status_effect_decay_rate = -1
	status_effect_cap_damage.status_effect_allows_multiples = false
	status_effect_cap_damage.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_cap_damage.status_effect_secondary_charge_collision_strategy = StatusEffectData.STATUS_EFFECT_SECONDARY_CHARGE_COLLISION_STRATEGIES.KEEP
	status_effect_cap_damage.status_effect_interceptor_ids = ["interceptor_cap_damage"]
	
	Global.register_rod(status_effect_cap_damage)
	
	# uses an interceptor to prevent block from resetting
	var status_effect_temp_preserve_block: StatusEffectData = StatusEffectData.new("status_effect_temp_preserve_block")
	status_effect_temp_preserve_block.status_effect_name = "Temp Preserve Block"
	status_effect_temp_preserve_block.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_temp_preserve_block.status_effect_decay_rate = -1
	status_effect_temp_preserve_block.status_effect_interceptor_ids = ["interceptor_temp_preserve_block"]
	
	Global.register_rod(status_effect_temp_preserve_block)
	
	# uses an interceptor to prevent block from resetting
	var status_effect_preserve_block: StatusEffectData = StatusEffectData.new("status_effect_preserve_block")
	status_effect_preserve_block.status_effect_name = "Preserve Block"
	status_effect_preserve_block.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_preserve_block.status_effect_decay_rate = 0
	status_effect_preserve_block.status_effect_charge_upper_bound = 1
	status_effect_preserve_block.status_effect_interceptor_ids = ["interceptor_preserve_block"]
	
	Global.register_rod(status_effect_preserve_block)
	
	# uses an interceptor to stop a debuff from happening
	var status_effect_negate_debuff: StatusEffectData = StatusEffectData.new("status_effect_negate_debuff")
	status_effect_negate_debuff.status_effect_name = "Negate Debuff"
	status_effect_negate_debuff.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_negate_debuff.status_effect_decay_rate = 0
	status_effect_negate_debuff.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.NEUTRAL
	status_effect_negate_debuff.status_effect_interceptor_ids = ["interceptor_negate_debuff"]
	
	Global.register_rod(status_effect_negate_debuff)
	
	# uses an interceptor to rebound card plays to draw pile
	var status_effect_rebound_card_plays: StatusEffectData = StatusEffectData.new("status_effect_rebound_card_plays")
	status_effect_rebound_card_plays.status_effect_name = "Rebound Play"
	status_effect_rebound_card_plays.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_rebound_card_plays.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.ZERO_OUT
	status_effect_rebound_card_plays.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_rebound_card_plays.status_effect_action_process_times = [
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_DISCARD_PLAYER_END_TURN,
		StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_ENEMY_TURN,
	]
	status_effect_rebound_card_plays.status_effect_interceptor_ids = ["interceptor_rebound_card_plays"]
	
	Global.register_rod(status_effect_rebound_card_plays)
	
	# rebounds incoming card plays to the draw pile
	var interceptor_rebound_card_plays: ActionInterceptorData = ActionInterceptorData.new("interceptor_rebound_card_plays")
	interceptor_rebound_card_plays.action_interceptor_priority = 10000
	interceptor_rebound_card_plays.action_interceptor_modifies_parent = true
	interceptor_rebound_card_plays.action_interceptor_script_path = Scripts.INTERCEPTOR_REBOUND_CARD_PLAYS
	interceptor_rebound_card_plays.action_intercepted_action_paths = [Scripts.ACTION_CARD_PLAY]
	
	Global.register_rod(interceptor_rebound_card_plays)
	
	# uses an interceptor to duplicate the first card play each turn
	var status_effect_duplicate_card_plays: StatusEffectData = StatusEffectData.new("status_effect_duplicate_card_plays")
	status_effect_duplicate_card_plays.status_effect_name = "Duplicate Play"
	status_effect_duplicate_card_plays.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_duplicate_card_plays.status_effect_script_path = "res://scripts/status_effects/StatusEffectDuplicateCardPlays.gd"
	status_effect_duplicate_card_plays.status_effect_decay_rate = 0
	status_effect_duplicate_card_plays.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_duplicate_card_plays.status_effect_interceptor_ids = ["interceptor_duplicate_card_plays"]
	
	Global.register_rod(status_effect_duplicate_card_plays)

	# uses an interceptor to duplicate attack card plays
	var status_effect_duplicate_attacks: StatusEffectData = StatusEffectData.new("status_effect_duplicate_attacks")
	status_effect_duplicate_attacks.status_effect_name = "Duplicate Play"
	status_effect_duplicate_attacks.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_duplicate_attacks.status_effect_decay_rate = -999
	status_effect_duplicate_attacks.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_duplicate_attacks.status_effect_interceptor_ids = ["interceptor_duplicate_attacks"]
	
	Global.register_rod(status_effect_duplicate_attacks)
	
	# uses an interceptor to duplicate attack card plays
	var status_effect_block_on_special_discard: StatusEffectData = StatusEffectData.new("status_effect_block_on_special_discard")
	status_effect_block_on_special_discard.status_effect_name = "Block on Special Discard"
	status_effect_block_on_special_discard.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_block_on_special_discard.status_effect_decay_rate = 0
	status_effect_block_on_special_discard.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_block_on_special_discard.status_effect_interceptor_ids = ["interceptor_duplicate_attacks"]
	
	Global.register_rod(status_effect_block_on_special_discard)

#endregion

#region Acts
func add_acts() -> void:
	var act_1: ActData = ActData.new("act_1")
	act_1.act_name = "Act 1"
	act_1.act_easy_combat_event_pool_object_id = "event_pool_act_1_easy"
	act_1.act_hard_combat_event_pool_object_id = "event_pool_act_1_hard"
	act_1.act_easy_plains_event_pool_object_id = "event_pool_act_1_plains_easy"
	act_1.act_easy_forest_event_pool_object_id = "event_pool_act_1_forest_easy"
	act_1.act_easy_desert_event_pool_object_id = "event_pool_act_1_desert_easy"
	act_1.act_easy_coast_event_pool_object_id = "event_pool_act_1_coast_easy"
	act_1.act_easy_swamp_event_pool_object_id = "event_pool_act_1_swamp_easy"
	act_1.act_hard_plains_event_pool_object_id = "event_pool_act_1_plains_hard"
	act_1.act_hard_forest_event_pool_object_id = "event_pool_act_1_forest_hard"
	act_1.act_hard_desert_event_pool_object_id = "event_pool_act_1_desert_hard"
	act_1.act_hard_coast_event_pool_object_id = "event_pool_act_1_coast_hard"
	act_1.act_hard_swamp_event_pool_object_id = "event_pool_act_1_swamp_hard"
	act_1.act_boss_event_pool_object_id = "event_pool_act_1_boss"
	Global.register_rod(act_1)
#endregion
	
#region Events and Event Pools
func add_events() -> void:
	## Plains
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_plains_1: EventData = EventData.new("event_act_1_easy_plains_1")
	event_act_1_easy_plains_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_plains_1.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"mound": 1},
		]
	
	Global.register_rod(event_act_1_easy_plains_1)
	
	var event_act_1_easy_plains_2: EventData = EventData.new("event_act_1_easy_plains_2")
	event_act_1_easy_plains_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_plains_2.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"pond": 1},
		]
	
	Global.register_rod(event_act_1_easy_plains_2)
	
	var event_act_1_easy_plains_3: EventData = EventData.new("event_act_1_easy_plains_3")
	event_act_1_easy_plains_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_plains_3.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"pond": 1},
		{"mound": 1},
		]
	
	Global.register_rod(event_act_1_easy_plains_3)
	
	var event_act_1_hard_plains_1: EventData = EventData.new("event_act_1_hard_plains_1")
	event_act_1_hard_plains_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_1.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"pond": 1},
		]
	
	Global.register_rod(event_act_1_hard_plains_1)
	
	var event_act_1_hard_plains_2: EventData = EventData.new("event_act_1_hard_plains_2")
	event_act_1_hard_plains_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_2.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"rock": 1},
		]
	
	Global.register_rod(event_act_1_hard_plains_2)
	
	var event_act_1_hard_plains_3: EventData = EventData.new("event_act_1_hard_plains_3")
	event_act_1_hard_plains_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_3.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"field_patch": 1},
		{"field_patch": 1},
		]
	
	Global.register_rod(event_act_1_hard_plains_3)
	
		## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_desert_1: EventData = EventData.new("event_act_1_easy_desert_1")
	event_act_1_easy_desert_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_1.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder": 1},
		]
	
	Global.register_rod(event_act_1_easy_desert_1)
	
	var event_act_1_easy_desert_2: EventData = EventData.new("event_act_1_easy_desert_2")
	event_act_1_easy_desert_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_2.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"boulder": 1},
		]
	
	Global.register_rod(event_act_1_easy_desert_2)
	
	var event_act_1_easy_desert_3: EventData = EventData.new("event_act_1_easy_desert_3")
	event_act_1_easy_desert_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_3.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"mound": 1},
		]
	
	Global.register_rod(event_act_1_easy_desert_3)
	
	var event_act_1_hard_desert_1: EventData = EventData.new("event_act_1_hard_desert_1")
	event_act_1_hard_desert_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_1.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		]
	
	Global.register_rod(event_act_1_hard_desert_1)
	
	var event_act_1_hard_desert_2: EventData = EventData.new("event_act_1_hard_desert_2")
	event_act_1_hard_desert_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_2.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"boulder": 1},
		]
	
	Global.register_rod(event_act_1_hard_plains_2)
	
	var event_act_1_hard_desert_3: EventData = EventData.new("event_act_1_hard_desert_3")
	event_act_1_hard_desert_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_3.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder": 1},
		]
	
	Global.register_rod(event_act_1_hard_desert_3)
	
	## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_forest_1: EventData = EventData.new("event_act_1_easy_forest_1")
	event_act_1_easy_forest_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_1.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"den": 1},
		]
	
	Global.register_rod(event_act_1_easy_forest_1)
	
	var event_act_1_easy_forest_2: EventData = EventData.new("event_act_1_easy_forest_2")
	event_act_1_easy_forest_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_2.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"hideout": 1},
		]
	
	Global.register_rod(event_act_1_easy_forest_2)
	
	var event_act_1_easy_forest_3: EventData = EventData.new("event_act_1_easy_forest_3")
	event_act_1_easy_forest_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_3.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"forestfloor": 1},
		]
	
	Global.register_rod(event_act_1_easy_forest_3)
	
	var event_act_1_hard_forest_1: EventData = EventData.new("event_act_1_hard_forest_1")
	event_act_1_hard_forest_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_1.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"den": 1},
		{"hideout": 1},
		]
	
	Global.register_rod(event_act_1_hard_forest_1)
	
	var event_act_1_hard_forest_2: EventData = EventData.new("event_act_1_hard_forest_2")
	event_act_1_hard_forest_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_2.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"forestfloor": 1},
		]
	
	Global.register_rod(event_act_1_hard_forest_2)
	
	var event_act_1_hard_forest_3: EventData = EventData.new("event_act_1_hard_forest_3")
	event_act_1_hard_forest_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_3.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"den": 1},
		]
	
	Global.register_rod(event_act_1_hard_forest_3)
	
	## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_coast_1: EventData = EventData.new("event_act_1_easy_coast_1")
	event_act_1_easy_coast_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_coast_1.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"shore": 1},
		{"cave": 1},
		]
	
	Global.register_rod(event_act_1_easy_coast_1)
	
	var event_act_1_easy_coast_2: EventData = EventData.new("event_act_1_easy_coast_2")
	event_act_1_easy_coast_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_coast_2.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"shore": 1},
		{"sandbed": 1},
		]
	
	Global.register_rod(event_act_1_easy_coast_2)
	
	var event_act_1_easy_coast_3: EventData = EventData.new("event_act_1_easy_coast_3")
	event_act_1_easy_coast_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_coast_3.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"shore": 1},
		{"shore": 1},
		]
	
	Global.register_rod(event_act_1_easy_coast_3)
	
	var event_act_1_hard_coast_1: EventData = EventData.new("event_act_1_hard_coast_1")
	event_act_1_hard_coast_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_coast_1.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"cave": 1},
		{"sandbed": 1},
		]
	
	Global.register_rod(event_act_1_hard_coast_1)
	
	var event_act_1_hard_coast_2: EventData = EventData.new("event_act_1_hard_coast_2")
	event_act_1_hard_coast_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_coast_2.event_weighted_enemy_object_ids = [
		{"cave": 1},
		{"shore": 1},
		{"shore": 1},
		]
	
	Global.register_rod(event_act_1_hard_coast_2)
	
	var event_act_1_hard_coast_3: EventData = EventData.new("event_act_1_hard_coast_3")
	event_act_1_hard_coast_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_coast_3.event_weighted_enemy_object_ids = [
		{"sandbed": 1},
		{"sandbed": 1},
		{"shore": 1},
		]
	
	Global.register_rod(event_act_1_hard_coast_3)
	
	## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_swamp_1: EventData = EventData.new("event_act_1_easy_swamp_1")
	event_act_1_easy_swamp_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_swamp_1.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"dryfield": 1},
		]
	
	Global.register_rod(event_act_1_easy_swamp_1)
	
	var event_act_1_easy_swamp_2: EventData = EventData.new("event_act_1_easy_swamp_2")
	event_act_1_easy_swamp_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_swamp_2.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"hut": 1},
		]
	
	Global.register_rod(event_act_1_easy_swamp_2)
	
	var event_act_1_easy_swamp_3: EventData = EventData.new("event_act_1_easy_swamp_3")
	event_act_1_easy_swamp_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_swamp_3.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"dryfield": 1},
		]
	
	Global.register_rod(event_act_1_easy_swamp_3)
	
	var event_act_1_hard_swamp_1: EventData = EventData.new("event_act_1_hard_swamp_1")
	event_act_1_hard_swamp_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_1.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"dryfield": 1},
		]
	
	Global.register_rod(event_act_1_hard_swamp_1)
	
	var event_act_1_hard_swamp_2: EventData = EventData.new("event_act_1_hard_swamp_2")
	event_act_1_hard_swamp_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_2.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"hut": 1},
		]
	
	Global.register_rod(event_act_1_hard_swamp_2)
	
	var event_act_1_hard_swamp_3: EventData = EventData.new("event_act_1_hard_swamp_3")
	event_act_1_hard_swamp_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_3.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"hut": 1},
		]
	
	Global.register_rod(event_act_1_hard_swamp_3)
	
	## Act 1 Dialogue Events
	# see add_test_dialogue()
	
	var event_pick_something: EventData = EventData.new("event_pick_something")
	event_pick_something.event_dialogue_object_id = "dialogue_pick_something"
	
	Global.register_rod(event_pick_something)
	
	
	### Event Pools
	# act 1 easy pool
	var event_pool_act_1_easy_plains: EventPoolData = EventPoolData.new("event_pool_act_1_plains_easy")
	event_pool_act_1_easy_plains.add_events_to_pool(
		event_act_1_easy_plains_1,
		[
		event_act_1_easy_plains_1,
		event_act_1_easy_plains_2,
		event_act_1_easy_plains_3,
		])
	Global.register_rod(event_pool_act_1_easy_plains)
	
	var event_pool_act_1_hard_plains: EventPoolData = EventPoolData.new("event_pool_act_1_plains_hard")
	event_pool_act_1_hard_plains.add_events_to_pool(
		event_act_1_hard_plains_1,
		[
		event_act_1_hard_plains_1,
		event_act_1_hard_plains_2,
		event_act_1_hard_plains_3,
		])
		
	Global.register_rod(event_pool_act_1_hard_plains)
	
	var event_pool_act_1_easy_forest: EventPoolData = EventPoolData.new("event_pool_act_1_forest_easy")
	event_pool_act_1_easy_forest.add_events_to_pool(
		event_act_1_easy_forest_1,
		[
		event_act_1_easy_forest_1,
		event_act_1_easy_forest_2,
		event_act_1_easy_forest_3,
		])
	Global.register_rod(event_pool_act_1_easy_forest)
	
	var event_pool_act_1_hard_forest: EventPoolData = EventPoolData.new("event_pool_act_1_forest_hard")
	event_pool_act_1_hard_forest.add_events_to_pool(
		event_act_1_hard_forest_1,
		[
		event_act_1_hard_forest_1,
		event_act_1_hard_forest_2,
		event_act_1_hard_forest_3,
		])
		
	Global.register_rod(event_pool_act_1_hard_forest)
	
	var event_pool_act_1_easy_desert: EventPoolData = EventPoolData.new("event_pool_act_1_desert_easy")
	event_pool_act_1_easy_desert.add_events_to_pool(
		event_act_1_easy_desert_1,
		[
		event_act_1_easy_desert_1,
		event_act_1_easy_desert_2,
		event_act_1_easy_desert_3,
		])
	Global.register_rod(event_pool_act_1_easy_desert)
	
	var event_pool_act_1_hard_desert: EventPoolData = EventPoolData.new("event_pool_act_1_desert_hard")
	event_pool_act_1_hard_desert.add_events_to_pool(
		event_act_1_hard_desert_1,
		[
		event_act_1_hard_desert_1,
		event_act_1_hard_desert_2,
		event_act_1_hard_desert_3,
		])
		
	Global.register_rod(event_pool_act_1_hard_desert)

	var event_pool_act_1_easy_coast: EventPoolData = EventPoolData.new("event_pool_act_1_coast_easy")
	event_pool_act_1_easy_coast.add_events_to_pool(
		event_act_1_easy_coast_1,
		[
		event_act_1_easy_coast_1,
		event_act_1_easy_coast_2,
		event_act_1_easy_coast_3,
		])
	Global.register_rod(event_pool_act_1_easy_coast)
	
	var event_pool_act_1_hard_coast: EventPoolData = EventPoolData.new("event_pool_act_1_coast_hard")
	event_pool_act_1_hard_coast.add_events_to_pool(
		event_act_1_hard_coast_1,
		[
		event_act_1_hard_coast_1,
		event_act_1_hard_coast_2,
		event_act_1_hard_coast_3,
		])
		
	Global.register_rod(event_pool_act_1_hard_coast)

	var event_pool_act_1_easy_swamp: EventPoolData = EventPoolData.new("event_pool_act_1_swamp_easy")
	event_pool_act_1_easy_swamp.add_events_to_pool(
		event_act_1_easy_swamp_1,
		[
		event_act_1_easy_swamp_1,
		event_act_1_easy_swamp_2,
		event_act_1_easy_swamp_3,
		])
	Global.register_rod(event_pool_act_1_easy_swamp)
	
	var event_pool_act_1_hard_swamp: EventPoolData = EventPoolData.new("event_pool_act_1_swamp_hard")
	event_pool_act_1_hard_swamp.add_events_to_pool(
		event_act_1_hard_swamp_1,
		[
		event_act_1_hard_swamp_1,
		event_act_1_hard_swamp_2,
		event_act_1_hard_swamp_3,
		])
		
	Global.register_rod(event_pool_act_1_hard_swamp)
	
	var event_act_1_boss_1: EventData = EventData.new("event_act_1_boss_1")
	event_act_1_boss_1.event_weighted_enemy_object_ids = [
		{"enemy_act_1_boss_1": 1},
		]
	event_act_1_boss_1.event_enemy_placement_is_automatic = false
	event_act_1_boss_1.event_enemy_placement_positions = [[0,0], [180,0], [360,0]]
	event_act_1_boss_1.event_death_message_bbcode = "Bosses are tough"
	
	Global.register_rod(event_act_1_boss_1)
#endregion

#region Dialogue

## Adds test DialogueData, and their embedded DialogueStateData and DialogueOptionData payloads
func add_dialogue() -> void:
	### Dialogue Event 1
	# Dialogue 1
	var dialogue_pick_something: DialogueData = DialogueData.new("dialogue_pick_something")
	dialogue_pick_something.dialogue_name_bbcode = "[wave amp=50.0 freq=2.0 connected=1][color=green]Pick something[/color][/wave]"
	Global.register_rod(dialogue_pick_something)
	
	# Option 1
	var dialogue_pick_something_option_1: DialogueOptionData = DialogueOptionData.new("dialogue_pick_something_option_1")
	dialogue_pick_something_option_1.dialogue_option_bbcode = "[color=red]Lose 10 HP[/color] and [color=green]Gain 100 Money[/color]"
	dialogue_pick_something_option_1.dialogue_option_failed_validator_bbcode = "[color=grey][Locked]: Insufficient Health[/color]"
	dialogue_pick_something_option_1.dialogue_option_actions = [
		{Scripts.ACTION_ADD_HEALTH: {"target_override": BaseAction.TARGET_OVERRIDES.PLAYER, "health_amount": -10}},
		{Scripts.ACTION_ADD_MONEY: {"money_amount": 100}},
		]
	dialogue_pick_something_option_1.dialogue_option_validators = [
		{Scripts.VALIDATOR_PLAYER_HEALTH: {"health_amount": 11}},
	]
	dialogue_pick_something_option_1.dialogue_option_next_dialogue_state_id = "" # empty ends dialogue
	
	dialogue_pick_something._assign_option(dialogue_pick_something_option_1)
	
	# Option 2
	var dialogue_pick_something_option_2: DialogueOptionData = DialogueOptionData.new("dialogue_pick_something_option_2")
	dialogue_pick_something_option_2.dialogue_option_bbcode = "[color=red]Lose 50 Money[/color] and [color=green]Gain Random Rare Card[/color]"
	dialogue_pick_something_option_2.dialogue_option_failed_validator_bbcode = "[color=grey][Locked]: Insufficient Money[/color]"
	dialogue_pick_something_option_2.dialogue_option_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			"pick_draft_cards": false,
			"draft_from_card_pool": true,
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			"validator_data": [
				{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.RARE]}},
				{Scripts.VALIDATOR_CARD_DRAFTABLE: {}},
			],
			"rng_name": "rng_events",
			"draft_use_player_draft": false, # this should always be false if using a validator based draft
			"draft_is_weighted": false,
			"draft_use_pity_system": false,
			"random_selection": true, # auto pick it
			"draft_max_card_amount": 1, # auto pick it
			"min_card_amount": 1,
			"max_card_amount": 1,
			}
		},
		{Scripts.ACTION_ADD_MONEY: {"money_amount": -50}},
	]
	dialogue_pick_something_option_2.dialogue_option_validators = [
		{Scripts.VALIDATOR_MONEY: {"money_amount": 50}},
	]
	dialogue_pick_something_option_2.dialogue_option_next_dialogue_state_id = "" # empty ends dialogue
	
	dialogue_pick_something._assign_option(dialogue_pick_something_option_2)
	
	# State 1
	var dialogue_state_pick_something_initial: DialogueStateData = DialogueStateData.new("dialogue_state_pick_something_initial")
	dialogue_state_pick_something_initial.dialogue_state_prompt_bbcode = "Test Event. Select an option..."
	dialogue_state_pick_something_initial.dialogue_state_dialogue_texture_path = "external/sprites/events/event_pick_something.png"
	dialogue_state_pick_something_initial.dialogue_state_dialogue_option_object_ids = [
		dialogue_pick_something_option_1.object_id,
		dialogue_pick_something_option_2.object_id,
	]
	
	dialogue_pick_something._assign_state(dialogue_state_pick_something_initial)
	dialogue_pick_something._assign_initial_state(dialogue_state_pick_something_initial)

#endregion

#region Action Interceptors
func add_action_interceptors() -> void:
	# increases damage done by attackers
	var interceptor_damage_increase: ActionInterceptorData = ActionInterceptorData.new("interceptor_damage_increase")
	interceptor_damage_increase.action_interceptor_priority = 10000
	interceptor_damage_increase.action_interceptor_modifies_parent = true
	interceptor_damage_increase.action_interceptor_script_path = Scripts.INTERCEPTOR_DAMAGE_INCREASE
	interceptor_damage_increase.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_damage_increase)
	
	# decreases damage done by attackers
	var interceptor_weaken: ActionInterceptorData = ActionInterceptorData.new("interceptor_weaken")
	interceptor_weaken.action_interceptor_priority = 9500
	interceptor_weaken.action_interceptor_modifies_parent = true
	interceptor_weaken.action_interceptor_script_path = Scripts.INTERCEPTOR_WEAKEN
	interceptor_weaken.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_weaken)
	
	# increases damage done to the attacked
	var interceptor_vulnerable: ActionInterceptorData = ActionInterceptorData.new("interceptor_vulnerable")
	interceptor_vulnerable.action_interceptor_priority = 9000
	interceptor_vulnerable.action_interceptor_modifies_parent = false
	interceptor_vulnerable.action_interceptor_script_path = Scripts.INTERCEPTOR_VULNERABLE
	interceptor_vulnerable.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_vulnerable)
	
	# increases number of cards drawn
	var interceptor_increase_turn_draw: ActionInterceptorData = ActionInterceptorData.new("interceptor_increase_turn_draw")
	interceptor_increase_turn_draw.action_interceptor_priority = 9000
	interceptor_increase_turn_draw.action_interceptor_modifies_parent = true
	interceptor_increase_turn_draw.action_interceptor_script_path = Scripts.INTERCEPTOR_INCREASE_TURN_DRAW
	interceptor_increase_turn_draw.action_intercepted_action_paths = [Scripts.ACTION_DRAW_GENERATOR]
	
	Global.register_rod(interceptor_increase_turn_draw)
	
	# provides extra health
	var interceptor_overshield: ActionInterceptorData = ActionInterceptorData.new("interceptor_overshield")
	interceptor_overshield.action_interceptor_priority = 8000
	interceptor_overshield.action_interceptor_modifies_parent = false
	interceptor_overshield.action_interceptor_script_path = Scripts.INTERCEPTOR_OVERSHIELD
	interceptor_overshield.action_intercepted_action_paths = [Scripts.ACTION_ATTACK, Scripts.ACTION_DIRECT_DAMAGE]
	
	Global.register_rod(interceptor_overshield)
	
	# prevents energy from reseting
	var interceptor_preserve_energy: ActionInterceptorData = ActionInterceptorData.new("interceptor_preserve_energy")
	interceptor_preserve_energy.action_interceptor_priority = 10000
	interceptor_preserve_energy.action_interceptor_modifies_parent = true
	interceptor_preserve_energy.action_interceptor_script_path = Scripts.INTERCEPTOR_PRESERVE_ENERGY
	interceptor_preserve_energy.action_intercepted_action_paths = [Scripts.ACTION_RESET_ENERGY]
	
	Global.register_rod(interceptor_preserve_energy)
	
	# prevents overshield from decaying
	var interceptor_preserve_overshield: ActionInterceptorData = ActionInterceptorData.new("interceptor_preserve_overshield")
	interceptor_preserve_overshield.action_interceptor_priority = 10000
	interceptor_preserve_overshield.action_interceptor_modifies_parent = false
	interceptor_preserve_overshield.action_interceptor_script_path = Scripts.INTERCEPTOR_PRESERVE_OVERSHIELD
	interceptor_preserve_overshield.action_intercepted_action_paths = [Scripts.ACTION_DECAY_STATUS]
	
	Global.register_rod(interceptor_preserve_overshield)
	
	# damages attackers
	var interceptor_pointy: ActionInterceptorData = ActionInterceptorData.new("interceptor_pointy")
	interceptor_pointy.action_interceptor_priority = 0
	interceptor_pointy.action_interceptor_modifies_parent = false
	interceptor_pointy.action_interceptor_script_path = Scripts.INTERCEPTOR_POINTY
	interceptor_pointy.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_pointy)
	
	# increases attack power from overshield charges
	# typically a forced interceptor
	var interceptor_damage_from_overshield: ActionInterceptorData = ActionInterceptorData.new("interceptor_damage_from_overshield")
	interceptor_damage_from_overshield.action_interceptor_priority = 10000
	interceptor_damage_from_overshield.action_interceptor_modifies_parent = false
	interceptor_damage_from_overshield.action_interceptor_script_path = Scripts.INTERCEPTOR_DAMAGE_FROM_OVERSHIELD
	interceptor_damage_from_overshield.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_damage_from_overshield)
	
	# increases attack power from block
	# typically a forced interceptor
	var interceptor_damage_from_block: ActionInterceptorData = ActionInterceptorData.new("interceptor_damage_from_block")
	interceptor_damage_from_block.action_interceptor_priority = 10000
	interceptor_damage_from_block.action_interceptor_modifies_parent = false
	interceptor_damage_from_block.action_interceptor_script_path = Scripts.INTERCEPTOR_DAMAGE_FROM_BLOCK
	interceptor_damage_from_block.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_damage_from_block)
	
	# negates incoming non zero damage actions
	var interceptor_negate_damage: ActionInterceptorData = ActionInterceptorData.new("interceptor_negate_damage")
	interceptor_negate_damage.action_interceptor_priority = -10000
	interceptor_negate_damage.action_interceptor_modifies_parent = false
	interceptor_negate_damage.action_interceptor_script_path = Scripts.INTERCEPTOR_NEGATE_DAMAGE
	interceptor_negate_damage.action_intercepted_action_paths = [Scripts.ACTION_ATTACK, Scripts.ACTION_DIRECT_DAMAGE]
	
	Global.register_rod(interceptor_negate_damage)
	
	# caps incoming damage to status effect secondary charges
	var interceptor_cap_damage: ActionInterceptorData = ActionInterceptorData.new("interceptor_cap_damage")
	interceptor_cap_damage.action_interceptor_priority = -9000
	interceptor_cap_damage.action_interceptor_modifies_parent = false
	interceptor_cap_damage.action_interceptor_script_path = Scripts.INTERCEPTOR_CAP_DAMAGE
	interceptor_cap_damage.action_intercepted_action_paths = [Scripts.ACTION_ATTACK, Scripts.ACTION_DIRECT_DAMAGE]
	
	Global.register_rod(interceptor_cap_damage)
	
	# rejects block reset actions
	var interceptor_temp_preserve_block: ActionInterceptorData = ActionInterceptorData.new("interceptor_temp_preserve_block")
	interceptor_temp_preserve_block.action_interceptor_priority = 10000
	interceptor_temp_preserve_block.action_interceptor_modifies_parent = true
	interceptor_temp_preserve_block.action_interceptor_script_path = Scripts.INTERCEPTOR_TEMP_PRESERVE_BLOCK
	interceptor_temp_preserve_block.action_intercepted_action_paths = [Scripts.ACTION_RESET_BLOCK]
	
	Global.register_rod(interceptor_temp_preserve_block)
	
	# rejects block reset actions
	var interceptor_preserve_block: ActionInterceptorData = ActionInterceptorData.new("interceptor_preserve_block")
	interceptor_preserve_block.action_interceptor_priority = 10000
	interceptor_preserve_block.action_interceptor_modifies_parent = true
	interceptor_preserve_block.action_interceptor_script_path = Scripts.INTERCEPTOR_PRESERVE_BLOCK
	interceptor_preserve_block.action_intercepted_action_paths = [Scripts.ACTION_RESET_BLOCK]
	
	Global.register_rod(interceptor_preserve_block)
	
	# rejects debuffing status actions
	var interceptor_negate_debuff: ActionInterceptorData = ActionInterceptorData.new("interceptor_negate_debuff")
	interceptor_negate_debuff.action_interceptor_priority = 10000
	interceptor_negate_debuff.action_interceptor_modifies_parent = false
	interceptor_negate_debuff.action_interceptor_script_path = Scripts.INTERCEPTOR_NEGATE_DEBUFF
	interceptor_negate_debuff.action_intercepted_action_paths = [Scripts.ACTION_APPLY_STATUS]
	
	Global.register_rod(interceptor_negate_debuff)
	
	# duplicates incoming card plays
	var interceptor_duplicate_card_plays: ActionInterceptorData = ActionInterceptorData.new("interceptor_duplicate_card_plays")
	interceptor_duplicate_card_plays.action_interceptor_priority = 10000
	interceptor_duplicate_card_plays.action_interceptor_modifies_parent = true
	interceptor_duplicate_card_plays.action_interceptor_script_path = Scripts.INTERCEPTOR_DUPLICATE_CARD_PLAYS
	interceptor_duplicate_card_plays.action_intercepted_action_paths = [Scripts.ACTION_CARD_PLAY]
	
	Global.register_rod(interceptor_duplicate_card_plays)
	
	# duplicates incoming attack card plays
	var interceptor_duplicate_attacks: ActionInterceptorData = ActionInterceptorData.new("interceptor_duplicate_attacks")
	interceptor_duplicate_attacks.action_interceptor_priority = 10000
	interceptor_duplicate_attacks.action_interceptor_modifies_parent = true
	interceptor_duplicate_attacks.action_interceptor_script_path = Scripts.INTERCEPTOR_DUPLICATE_ATTACKS
	interceptor_duplicate_attacks.action_intercepted_action_paths = [Scripts.ACTION_CARD_PLAY]
	
	Global.register_rod(interceptor_duplicate_attacks)
	
	# prevents gaining money
	var interceptor_negate_add_money: ActionInterceptorData = ActionInterceptorData.new("interceptor_negate_add_money")
	interceptor_negate_add_money.action_interceptor_priority = 10000
	interceptor_negate_add_money.action_interceptor_modifies_parent = true
	interceptor_negate_add_money.action_interceptor_script_path = Scripts.INTERCEPTOR_NEGATE_ADD_MONEY
	interceptor_negate_add_money.action_intercepted_action_paths = [Scripts.ACTION_ADD_MONEY]
	
	Global.register_rod(interceptor_negate_add_money)

#endregion

#region Colors

func add_colors() -> void:
	var color_green: ColorData = ColorData.new("color_green")
	color_green.color = Color.WEB_GREEN
	color_green.color_name = "Green"
	color_green.color_energy_icon_texture_path = "external/sprites/colors/green_energy_icon.png"
	Global.register_rod(color_green)
	
	var color_orange: ColorData = ColorData.new("color_orange")
	color_orange.color = Color.CORAL
	color_orange.color_name = "Orange"
	color_orange.color_energy_icon_texture_path = "external/sprites/colors/orange_energy_icon.png"
	Global.register_rod(color_orange)
	
	var color_red: ColorData = ColorData.new("color_red")
	color_red.color = Color.FIREBRICK
	color_red.color_name = "Red"
	color_red.color_energy_icon_texture_path = "external/sprites/colors/red_energy_icon.png"
	Global.register_rod(color_red)
	
	var color_blue: ColorData = ColorData.new("color_blue")
	color_blue.color = Color.ROYAL_BLUE
	color_blue.color_name = "Blue"
	color_blue.color_energy_icon_texture_path = "external/sprites/colors/blue_energy_icon.png"
	Global.register_rod(color_blue)
	
	var color_white: ColorData = ColorData.new("color_white")
	color_white.color = Color.WHITE_SMOKE
	color_white.color_name = "White"
	color_white.color_energy_icon_texture_path = "external/sprites/colors/white_energy_icon.png"
	Global.register_rod(color_white)
	
	var color_purple: ColorData = ColorData.new("color_purple")
	color_purple.color = Color.REBECCA_PURPLE
	color_purple.color_name = "Purple"
	color_purple.color_energy_icon_texture_path = "external/sprites/colors/purple_energy_icon.png"
	Global.register_rod(color_purple)

	var color_black: ColorData = ColorData.new("color_black")
	color_black.color = Color.BLACK
	color_black.color_name = "Black"
	color_black.color_energy_icon_texture_path = "external/sprites/colors/white_energy_icon.png"
	Global.register_rod(color_black)
	
	var color_grey: ColorData = ColorData.new("color_grey")
	color_grey.color = Color.WEB_GRAY
	color_grey.color_name = "Grey"
	color_grey.color_energy_icon_texture_path = "external/sprites/colors/white_energy_icon.png"
	Global.register_rod(color_grey)
#endregion

#region Keywords
func add_keywords() -> void:
	var keyword_block: KeywordData = KeywordData.new("keyword_block")
	keyword_block.keyword_name = "Block"
	keyword_block.keyword_text_bb_code = "Prevents Damage"
	Global.register_rod(keyword_block)
		
	var keyword_corrosion: KeywordData = KeywordData.new("keyword_corrosion")
	keyword_corrosion.keyword_name = "Corrosion"
	keyword_corrosion.keyword_status_effect_id = "status_effect_corrosion"
	keyword_corrosion.keyword_text_bb_code = "Deals damage each turn "
	Global.register_rod(keyword_corrosion)
	
	var keyword_bomb: KeywordData = KeywordData.new("keyword_bomb")
	keyword_bomb.keyword_name = "Bomb"
	keyword_bomb.keyword_text_bb_code = "Deals damage to all enemies when timer runs out "
	Global.register_rod(keyword_bomb)
	
	var keyword_wield: KeywordData = KeywordData.new("keyword_wield")
	keyword_wield.keyword_name = "Wield"
	keyword_wield.keyword_text_bb_code = "Replays random Craft cards "
	Global.register_rod(keyword_wield)
	
	### These are automatically added to cards based on flags
	var keyword_top_deck: KeywordData = KeywordData.new("keyword_top_deck")
	keyword_top_deck.keyword_name = "Top Deck"
	keyword_top_deck.keyword_text_bb_code = "Placed on top of deck at start of combat"
	Global.register_rod(keyword_top_deck)
	
	var keyword_bottom_deck: KeywordData = KeywordData.new("keyword_bottom_deck")
	keyword_bottom_deck.keyword_name = "Bottom Deck"
	keyword_bottom_deck.keyword_text_bb_code = "Placed on the bottom of deck at start of combat"
	Global.register_rod(keyword_bottom_deck)
		
	var keyword_retain: KeywordData = KeywordData.new("keyword_retain")
	keyword_retain.keyword_name = "Retain"
	keyword_retain.keyword_text_bb_code = "Not discarded at end of turn"
	Global.register_rod(keyword_retain)
	
	var keyword_exhaust: KeywordData = KeywordData.new("keyword_exhaust")
	keyword_exhaust.keyword_name = "Exhaust"
	keyword_exhaust.keyword_text_bb_code = "Used once per combat"
	Global.register_rod(keyword_exhaust)
	
	var keyword_rebound: KeywordData = KeywordData.new("keyword_rebound")
	keyword_rebound.keyword_name = "Rebound"
	keyword_rebound.keyword_text_bb_code = "Places next card on top of draw pile when played. Does not affect cards that don't go into discard."
	Global.register_rod(keyword_rebound)
	
	var keyword_discard: KeywordData = KeywordData.new("keyword_discard")
	keyword_discard.keyword_name = "Discard"
	keyword_discard.keyword_text_bb_code = "Placed in discard pile"
	Global.register_rod(keyword_discard)
	
	var keyword_ethereal: KeywordData = KeywordData.new("keyword_ethereal")
	keyword_ethereal.keyword_name = "Ethereal"
	keyword_ethereal.keyword_text_bb_code = "Exhausts if in hand end of turn"
	keyword_ethereal.keyword_child_keyword_object_ids = ["keyword_exhaust"]
	Global.register_rod(keyword_ethereal)
	
	var keyword_banish: KeywordData = KeywordData.new("keyword_banish")
	keyword_banish.keyword_name = "Banish"
	keyword_banish.keyword_text_bb_code = "Completely removes a card from play for the duration of combat"
	keyword_banish.keyword_child_keyword_object_ids = []
	Global.register_rod(keyword_banish)
	
#endregion

#region VFX Animations
func add_combat_vfx_animations() -> void:
	var animation_vfx_impact_default: AnimationData = AnimationData.new("animation_vfx_impact_default")
	animation_vfx_impact_default.add_vfx_animations([
		"external/sprites/animated_effects/impact_default/vfx_impact_default_01.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_02.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_03.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_04.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_05.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_06.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_07.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_08.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_09.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_10.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_11.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_12.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_13.png",
		"external/sprites/animated_effects/impact_default/vfx_impact_default_14.png",
	], 25)
	Global.register_rod(animation_vfx_impact_default)
#endregion

#region Characters

func add_characters() -> void:
	var character_color: String = "" # used to make writing boilerplate colors faster
	
	# green character
	character_color = "green"
	var character_green: CharacterData = CharacterData.new("character_{0}".format([character_color]))
	character_green.character_player_id = "player_{0}".format([character_color])
	character_green.character_name = "The Botanist"
	character_green.character_description = "A former thermonuclear botanist seeking employment after being fired for their previous experiments."
	character_green.character_color_id = "color_{0}".format([character_color])
	character_green.character_starting_health = 75
	character_green.character_starting_card_draft_card_pack_ids = ["card_pack_prismatic".format([character_color])]
	character_green.character_starting_artifact_ids = ["artifact_draw_on_combat_start"]
	character_green.character_starting_artifact_pack_ids = ["artifact_pack_white", "artifact_pack_{0}".format([character_color])]
	character_green.character_starting_consumable_pack_ids = ["consumable_pack_white", "consumable_pack_{0}".format([character_color])]
	character_green.character_starting_card_object_ids = [
		"card_basic_food_green", "card_basic_food_green", "card_basic_food_green", "card_basic_food_green",
		"card_youngmentor", "card_facetrecaster", "card_pearlemissary", "card_joyfulsailor",
		#"card_growth", "card_growth", "card_growth", "card_fertilize",
		#"card_cell_wall", "card_thorns",
		#"card_datum", "card_conclusion",
		#"card_clippers", "card_petals",
		#"card_particle_accelerator", "card_particle_accelerator",
		#"card_fusion_cannon", "card_fusion_cannon",
		#"card_verdant", "card_verdant",
		#"card_containment", "card_containment",
		#"card_critical",
		#"card_wildflower", "card_wildflower", "card_wildflower", "card_wildflower", 
		#"card_energy_next_turn", "card_energy_next_turn",
		#"card_meltdown", "card_meltdown",
		#"card_photoelectric_synthesis", "card_photoelectric_synthesis",
		#"card_feedback_loop",
		#"card_pollen",
		#"card_symbiosis",
		#"card_bud", "card_bud", "card_bud", 
		#"card_moss", "card_moss",
	]
	
	Global.register_rod(character_green)
	# green character animations
	var animation_character_green: AnimationData = AnimationData.new("animation_character_{0}".format([character_color]))
	character_green.character_animation_id = animation_character_green.object_id
	animation_character_green.add_combatant_animations(
		["external/sprites/characters/character_{0}/character_{0}.png".format([character_color])],
		["external/sprites/characters/character_{0}/character_{0}.png".format([character_color])],
		["external/sprites/characters/character_{0}/character_{0}.png".format([character_color])],
		)
	
	Global.register_rod(animation_character_green)

#endregion

#region Run Modifiers

func add_run_modifiers() -> void:
	### Standard Difficulty Run Modifiers
	var run_modifier_difficulty_0: RunModifierData = RunModifierData.new("run_modifier_difficulty_0")
	run_modifier_difficulty_0.run_modifier_name = "Basic Difficulty"
	run_modifier_difficulty_0.run_modifier_modifier_script_path = ""

	Global.register_rod(run_modifier_difficulty_0)
	
	var run_modifier_difficulty_1: RunModifierData = RunModifierData.new("run_modifier_difficulty_1")
	run_modifier_difficulty_1.run_modifier_name = "Difficulty 1: Harder Enemies"
	run_modifier_difficulty_1.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_DIFFICULTY_1

	Global.register_rod(run_modifier_difficulty_1)
	
	var run_modifier_difficulty_2: RunModifierData = RunModifierData.new("run_modifier_difficulty_2")
	run_modifier_difficulty_2.run_modifier_name = "Difficulty 2: Harder Minibosses"
	run_modifier_difficulty_2.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_DIFFICULTY_2

	Global.register_rod(run_modifier_difficulty_2)
	
	var run_modifier_difficulty_3: RunModifierData = RunModifierData.new("run_modifier_difficulty_3")
	run_modifier_difficulty_3.run_modifier_name = "Difficulty 3: Harder Bosses"
	run_modifier_difficulty_3.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_DIFFICULTY_3

	Global.register_rod(run_modifier_difficulty_3)
	
	var run_modifier_difficulty_4: RunModifierData = RunModifierData.new("run_modifier_difficulty_4")
	run_modifier_difficulty_4.run_modifier_name = "Difficulty 4"
	run_modifier_difficulty_4.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_DIFFICULTY_4

	Global.register_rod(run_modifier_difficulty_4)
	
	var run_modifier_difficulty_5: RunModifierData = RunModifierData.new("run_modifier_difficulty_5")
	run_modifier_difficulty_5.run_modifier_name = "Difficulty 5"
	run_modifier_difficulty_5.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_DIFFICULTY_5

	Global.register_rod(run_modifier_difficulty_5)
	
	# register the modifiers as standard difficulty
	Global.STANDARD_DIFFICULTY_RUN_MODIFIER_IDS.append_array([
		run_modifier_difficulty_0.object_id,
		run_modifier_difficulty_1.object_id,
		run_modifier_difficulty_2.object_id,
		run_modifier_difficulty_3.object_id,
		run_modifier_difficulty_4.object_id,
		run_modifier_difficulty_5.object_id,
	])
	
	### Custom Run Modifiers
	var run_modifier_custom_easy_mode: RunModifierData = RunModifierData.new("run_modifier_custom_easy_mode")
	run_modifier_custom_easy_mode.run_modifier_name = "Easy Mode"
	run_modifier_custom_easy_mode.run_modifier_description = "All enemies are set to 1HP"
	run_modifier_custom_easy_mode.run_modifier_is_custom =  true
	run_modifier_custom_easy_mode.run_modifier_exclusive_to_modifier_ids = []
	run_modifier_custom_easy_mode.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_CUSTOM_EASYMODE

	Global.register_rod(run_modifier_custom_easy_mode)
	
	var run_modifier_endless_mode: RunModifierData = RunModifierData.new("run_modifier_endless_mode")
	run_modifier_endless_mode.run_modifier_name = "Endless Mode"
	run_modifier_endless_mode.run_modifier_description = "Run will only end when the player dies"
	run_modifier_endless_mode.run_modifier_is_custom =  true
	run_modifier_endless_mode.run_modifier_exclusive_to_modifier_ids = []
	run_modifier_endless_mode.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_CUSTOM_ENDLESS_MODE

	Global.register_rod(run_modifier_endless_mode)
	
	var run_modifier_custom_1: RunModifierData = RunModifierData.new("run_modifier_custom_1")
	run_modifier_custom_1.run_modifier_name = "Custom 1"
	run_modifier_custom_1.run_modifier_description = "Dummy modifier. Mutually exclusive with Custom 2"
	run_modifier_custom_1.run_modifier_is_custom =  true
	run_modifier_custom_1.run_modifier_exclusive_to_modifier_ids = ["run_modifier_custom_2"]
	run_modifier_custom_1.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_CUSTOM_1

	Global.register_rod(run_modifier_custom_1)
	
	var run_modifier_custom_2: RunModifierData = RunModifierData.new("run_modifier_custom_2")
	run_modifier_custom_2.run_modifier_name = "Custom 2"
	run_modifier_custom_2.run_modifier_description = "Dummy modifier. Mutually exclusive with Custom 1"
	run_modifier_custom_2.run_modifier_is_custom =  true
	run_modifier_custom_2.run_modifier_exclusive_to_modifier_ids = ["run_modifier_custom_1"]
	run_modifier_custom_2.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_CUSTOM_2

	Global.register_rod(run_modifier_custom_2)
		
	var run_modifier_draft_all_colors: RunModifierData = RunModifierData.new("run_modifier_draft_all_colors")
	run_modifier_draft_all_colors.run_modifier_name = "Prismatic"
	run_modifier_draft_all_colors.run_modifier_description = "Draft all card colors"
	run_modifier_draft_all_colors.run_modifier_is_custom =  true
	run_modifier_draft_all_colors.run_modifier_exclusive_to_modifier_ids = []
	run_modifier_draft_all_colors.run_modifier_modifier_script_path = Scripts.RUN_MODIFIER_CUSTOM_DRAFT_ALL_COLORS

	Global.register_rod(run_modifier_draft_all_colors)
	
	### Automatic Modifiers
	
	# this allows for auto revive consumables to work each run
	#var run_modifier_consumable_auto_revive: RunModifierData = RunModifierData.new("run_modifier_draft_all_colors")
	#run_modifier_consumable_auto_revive.run_modifier_name = "Auto Revive"
	#run_modifier_consumable_auto_revive.run_modifier_description = "Uses auto revive consumables"
	#run_modifier_consumable_auto_revive.run_modifier_is_automatic = true # registered regardless of difficulty
	#run_modifier_consumable_auto_revive.run_modifier_modifier_script_path = Scripts.BASE_RUN_MODIFIER # does nothing
	#run_modifier_consumable_auto_revive.run_modifier_interceptor_ids = ["interceptor_consumable_auto_revive"] # ensures auto revive always active
	
	#Global.register_rod(run_modifier_consumable_auto_revive)
	
#endregion

#region Run Start Options

func add_run_start_options() -> void:
	### Downsides
	# remove max hp
	var run_start_option_reduce_max_hp: RunStartOptionData = RunStartOptionData.new("run_start_option_reduce_max_hp")
	run_start_option_reduce_max_hp.run_start_option_bb_code = "[color=red]Lose 10 Max HP[/color]"
	run_start_option_reduce_max_hp.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_reduce_max_hp.run_start_option_actions = [{Scripts.ACTION_ADD_HEALTH: {"target_override": BaseAction.TARGET_OVERRIDES.PARENT, "health_max_amount": -10}}]
	
	Global.register_rod(run_start_option_reduce_max_hp)
	
	# take damage
	var run_start_option_take_damage: RunStartOptionData = RunStartOptionData.new("run_start_option_take_damage")
	run_start_option_take_damage.run_start_option_bb_code = "[color=red]Lose 5 HP[/color]"
	run_start_option_take_damage.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_take_damage.run_start_option_actions = [{Scripts.ACTION_ADD_HEALTH: {"target_override": BaseAction.TARGET_OVERRIDES.PARENT, "health_amount": -5}}]

	Global.register_rod(run_start_option_take_damage)
	
	# lose all money
	var run_start_option_lose_money: RunStartOptionData = RunStartOptionData.new("run_start_option_lose_money")
	run_start_option_lose_money.run_start_option_bb_code = "[color=red]Lose all money[/color]"
	run_start_option_lose_money.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_lose_money.run_start_option_actions = [{Scripts.ACTION_ADD_MONEY: {"money_amount": -1000}}]

	Global.register_rod(run_start_option_lose_money)
	
	
	### Upsides
	# add money
	var run_start_option_add_money: RunStartOptionData = RunStartOptionData.new("run_start_option_add_money")
	run_start_option_add_money.run_start_option_bb_code = "[color=green]Gain 50 money[/color]"
	run_start_option_add_money.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_add_money.run_start_option_actions = [{Scripts.ACTION_ADD_MONEY: {"money_amount": 50}}]

	Global.register_rod(run_start_option_add_money)
	
	# gain max hp
	var run_start_option_gain_max_hp: RunStartOptionData = RunStartOptionData.new("run_start_option_gain_max_hp")
	run_start_option_gain_max_hp.run_start_option_bb_code = "[color=green]Gain 10 Max HP[/color]"
	run_start_option_gain_max_hp.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_gain_max_hp.run_start_option_actions = [{Scripts.ACTION_ADD_HEALTH: {"target_override": BaseAction.TARGET_OVERRIDES.PLAYER, "health_amount": 10, "health_max_amount": 10}}]
	
	Global.register_rod(run_start_option_gain_max_hp)
	
	# draft a card from player's pool
	# functions identically to a standard draft
	var run_start_option_draft_card: RunStartOptionData = RunStartOptionData.new("run_start_option_draft_card")
	run_start_option_draft_card.run_start_option_bb_code = "[color=green]Draft a card[/color]"
	run_start_option_draft_card.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_draft_card.run_start_option_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			"pick_draft_cards": false,
			"draft_from_card_pool": true,
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			# use same rng as player drafting so it counts as draft
			"rng_name": "rng_card_drafting",
			"validator_data": [], # this should always be empty if draft_use_player_draft = true
			# weighted draft from player draft pool with pity system
			"draft_use_player_draft": true,
			"draft_is_weighted": false,
			"draft_use_pity_system": false,
			}
		}
	]
	
	Global.register_rod(run_start_option_draft_card)
	
	# draft common card available to the player
	# this uses validators to scan the entire card pool for a draft
	# you could also use a card pack to achieve a similar effect
	var run_start_option_draft_common_card: RunStartOptionData = RunStartOptionData.new("run_start_option_draft_common_card")
	run_start_option_draft_common_card.run_start_option_bb_code = "[color=green]Draft a common card[/color]"
	run_start_option_draft_common_card.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_draft_common_card.run_start_option_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			"pick_draft_cards": false,
			"draft_from_card_pool": true,
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			"validator_data": [
				{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.COMMON]}},
				{Scripts.VALIDATOR_CARD_DRAFTABLE: {}},
			],
			# use same rng as player drafting so it counts as draft
			"rng_name": "rng_card_drafting",
			"draft_use_player_draft": false, # this should always be false if using a validator based draft
			"draft_is_weighted": false,
			"draft_use_pity_system": false,
			}
		}
	]
	
	Global.register_rod(run_start_option_draft_common_card)
	
	# gain a random common artifact
	var run_start_option_gain_common_artifact: RunStartOptionData = RunStartOptionData.new("run_start_option_gain_common_artifact")
	run_start_option_gain_common_artifact.run_start_option_bb_code = "[color=green]Gain Random Common Artifact[/color]"
	run_start_option_gain_common_artifact.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_gain_common_artifact.run_start_option_actions = [{Scripts.ACTION_ADD_ARTIFACTS_FROM_POOL:
		{
		"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
		"artifact_count": 1,
		"artifact_rarities": [ArtifactData.ARTIFACT_RARITIES.COMMON]
		}
		}]
	
	Global.register_rod(run_start_option_gain_common_artifact)
	
	# draft a colorless card from the white card pack
	var run_start_option_draft_colorless_card: RunStartOptionData = RunStartOptionData.new("run_start_option_draft_colorless_card")
	run_start_option_draft_colorless_card.run_start_option_bb_code = "[color=green]Draft a colorless card[/color]"
	run_start_option_draft_colorless_card.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_draft_colorless_card.run_start_option_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
			"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			"pick_draft_cards": false,
			"draft_from_card_pool": true,
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			"validator_data": [],
			# use same rng as player drafting so it counts as draft
			"rng_name": "rng_card_drafting",
			# get white cards
			"draft_card_pack_id": "card_pack_white"
			}
		}
	]
	
	Global.register_rod(run_start_option_draft_colorless_card)
	
	### Complete
	
	# replace starting artifact with a random boss one
	var run_start_option_artifact_swap: RunStartOptionData = RunStartOptionData.new("run_start_option_artifact_swap")
	run_start_option_artifact_swap.run_start_option_bb_code = "[color=green]Replace Starting Artifact With Boss Artifact[/color]"
	run_start_option_artifact_swap.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.COMPLETE
	run_start_option_artifact_swap.run_start_option_actions = [{Scripts.ACTION_SWAP_BOSS_ARTIFACT: {}}]
	
	Global.register_rod(run_start_option_artifact_swap)
	
#endregion

#region Custom UI

func add_custom_ui() -> void:
	var custom_ui_see_top_of_draw_pile: CustomUIData = CustomUIData.new("custom_ui_see_top_of_draw_pile")
	custom_ui_see_top_of_draw_pile.custom_ui_asset_path = "res://scenes/ui/custom/CustomUISeeTopOfDrawPile.tscn"
	# custom_ui_see_top_of_draw_pile.custom_ui_requires_target = true
	Global.register_rod(custom_ui_see_top_of_draw_pile)

#endregion

#region Custom UI

func add_custom_signals() -> void:
	var custom_signal_special_discard: CustomSignalData = CustomSignalData.new("custom_signal_special_discard")
	custom_signal_special_discard.custom_signal_is_stat = true
	custom_signal_special_discard.custom_signal_stat_name = "CUSTOM_STAT_SPECIAL_DISCARD"
	Global.register_rod(custom_signal_special_discard)
	
	var custom_signal_overheated: CustomSignalData = CustomSignalData.new("custom_signal_overheated")
	custom_signal_overheated.custom_signal_is_stat = true
	custom_signal_overheated.custom_signal_stat_name = "CUSTOM_STAT_OVERHEATED"
	Global.register_rod(custom_signal_overheated)
	
	

#endregion

#region Enemies
func add_enemies() -> void:
	const DIFFICULTY_STARTING: int = 0
	const DIFFICULTY_STANDARD_ENEMIES_HARDER: int = 1
	const DIFFICULTY_MINIBOSS_ENEMIES_HARDER: int = 2
	const DIFFICULTY_BOSS_ENEMIES_HARDER: int = 3
	
	# enemy that negates the first damage instance against it
	var enemy_1: EnemyData = EnemyData.new("enemy_1")
	enemy_1.enemy_name = "Red Enemy"
	enemy_1.add_health_bounds(5, 7)
	enemy_1.add_health_bounds(8, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	enemy_1.enemy_initial_status_effects = {"status_effect_negate_damage": 1}
	enemy_1.enemy_texture_path = "external/sprites/enemies/enemy_red_small.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	enemy_1.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	enemy_1.enemy_actions_on_death = [{Scripts.ACTION_ADD_MONEY: {"money_amount":5}}]
	# an attack that hits harder on higher difficulties
	enemy_1.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, ""),
	])
	enemy_1.add_intent_state([
	EnemyIntentData.new("intent_attack_1", DIFFICULTY_STARTING, 0, 1, "", 0, "", {"intent_attack_1": 1, "intent_block": 1}),
	EnemyIntentData.new("intent_attack_1", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 1, "", 0, "", {"nt_attack_1": 1, "intent_block": 1}),
	])
	enemy_1.add_intent_state([
	EnemyIntentData.new("intent_attack_2", DIFFICULTY_STARTING, 0, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
	EnemyIntentData.new("intent_attack_2", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
	])
		
	var _enemy_1_anim: AnimationData = enemy_1.add_standard_animations(
		["external/sprites/enemies/enemy_red_small.png"]
	)

	Global.register_rod(enemy_1)
	
#region enemies plains
	# enemy that negates the first damage instance against it
	var field_patch: EnemyData = EnemyData.new("field_patch")
	field_patch.enemy_name = "Field Patch"
	field_patch.add_health_bounds(5, 7)
	field_patch.add_health_bounds(8, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	field_patch.enemy_texture_path = "external/sprites/enemies/grass.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	field_patch.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	field_patch.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	field_patch.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _field_patch_anim: AnimationData = field_patch.add_standard_animations(
		["external/sprites/enemies/grass.png"]
	)

	Global.register_rod(field_patch)
	Global.register_rod(_field_patch_anim)
	
	# enemy that negates the first damage instance against it
	var mound: EnemyData = EnemyData.new("mound")
	mound.enemy_name = "Mound"
	mound.add_health_bounds(12, 15)
	mound.add_health_bounds(16, 18, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	mound.enemy_texture_path = "external/sprites/enemies/hills.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	mound.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	mound.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":3,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	mound.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _mound_anim: AnimationData = mound.add_standard_animations(
		["external/sprites/enemies/hills.png"]
	)

	Global.register_rod(mound)
	Global.register_rod(_mound_anim)
	
	# enemy that negates the first damage instance against it
	var rock: EnemyData = EnemyData.new("rock")
	rock.enemy_name = "Rock"
	rock.add_health_bounds(5, 7)
	rock.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	rock.enemy_texture_path = "external/sprites/enemies/stone-pile.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	rock.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	rock.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_rock",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	rock.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _rock_anim: AnimationData = rock.add_standard_animations(
		["external/sprites/enemies/stone-pile.png"]
	)

	Global.register_rod(rock)
	Global.register_rod(_rock_anim)
	
	# enemy that negates the first damage instance against it
	var pond: EnemyData = EnemyData.new("pond")
	pond.enemy_name = "Pond"
	pond.add_health_bounds(5, 7)
	pond.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	pond.enemy_texture_path = "external/sprites/enemies/lily-pads.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	pond.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	pond.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_fish",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	pond.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _pond_anim: AnimationData = pond.add_standard_animations(
		["external/sprites/enemies/lily-pads.png"]
	)

	Global.register_rod(pond)
	Global.register_rod(_pond_anim)
	
#endregion

#region enemies desert
	# enemy that negates the first damage instance against it
	var boulder: EnemyData = EnemyData.new("boulder")
	boulder.enemy_name = "Boulder"
	boulder.add_health_bounds(5, 7)
	boulder.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	boulder.enemy_texture_path = "external/sprites/enemies/rock.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	boulder.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	boulder.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_rock",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	boulder.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _boulder_anim: AnimationData = boulder.add_standard_animations(
		["external/sprites/enemies/rock.png"]
	)
	Global.register_rod(boulder)
	Global.register_rod(_boulder_anim)
	
	# enemy that negates the first damage instance against it
	var bigboulder: EnemyData = EnemyData.new("bigboulder")
	bigboulder.enemy_name = "Big Boulder"
	bigboulder.add_health_bounds(9, 11)
	bigboulder.add_health_bounds(14, 19, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	bigboulder.enemy_texture_path = "external/sprites/enemies/boulder-dash.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	bigboulder.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	bigboulder.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_rock",
		"number_of_cards":4,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	bigboulder.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _bigboulder_anim: AnimationData = bigboulder.add_standard_animations(
		["external/sprites/enemies/boulder-dash.png"]
	)

	Global.register_rod(bigboulder)
	Global.register_rod(_bigboulder_anim)
#endregion

#region enemies coast
	# enemy that negates the first damage instance against it
	var shore: EnemyData = EnemyData.new("shore")
	shore.enemy_name = "Shore"
	shore.add_health_bounds(5, 7)
	shore.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	shore.enemy_texture_path = "external/sprites/enemies/fish-escape.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	shore.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	shore.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_fish",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	shore.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _shore_anim: AnimationData = shore.add_standard_animations(
		["external/sprites/enemies/fish-escape.png"]
	)
	
	Global.register_rod(_shore_anim)
	Global.register_rod(shore)

	# enemy that negates the first damage instance against it
	var cave: EnemyData = EnemyData.new("cave")
	cave.enemy_name = "Cave"
	cave.add_health_bounds(25, 32)
	cave.add_health_bounds(35, 40, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	cave.enemy_texture_path = "external/sprites/enemies/cave-entrance.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	cave.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	cave.enemy_actions_on_death = [{Scripts.ACTION_ADD_ARTIFACTS_FROM_POOL:
		{
		"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
		"artifact_count": 1,
		"artifact_rarities": [ArtifactData.ARTIFACT_RARITIES.COMMON]
		}
		}]
	# an attack that hits harder on higher difficulties
	cave.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _cave_anim: AnimationData = cave.add_standard_animations(
		["external/sprites/enemies/cave-entrance.png"]
	)

	Global.register_rod(cave)
	Global.register_rod(_cave_anim)

	# enemy that negates the first damage instance against it
	var sandbed: EnemyData = EnemyData.new("sandbed")
	sandbed.enemy_name = "Sandbed"
	sandbed.add_health_bounds(15,17)
	sandbed.add_health_bounds(19, 21, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	sandbed.enemy_texture_path = "external/sprites/enemies/powder.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	sandbed.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	sandbed.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_treasure",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	var sandbed_status_actions: Array[Dictionary] = [{Scripts.ACTION_ADD_HEALTH: {"health_amount":2, "target_override":BaseAction.TARGET_OVERRIDES.PARENT}}]
	# an attack that hits harder on higher difficulties
	sandbed.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1},sandbed_status_actions),
	])
	
	var _sandbed_anim: AnimationData = sandbed.add_standard_animations(
		["external/sprites/enemies/powder.png"]
	)

	Global.register_rod(sandbed)
	Global.register_rod(_sandbed_anim)
#endregion

#region enemies forest
	# enemy that negates the first damage instance against it
	var forestfloor: EnemyData = EnemyData.new("forestfloor")
	forestfloor.enemy_name = "Forest Floor"
	forestfloor.add_health_bounds(5, 7)
	forestfloor.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	forestfloor.enemy_texture_path = "external/sprites/enemies/forest.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	forestfloor.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	forestfloor.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_spice",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	forestfloor.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _forestfloor_anim: AnimationData = forestfloor.add_standard_animations(
		["external/sprites/enemies/forest.png"]
	)

	Global.register_rod(forestfloor)
	Global.register_rod(_forestfloor_anim)
	
		# enemy that negates the first damage instance against it
	var den: EnemyData = EnemyData.new("den")
	den.enemy_name = "Den"
	den.add_health_bounds(25, 27)
	den.add_health_bounds(29, 31, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	den.enemy_texture_path = "external/sprites/enemies/hobbit-dwelling.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	var den_status_actions: Array[Dictionary] = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 1,
		"max_card_amount": 1,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
				"card_influence": -1,
				"pick_played_card": true
			}},
			]
		}
	}]
	
	den.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	den.enemy_actions_on_death = [{	Scripts.ACTION_ADD_MONEY: {"money_amount": 8}}]
	# an attack that hits harder on higher difficulties
	den.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1},den_status_actions),
	])
		
	var _den_anim: AnimationData = den.add_standard_animations(
		["external/sprites/enemies/hobbit-dwelling.png"]
	)

	Global.register_rod(den)
	Global.register_rod(_den_anim)
	
		# enemy that negates the first damage instance against it
	var hideout: EnemyData = EnemyData.new("hideout")
	hideout.enemy_name = "hideout"
	hideout.add_health_bounds(25, 27)
	hideout.add_health_bounds(29, 31, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	hideout.enemy_texture_path = "external/sprites/enemies/castle.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	var hideout_status_actions: Array[Dictionary] = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 2,
		"max_card_amount": 2,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
				"card_influence": -1,
				"pick_played_card": true
			}},
			]
		}
	}]
	
	hideout.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	hideout.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_spice",
		"number_of_cards":3,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	hideout.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1},hideout_status_actions),
	])
		
	var _hideout_anim: AnimationData = hideout.add_standard_animations(
		["external/sprites/enemies/castle.png"]
	)

	Global.register_rod(hideout)
	Global.register_rod(_hideout_anim)
#endregion

#region enemies swamp
	# enemy that negates the first damage instance against it
	var dryfield: EnemyData = EnemyData.new("dryfield")
	dryfield.enemy_name = "Dry Field"
	dryfield.add_health_bounds(5, 7)
	dryfield.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	dryfield.enemy_texture_path = "external/sprites/enemies/agave.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	dryfield.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	dryfield.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	dryfield.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _dryfield_anim: AnimationData = dryfield.add_standard_animations(
		["external/sprites/enemies/agave.png"]
	)

	Global.register_rod(dryfield)
	Global.register_rod(_dryfield_anim)
	
		# enemy that negates the first damage instance against it
	var hut: EnemyData = EnemyData.new("hut")
	hut.enemy_name = "Hut"
	hut.add_health_bounds(15, 17)
	hut.add_health_bounds(19, 21, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	hut.enemy_texture_path = "external/sprites/enemies/hut.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	hut.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	hut.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_spice",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	hut.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _hut_anim: AnimationData = hut.add_standard_animations(
		["external/sprites/enemies/hut.png"]
	)

	Global.register_rod(hut)
	Global.register_rod(_hut_anim)
#endregion
	## enemy that negates the first debuff against it
	#var enemy_2: EnemyData = EnemyData.new("enemy_2")
	#enemy_2.enemy_name = "Blue Enemy"
	#enemy_2.add_health_bounds(5, 7)
	#enemy_2.add_health_bounds(8, 12, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	#enemy_2.enemy_initial_status_effects = {"status_effect_negate_debuff": 1}
	#enemy_2.enemy_texture_path = "external/sprites/enemies/enemy_blue_small.png"
	#enemy_2.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1})
		#])
	#enemy_2.add_intent_state([
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STARTING, 5, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STANDARD_ENEMIES_HARDER, 6, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#enemy_2.add_intent_state([
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STARTING, 3, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STANDARD_ENEMIES_HARDER, 4, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
		#
	#var _enemy_2_anim: AnimationData = enemy_2.add_standard_animations(
		#["external/sprites/enemies/enemy_blue_small.png"]
	#)
	#
	#Global.register_rod(enemy_2)
	#
	## enemy that applies poison to everyone on death
	#var enemy_3: EnemyData = EnemyData.new("enemy_3")
	#enemy_3.add_health_bounds(15, 25)
	#enemy_3.add_health_bounds(25, 35, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	#enemy_3.enemy_name = "Green Enemy"
	#enemy_3.enemy_texture_path = "external/sprites/enemies/enemy_green_small.png"
	#enemy_3.enemy_actions_on_death = [
		#{
		#Scripts.ACTION_APPLY_STATUS: {"status_charge_amount": 5, "status_effect_object_id": "status_effect_corrosion", "time_delay": 0.5, "target_override": BaseAction.TARGET_OVERRIDES.ALL_COMBATANTS}
		#}
	#]
	#enemy_3.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#enemy_3.add_intent_state([
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STARTING, 5, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STANDARD_ENEMIES_HARDER, 7, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#enemy_3.add_intent_state([
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STARTING, 3, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STANDARD_ENEMIES_HARDER, 3, 3, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
	#])
	#
	#var _enemy_3_anim: AnimationData = enemy_3.add_standard_animations(
		#["external/sprites/enemies/enemy_green_small.png"]
	#)
	#
	#Global.register_rod(enemy_3)
	#
	## enemy that applies vulnerable to player
	#var enemy_4: EnemyData = EnemyData.new("enemy_4")
	#enemy_4.add_health_bounds(37, 43)
	#enemy_4.add_health_bounds(47, 53, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	#enemy_4.enemy_name = "Big Attack Enemy"
	#enemy_4.enemy_texture_path = "external/sprites/enemies/enemy_purple_medium.png"
	#enemy_4.enemy_actions_on_death = [
	#{
	#Scripts.ACTION_APPLY_STATUS: {"status_charge_amount": 5, "status_effect_object_id": "status_effect_corrosion", "time_delay": 0.5, "target_override": BaseAction.TARGET_OVERRIDES.ALL_COMBATANTS}
	#}
	#]
	#enemy_4.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack_vulnerable": 1})
		#])
	#var enemy_4_status_charge_1: int = 2
	#var enemy_4_status_actions_1: Array[Dictionary] = [{Scripts.ACTION_APPLY_STATUS: {"status_effect_object_id": "status_effect_vulnerable", "status_charge_amount": enemy_4_status_charge_1, "target_override": BaseAction.TARGET_OVERRIDES.PLAYER}}]
	#var enemy_4_status_charge_2: int = 4
	#var enemy_4_status_actions_2: Array[Dictionary] = [{Scripts.ACTION_APPLY_STATUS: {"status_effect_object_id": "status_effect_vulnerable", "status_charge_amount": enemy_4_status_charge_2, "target_override": BaseAction.TARGET_OVERRIDES.PLAYER}}]
	#enemy_4.add_intent_state([
		#EnemyIntentData.new("intent_attack_vulnerable", DIFFICULTY_STARTING, 10, 1, "", 0, "", {"intent_attack_multi": 1}, enemy_4_status_actions_1),
		#EnemyIntentData.new("intent_attack_vulnerable", DIFFICULTY_STANDARD_ENEMIES_HARDER, 12, 1, "", 0, "", {"intent_attack_multi": 1}, enemy_4_status_actions_2),
	#])
	#enemy_4.add_intent_state([
		#EnemyIntentData.new("intent_attack_multi", DIFFICULTY_STARTING, 5, 2, "", 0, "", {"intent_block": 1}),
		#EnemyIntentData.new("intent_attack_multi", DIFFICULTY_STANDARD_ENEMIES_HARDER, 6, 2, "", 0, "", {"intent_block": 1}),
		#])
	#enemy_4.add_intent_state([
		#EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 10, "", {"intent_attack_vulnerable": 1}),
		#EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 12, "", {"intent_attack_vulnerable": 1}),
	#])
	#
	#var _enemy_4_anim: AnimationData = enemy_4.add_standard_animations(
		#["external/sprites/enemies/enemy_purple_medium.png"]
	#)
	#
	#Global.register_rod(enemy_4)
	#
	#var enemy_act_1_miniboss_1: EnemyData = EnemyData.new("enemy_act_1_miniboss_1")
	#enemy_act_1_miniboss_1.add_health_bounds(100,100)
	#enemy_act_1_miniboss_1.add_health_bounds(120,120, DIFFICULTY_MINIBOSS_ENEMIES_HARDER) # gets more health on later difficulty
	#enemy_act_1_miniboss_1.enemy_type = EnemyData.ENEMY_TYPES.MINIBOSS
	#enemy_act_1_miniboss_1.enemy_name = "Act 1 Miniboss"
	#enemy_act_1_miniboss_1.enemy_texture_path = "external/sprites/enemies/enemy_green_medium.png"
	#enemy_act_1_miniboss_1.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1})
	#])
	#enemy_act_1_miniboss_1.add_intent_state([
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STARTING, 18, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_MINIBOSS_ENEMIES_HARDER, 22, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#enemy_act_1_miniboss_1.add_intent_state([
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STARTING, 8, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_MINIBOSS_ENEMIES_HARDER, 10, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#
	#var _enemy_act_1_miniboss_1_anim: AnimationData = enemy_act_1_miniboss_1.add_standard_animations(
		#["external/sprites/enemies/enemy_green_medium.png"]
	#)
	#
	#Global.register_rod(enemy_act_1_miniboss_1)
	#
	#var enemy_act_1_miniboss_2: EnemyData = EnemyData.new("enemy_act_1_miniboss_2")
	#enemy_act_1_miniboss_2.add_health_bounds(45, 55)
	#enemy_act_1_miniboss_2.add_health_bounds(70, 80, DIFFICULTY_MINIBOSS_ENEMIES_HARDER) # gets more health on later difficulty
	#enemy_act_1_miniboss_2.enemy_type = EnemyData.ENEMY_TYPES.MINIBOSS
	#enemy_act_1_miniboss_2.enemy_name = "Act 1 Miniboss"
	#enemy_act_1_miniboss_2.enemy_texture_path = "external/sprites/enemies/enemy_red_medium.png"
	#enemy_act_1_miniboss_2.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1})
		#])
	#enemy_act_1_miniboss_2.add_intent_state([
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_STARTING, 8, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_1", DIFFICULTY_MINIBOSS_ENEMIES_HARDER, 10, 1, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#enemy_act_1_miniboss_2.add_intent_state([
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_STARTING, 4, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#EnemyIntentData.new("intent_attack_2", DIFFICULTY_MINIBOSS_ENEMIES_HARDER, 5, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
		#])
	#
	#var _enemy_act_1_miniboss_2_anim: AnimationData = enemy_act_1_miniboss_2.add_standard_animations(
		#["external/sprites/enemies/enemy_red_medium.png"]
	#)
	#
	#Global.register_rod(enemy_act_1_miniboss_2)
	#
	## boss that summons minions
	var enemy_act_1_boss_1: EnemyData = EnemyData.new("enemy_act_1_boss_1")
	enemy_act_1_boss_1.add_health_bounds(9998, 9999)
	enemy_act_1_boss_1.add_health_bounds(9998, 9999, DIFFICULTY_BOSS_ENEMIES_HARDER)
	enemy_act_1_boss_1.enemy_type = EnemyData.ENEMY_TYPES.BOSS
	enemy_act_1_boss_1.enemy_name = "Act 1 Boss"
	enemy_act_1_boss_1.enemy_texture_path =  "external/sprites/enemies/enemy_red_large.png"
	enemy_act_1_boss_1.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block": 1})
		])
	#var enemy_act_1_boss_1_summon_actions: Array[Dictionary] = [
	#			{
	#			Scripts.ACTION_SUMMON_ENEMIES: {"number_of_spawns": 2, "spawn_slots": [1,2], "time_delay": 0.5, "random_enemy_object_ids": ["enemy_minion_1", "enemy_minion_2"], "target_override": BaseAction.TARGET_OVERRIDES.PARENT}
	#			}
	#		]
	enemy_act_1_boss_1.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
	#enemy_act_1_boss_1.add_intent_state([
	#	EnemyIntentData.new("intent_summon", DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack": 1}, enemy_act_1_boss_1_summon_actions)
	#	])
	#enemy_act_1_boss_1.add_intent_state([
		#EnemyIntentData.new("intent_attack", DIFFICULTY_STARTING, 3, 2, "", 7, "", {"intent_attack": 1}),
		#EnemyIntentData.new("intent_attack", DIFFICULTY_BOSS_ENEMIES_HARDER, 5, 2, "", 7, "", {"intent_attack": 1}),
	#])
	#
	var _enemy_act_1_boss_1_anim: AnimationData = enemy_act_1_boss_1.add_standard_animations(
		["external/sprites/enemies/enemy_red_large.png"]
	)
	#
	Global.register_rod(enemy_act_1_boss_1)
	Global.register_rod(_enemy_act_1_boss_1_anim)
	#
	## example of minion enemy
	#var enemy_minion_1: EnemyData = EnemyData.new("enemy_minion_1")
	#enemy_minion_1.add_health_bounds(4, 4)
	#enemy_minion_1.add_health_bounds(7, 7, DIFFICULTY_BOSS_ENEMIES_HARDER)
	#enemy_minion_1.enemy_name = "Minion 1"
	#enemy_minion_1.enemy_texture_path = "external/sprites/enemies/enemy_purple_small.png"
	#enemy_minion_1.enemy_is_minion = true
	#enemy_minion_1.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack": 1})
	#])
	#enemy_minion_1.add_intent_state([
		#EnemyIntentData.new("intent_attack", DIFFICULTY_STARTING, 5, 1, "", 0, "", {"intent_attack": 1}),
		#EnemyIntentData.new("intent_attack", DIFFICULTY_BOSS_ENEMIES_HARDER, 8, 1, "", 5, "", {"intent_attack": 1}),
		#])
	#
	#var _enemy_minion_1_anim: AnimationData = enemy_minion_1.add_standard_animations(
		#["external/sprites/enemies/enemy_purple_small.png"]
	#)
	#
	#Global.register_rod(enemy_minion_1)
	#
	## example of minion enemy
	#var enemy_minion_2: EnemyData = EnemyData.new("enemy_minion_2")
	#enemy_minion_2.add_health_bounds(3, 5)
	#enemy_minion_2.add_health_bounds(6, 8, DIFFICULTY_BOSS_ENEMIES_HARDER)
	#enemy_minion_2.enemy_name = "Minion 2"
	#enemy_minion_2.enemy_texture_path = "external/sprites/enemies/enemy_green_small.png"
	#enemy_minion_2.enemy_is_minion = true
	#enemy_minion_2.add_intent_state([
		#EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_attack": 1})
		#])
	#enemy_minion_2.add_intent_state([
		#EnemyIntentData.new("intent_attack", DIFFICULTY_STARTING, 3, 1, "", 5, "", {"intent_attack": 1}),
		#EnemyIntentData.new("intent_attack", DIFFICULTY_BOSS_ENEMIES_HARDER, 5, 1, "", 5, "", {"intent_attack": 1}),
		#])
	#
	#var _enemy_minion_2_anim: AnimationData = enemy_minion_2.add_standard_animations(
		#["external/sprites/enemies/enemy_green_small.png"]
	#)
	#
	#Global.register_rod(enemy_minion_2)

#endregion

#region Player Data Prototypes

func add_player_data() -> void:
	var player_red: PlayerData = PlayerData.new("player_red")
	player_red.player_character_object_id = "character_red"
	
	Global.register_rod(player_red)
	
	var player_blue: PlayerData = PlayerData.new("player_blue")
	player_blue.player_character_object_id = "character_blue"
	
	Global.register_rod(player_blue)
	
	var player_green: PlayerData = PlayerData.new("player_green")
	player_green.player_character_object_id = "character_green"
	
	Global.register_rod(player_green)
	
	var player_orange: PlayerData = PlayerData.new("player_orange")
	player_orange.player_character_object_id = "character_orange"
	
	Global.register_rod(player_orange)

#endregion

#region Card Decorators
func add_card_decorators() -> void:
	# decorator that changes card cost based on combat stats
	var card_decorator_dynamic_cost_modifier: CardDecoratorData = CardDecoratorData.new("card_decorator_dynamic_cost_modifier")
	card_decorator_dynamic_cost_modifier.card_decorator_script_path = Scripts.DECORATOR_DYNAMIC_COST_MODIFIER
	
	Global.register_rod(card_decorator_dynamic_cost_modifier)
	
	# decorator that modifies card_values based on combat stats
	var card_decorator_dynamic_value_modifier: CardDecoratorData = CardDecoratorData.new("card_decorator_dynamic_value_modifier")
	card_decorator_dynamic_value_modifier.card_decorator_script_path = Scripts.DECORATOR_DYNAMIC_VALUE_MODIFIER
	
	Global.register_rod(card_decorator_dynamic_value_modifier)
	
	# decorator that applies block on card play
	# applies a custom decorator value to the card and displays the number on the decorator
	var card_decorator_block_on_play: CardDecoratorData = CardDecoratorData.new("card_decorator_block_on_play")
	card_decorator_block_on_play.card_decorator_texture_path = "external/sprites/card_decorators/purple_decorator.png"
	card_decorator_block_on_play.card_decorator_value_improvements = {
		"decorator_value_block": 5
	}
	card_decorator_block_on_play.card_decorator_pre_description = "[center][color=purple]Block [decorator_value_block][/color][/center]\n"
	card_decorator_block_on_play.card_decorator_label_value_name = "decorator_value_block"
	card_decorator_block_on_play.card_decorator_add_keyword_ids = ["keyword_block"]
	card_decorator_block_on_play.card_decorator_pre_play_actions = 	[
	{
	Scripts.ACTION_BLOCK: 
		{
			# convert the decorator's block into actual block
			"custom_key_names": {"block": "decorator_value_block"},
			"time_delay": 0.5,
			"target_override": BaseAction.TARGET_OVERRIDES.PARENT
		}
	}]
	Global.register_rod(card_decorator_block_on_play)
	
	# decorator that removes exhaust from a card
	# should be combined with a validator to prevent it from being applied to a non exhausting card
	var card_decorator_remove_exhaust: CardDecoratorData = CardDecoratorData.new("card_decorator_remove_exhaust")
	card_decorator_remove_exhaust.card_decorator_texture_path = "external/sprites/card_decorators/yellow_decorator.png"
	card_decorator_remove_exhaust.card_decorator_property_changes = {
		"card_play_destination": HandManager.DISCARD_PILE
	}
	Global.register_rod(card_decorator_remove_exhaust)
	
	# decorator that draws extra cards when the card is drawn the first time
	# applies a custom decorator value to the card and displays the number on the decorator
	var card_decorator_extra_draw: CardDecoratorData = CardDecoratorData.new("card_decorator_extra_draw")
	card_decorator_extra_draw.card_decorator_texture_path = "external/sprites/card_decorators/green_decorator.png"
	card_decorator_extra_draw.card_decorator_value_changes = {
		# add a flag to the card used to check for first time
		"decorator_value_extra_draw": 2
	}
	card_decorator_extra_draw.card_decorator_post_description = "[center][color=green]Draw 2 cards when first drawn.[/color][/center]\n"
	card_decorator_extra_draw.card_decorator_label_value_name = "decorator_value_extra_draw"
	card_decorator_extra_draw.card_decorator_post_draw_actions = [
		{
			# check flag when drawn
			Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_VALUES: 
						{
						"card_value_name": "decorator_value_extra_draw",
						"operator": ">",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				# draw cards and change flag
				"passed_action_data": 
				[
					{
					Scripts.ACTION_CHANGE_CARD_VALUES: {
						"pick_played_card": true,
						"modify_parent_card": false,
						"new_card_values": {"decorator_value_extra_draw": 0}
						},
					},
					{Scripts.ACTION_DRAW_GENERATOR: {
						# alias the extra draw count
						"custom_key_names": {"draw_count": "decorator_value_extra_draw"}
					}},
				]
			}
		}
		]
	Global.register_rod(card_decorator_extra_draw)
#endregion

#region Cards

func add_cards() -> void:
	add_card_basics()
	add_cards_misc()
	add_cards_trade()
	add_cards_black()
	add_cards_green()
	add_cards_purple()
	add_cards_gold()

func add_card_basics() -> void:
	var colors: Array[String] = []
	
	for character_data: CharacterData in Global._id_to_character_data.values():
		colors.append(character_data.character_color_id.replace("color_", ""))
	
	for i: int in len(colors):
		# Basic attack card
		var card_basic_food: CardData = CardData.new("card_basic_food_{0}".format([colors[i]]))
		card_basic_food.card_name = "Basic Food"
		card_basic_food.card_color_id = "color_{0}".format([colors[i]])
		card_basic_food.card_description = "Gain [food_amount] food."
		card_basic_food.card_texture_path = "external/sprites/cards/{0}/card_basic_attack_{0}.png".format([colors[i]])
		card_basic_food.card_type = CardData.CARD_TYPES.SKILL
		card_basic_food.card_rarity = CardData.CARD_RARITIES.BASIC
		card_basic_food.card_keyword_object_ids = []
		card_basic_food.card_values = {"food_amount": 1}
		card_basic_food.card_upgrade_value_improvements = {"food_amount": 1}
		#card_basic_food.card_keyword_object_ids = ["keyword_food"]
		card_basic_food.card_requires_target = false
		card_basic_food.card_play_actions = [{
		Scripts.ACTION_ADD_FOOD: {},
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/slash.wav"},
		}]
		
		Global.register_rod(card_basic_food)
		
		# Basic block card
		var card_basic_ore: CardData = CardData.new("card_basic_ore_{0}".format([colors[i]]))
		card_basic_ore.card_name = "Basic Ore"
		card_basic_ore.card_color_id = "color_{0}".format([colors[i]])
		card_basic_ore.card_description = "Gain [ore_amount] Ore"
		card_basic_ore.card_texture_path = "external/sprites/cards/{0}/card_basic_block_{0}.png".format([colors[i]])
		card_basic_ore.texture_bg_path = "external/sprites/cards/frames/basicframe.png"
		card_basic_ore.card_type = CardData.CARD_TYPES.SKILL
		card_basic_ore.card_rarity = CardData.CARD_RARITIES.BASIC
		card_basic_ore.card_requires_target = false
		#card_basic_ore.card_keyword_object_ids = ["keyword_ore"]
		card_basic_ore.card_values = {"ore_amount": 1}
		card_basic_ore.card_upgrade_value_improvements = {"ore_amount": 1}
		card_basic_ore.card_play_actions = [{
		Scripts.ACTION_ADD_ORE: {}
		}]
		
		Global.register_rod(card_basic_ore)

#region generated
## Adds cards that have not yet been sorted into a color
func add_cards_misc() -> void:
	var color: String = "white"
	# energy_next_turn
	var card_fish: CardData = CardData.new("card_fish")
	card_fish.card_name = "Fish"
	card_fish.card_color_id = "color_{0}".format([color])
	card_fish.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_fish.card_description = "Gain [food_amount] Food. Exhaust. When it reaches the discard pile, improve 1 Food Value."
	card_fish.card_type = CardData.CARD_TYPES.SKILL
	card_fish.card_energy_cost = 0
	card_fish.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_fish.card_requires_target = false
	card_fish.card_play_destination = HandManager.EXHAUST_PILE
	card_fish.card_values = {"food_amount": 1, "card_value_improvements": {"food_amount": 1}}
	card_fish.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD: 
			{
			}
		}
		]
	card_fish.card_end_of_turn_actions = [
		{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
		}
		]		
	card_fish.card_discard_actions = [
		{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
		}
		]	
	Global.register_rod(card_fish)
	
	var card_grain: CardData = CardData.new("card_grain")
	card_grain.card_name = "Grain"
	card_grain.card_color_id = "color_{0}".format([color])
	card_grain.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_grain.card_description = "Gain [food_amount] Food. Exhaust. When it reaches the discard pile, improve 1 Food Value."
	card_grain.card_type = CardData.CARD_TYPES.SKILL
	card_grain.card_energy_cost = 0
	card_grain.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_grain.card_requires_target = false
	card_grain.card_play_destination = HandManager.EXHAUST_PILE
	card_grain.card_values = {"food_amount": 1, "card_value_improvements": {"food_amount": 1}}
	card_grain.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD: 
			{
			}
		}
		]
	card_grain.card_end_of_turn_draw_pile_actions = [
		{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
		}
		]		

	Global.register_rod(card_grain)

	var card_rock: CardData = CardData.new("card_rock")
	card_rock.card_name = "Rock"
	card_rock.card_color_id = "color_{0}".format([color])
	card_rock.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_rock.card_description = "Gain [ore_amount] Ore."
	card_rock.card_type = CardData.CARD_TYPES.SKILL
	card_rock.card_energy_cost = 0
	card_rock.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_rock.card_requires_target = false
	card_rock.card_play_destination = HandManager.EXHAUST_PILE
	card_rock.card_values = {"ore_amount": 1}
	card_rock.card_play_actions = [
		{
			Scripts.ACTION_ADD_ORE: 
			{
			}
		}
		]

	Global.register_rod(card_rock)
	
	var card_sword: CardData = CardData.new("card_sword")
	card_sword.card_name = "Sword"
	card_sword.card_color_id = "color_{0}".format([color])
	card_sword.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_sword.card_description = "Gain [ore_amount] Ore and [damage] Explore. Durability 2."
	card_sword.card_type = CardData.CARD_TYPES.ATTACK
	card_sword.card_energy_cost = 0
	card_sword.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_sword.card_durability = 2
	card_sword.card_requires_target = true
	card_sword.card_values = {"damage": 1, "number_of_attacks": 1, "ore_amount": 1, "card_durability": -1}
	card_sword.card_play_actions = [
		{
			Scripts.ACTION_ATTACK_GENERATOR: 
			{
				"time_delay": 0.0, "actions_on_lethal": []
			},
			Scripts.ACTION_ADD_ORE:
				{
					
				},
			Scripts.ACTION_CHANGE_CARD_DURABILITY:
				{
				"pick_played_card": true,
				"modify_parent_card": false,
				},
			# check flag when drawn
			Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_durability",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				# exhaust
				"passed_action_data": 
				[
					{
					Scripts.ACTION_CHANGE_CARD_PLAY_DESTINATION: {
						"card_destination": HandManager.EXHAUST_PILE,
						"card_destination_strategy": HandManager.PILE_INSERTION_STRATEGIES.TOP
						},
					},
				]
			}
		}
		]
	
	Global.register_rod(card_sword)
	
	var card_treasure: CardData = CardData.new("card_treasure")
	card_treasure.card_name = "Treasure"
	card_treasure.card_color_id = "color_{0}".format([color])
	card_treasure.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_treasure.card_description = "Gain [money_amount] Money. Durability 3."
	card_treasure.card_type = CardData.CARD_TYPES.SKILL
	card_treasure.card_energy_cost = 0
	card_treasure.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_treasure.card_durability = 3
	card_treasure.card_requires_target = false
	card_treasure.card_values = {"money_amount": 1, "card_durability": -1}
	card_treasure.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY: 
			{
			},
			Scripts.ACTION_CHANGE_CARD_DURABILITY:
			{
				"pick_played_card": true,
				"modify_parent_card": false,
			},
			# check flag when drawn
			Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_durability",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				# exhaust
				"passed_action_data": 
				[
					{
					Scripts.ACTION_CHANGE_CARD_PLAY_DESTINATION: {
						"card_destination": HandManager.EXHAUST_PILE,
						"card_destination_strategy": HandManager.PILE_INSERTION_STRATEGIES.TOP
						},
					},
				]
			}
		}
		]
	
	Global.register_rod(card_treasure)
	
		
	var card_spice: CardData = CardData.new("card_spice")
	card_spice.card_name = "Spice"
	card_spice.card_color_id = "color_{0}".format([color])
	card_spice.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_spice.card_description = "Gain [money_amount] Money. Durability 1."
	card_spice.card_type = CardData.CARD_TYPES.SKILL
	card_spice.card_energy_cost = 0
	card_spice.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_spice.card_durability = 3
	card_spice.card_requires_target = false
	card_spice.card_values = {"money_amount": 1, "card_durability": -1, "card_value_improvements": {"money_amount": 1}}
	card_spice.card_discard_actions = [
		{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
		}
		]	
	card_spice.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY: 
			{
			},
			Scripts.ACTION_CHANGE_CARD_DURABILITY:
				{},
			# check flag when drawn
			
			Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_durability",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				# exhaust
				"passed_action_data": 
				[
					{
					Scripts.ACTION_CHANGE_CARD_PLAY_DESTINATION: {
						"card_destination": HandManager.EXHAUST_PILE,
						"card_destination_strategy": HandManager.PILE_INSERTION_STRATEGIES.TOP
						},
					},
				]
			}
		}
		]
	
	Global.register_rod(card_spice)
			
	var card_rebel: CardData = CardData.new("card_rebel")
	card_rebel.card_name = "Rebel"
	card_rebel.card_color_id = "color_{0}".format([color])
	card_rebel.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_rebel.card_description = "Lose [food_amount] Food."
	card_rebel.card_type = CardData.CARD_TYPES.SKILL
	card_rebel.card_energy_cost = 0
	card_rebel.card_durability = 0
	card_rebel.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_rebel.card_requires_target = false
	card_rebel.card_is_playable = false
	card_rebel.card_values = {"food_amount": -1, "card_durability":-1}
	card_rebel.card_end_of_turn_actions = [
			{
				Scripts.ACTION_ADD_FOOD: 
			{
			}}]
	
	Global.register_rod(card_rebel)
	
	var card_blueprint: CardData = CardData.new("card_blueprint")
	card_blueprint.card_name = "Blueprint"
	card_blueprint.card_color_id = "color_{0}".format([color])
	card_blueprint.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_blueprint.card_description = "Spend 8 Ore to draft 1 Artifact."
	card_blueprint.card_type = CardData.CARD_TYPES.SKILL
	card_blueprint.card_energy_cost = 0
	card_blueprint.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_blueprint.card_play_destination = HandManager.EXHAUST_PILE
	card_blueprint.card_requires_target = false
	card_blueprint.card_values = {"ore_amount": -8}
	card_blueprint.card_play_actions = [
		{
			Scripts.ACTION_VALIDATOR:
			{
				"validator_data":[{Scripts.VALIDATOR_ORE:{"ore_amount":8}}],
				"action_data":[{Scripts.ACTION_ADD_ORE:{"ore_amount":-8}},
				{
				Scripts.ACTION_ADD_ARTIFACTS_FROM_POOL:
				{
					"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
					"artifact_count": 1,
					"artifact_rarities": [ArtifactData.ARTIFACT_RARITIES.COMMON]
				}
				}]
			},
		}]
	
	Global.register_rod(card_spice)
#endregion

func add_cards_trade() -> void:
#region Trade
	var color: String = "grey"
	var card_trade1: CardData = CardData.new("card_trade1")
	card_trade1.card_name = "Trade1"
	card_trade1.card_color_id = "color_{0}".format([color])
	card_trade1.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_trade1.card_description = "Lose [ore_amount] Ore. Gain [money_amount] Money."
	card_trade1.card_type = CardData.CARD_TYPES.SKILL
	card_trade1.card_energy_cost = 0
	card_trade1.card_rarity = CardData.CARD_RARITIES.TRADE
	card_trade1.card_requires_target = false
	card_trade1.card_play_destination = HandManager.EXHAUST_PILE
	card_trade1.card_values = {"ore_amount": randi_range(-2, -3),"money_amount":randi_range(4, 6)}
	card_trade1.card_play_actions = [
		{
			Scripts.ACTION_ADD_ORE: 
			{
			}
		},
		{
			Scripts.ACTION_ADD_MONEY:
			{				
			}
		}]
	Global.register_rod(card_trade1)
	
	var card_trade2: CardData = CardData.new("card_trade2")
	card_trade2.card_name = "Trade2"
	card_trade2.card_color_id = "color_{0}".format([color])
	card_trade2.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_trade2.card_description = "Lose [food_amount] Food. Gain [money_amount] Money."
	card_trade2.card_type = CardData.CARD_TYPES.SKILL
	card_trade2.card_energy_cost = 0
	card_trade2.card_rarity = CardData.CARD_RARITIES.TRADE
	card_trade2.card_requires_target = false
	card_trade2.card_play_destination = HandManager.EXHAUST_PILE
	card_trade2.card_values = {"food_amount": randi_range(-4, -8),"money_amount":randi_range(9, 12)}
	card_trade2.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD: 
			{
			}
		},
		{
			Scripts.ACTION_ADD_MONEY:
			{				
			}
		}]
	Global.register_rod(card_trade2)
	
	var card_trade3: CardData = CardData.new("card_trade3")
	card_trade3.card_name = "Trade3"
	card_trade3.card_color_id = "color_{0}".format([color])
	card_trade3.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_trade3.card_description = "Lose [insight_amount] Insight. Gain [money_amount] Money."
	card_trade3.card_type = CardData.CARD_TYPES.SKILL
	card_trade3.card_energy_cost = 0
	card_trade3.card_rarity = CardData.CARD_RARITIES.TRADE
	card_trade3.card_requires_target = false
	card_trade3.card_play_destination = HandManager.EXHAUST_PILE
	card_trade3.card_values = {"insight_amount": randi_range(-2, -3),"money_amount":randi_range(9, 15)}
	card_trade3.card_play_actions = [
		{
			Scripts.ACTION_ADD_INSIGHT: 
			{
			}
		},
		{
			Scripts.ACTION_ADD_MONEY:
			{				
			}
		}]
	Global.register_rod(card_trade3)
#endregion
func add_cards_purple() -> void:
	var color: String = "purple"

	#region Pearl
	
	var card_cunningtrader: CardData = CardData.new("card_cunningtrader")
	card_cunningtrader.card_name = "Cunning Trader"
	card_cunningtrader.card_color_id = "color_{0}".format([color])
	card_cunningtrader.card_texture_path = "external/sprites/cards/pearl/02_cunningtrader.png"
	card_cunningtrader.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_cunningtrader.card_description = "Gains [ore_amount] Ore."
	card_cunningtrader.card_type = CardData.CARD_TYPES.SKILL
	card_cunningtrader.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cunningtrader.card_requires_target = false
	card_cunningtrader.card_energy_cost = 1
	card_cunningtrader.card_values = {"card_influence": -3,"ore_amount": 3}
	card_cunningtrader.card_upgrade_value_improvements = {"ore_amount": 2}
	card_cunningtrader.card_influence = 3
	card_cunningtrader.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ADD_ORE: {},
		}
	]
	card_cunningtrader.card_end_of_turn_actions = [{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence": 1,
			"pick_played_card": true,
			"modify_parent_card": false,
		}
	}]
	
	Global.register_rod(card_cunningtrader)
	
	var card_pearlemissary: CardData = CardData.new("card_pearlemissary")
	card_pearlemissary.card_name = "Pearl Emissary"
	card_pearlemissary.card_color_id = "color_{0}".format([color])
	card_pearlemissary.card_texture_path = "external/sprites/cards/pearl/01_pearlemissary.png"
	card_pearlemissary.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlemissary.card_description = "Draws [draw_count] cards. Appeases 2 random cards in discard piles when discarded."
	card_pearlemissary.card_type = CardData.CARD_TYPES.SKILL
	card_pearlemissary.card_rarity = CardData.CARD_RARITIES.COMMON
	card_pearlemissary.card_requires_target = false
	card_pearlemissary.card_energy_cost = 1
	card_pearlemissary.card_values = {"card_influence": 1,"draw_count": 2}
	card_pearlemissary.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlemissary.card_influence = 1
	card_pearlemissary.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {},
		}]
	card_pearlemissary.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	card_pearlemissary.card_discard_actions = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 2,
		"max_card_amount": 2,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
				"card_influence": 1,
				"pick_played_card": true
			}},
			]
		}
	}]
	
	Global.register_rod(card_pearlemissary)
	
	var card_joyfulsailor: CardData = CardData.new("card_joyfulsailor")
	card_joyfulsailor.card_name = "Joyful Sailor"
	card_joyfulsailor.card_color_id = "color_{0}".format([color])
	card_joyfulsailor.card_texture_path = "external/sprites/cards/pearl/03_joyfulsailor.png"
	card_joyfulsailor.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_joyfulsailor.card_description = "Explore [damage], Draw [draw_count], Create a Fish."
	card_joyfulsailor.card_type = CardData.CARD_TYPES.SKILL
	card_joyfulsailor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_joyfulsailor.card_requires_target = true
	card_joyfulsailor.card_energy_cost = 1
	card_joyfulsailor.card_values = {"card_influence": 1,"damage": 1,"number_of_attacks": 1, "draw_count": 1,"created_card_object_id": "card_fish", "number_of_cards": 1}
	card_joyfulsailor.card_upgrade_value_improvements = {"damage": 1}
	card_joyfulsailor.card_influence = 3
	card_joyfulsailor.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR: 
			{
				"time_delay": 0.0, "actions_on_lethal": []
			},
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
			}
		}
	]
	card_joyfulsailor.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_joyfulsailor)	
	
	var card_storiedspinner: CardData = CardData.new("card_storiedspinner")
	card_storiedspinner.card_name = "Storied Spinner"
	card_storiedspinner.card_color_id = "color_{0}".format([color])
	card_storiedspinner.card_texture_path = "external/sprites/cards/pearl/04_storiedspinner.png"
	card_storiedspinner.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_storiedspinner.card_description = "Draw [draw_count]. Create [number_of_cards] Spice."
	card_storiedspinner.card_type = CardData.CARD_TYPES.SKILL
	card_storiedspinner.card_rarity = CardData.CARD_RARITIES.COMMON
	card_storiedspinner.card_requires_target = false
	card_storiedspinner.card_energy_cost = 1
	card_storiedspinner.card_values = {"card_influence": 1,"draw_count": 1,"created_card_object_id": "card_spice",  "number_of_cards": 1}
	card_storiedspinner.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_storiedspinner.card_influence = 3
	card_storiedspinner.card_play_actions = [{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {},
		},
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
			}
		}
	]
	card_storiedspinner.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]	
	Global.register_rod(card_storiedspinner)
	
	
	var card_recklessenvoy: CardData = CardData.new("card_recklessenvoy")
	card_recklessenvoy.card_name = "Reckless Envoy"
	card_recklessenvoy.card_color_id = "color_{0}".format([color])
	card_recklessenvoy.card_texture_path = "external/sprites/cards/pearl/05_recklessenvoy.png"
	card_recklessenvoy.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_recklessenvoy.card_description = "Explore [damage] Divinations into your draw pile."
	card_recklessenvoy.card_type = CardData.CARD_TYPES.ATTACK
	card_recklessenvoy.card_rarity = CardData.CARD_RARITIES.COMMON
	card_recklessenvoy.card_requires_target = true
	card_recklessenvoy.card_energy_cost = 1
	card_recklessenvoy.card_values = {"card_influence": 1,"damage": 3, "number_of_attacks":1,"ore_amount":-2, "created_card_object_id": "card_spice",  "number_of_cards": 1}
	card_recklessenvoy.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_recklessenvoy.card_influence = 3
	card_recklessenvoy.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR: 
			{
				"time_delay": 0.0, "actions_on_lethal": []
			},
		},
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_VALIDATOR: {
			"validator_data": [
				{
				Scripts.VALIDATOR_ORE: {"ore_amount": 2}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_ADD_ORE:
				{
				}
				},
				{
				Scripts.ACTION_CREATE_CARDS:
				{
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
				}
				}
			]
		}

		}
	]
	card_recklessenvoy.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_recklessenvoy)
	
	var card_pearldiplomat: CardData = CardData.new("card_pearldiplomat")
	card_pearldiplomat.card_name = "Pearl Diplomat"
	card_pearldiplomat.card_color_id = "color_{0}".format([color])
	card_pearldiplomat.card_texture_path = "external/sprites/cards/pearl/06_pearldiplomat.png"
	card_pearldiplomat.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearldiplomat.card_description = "Create [number_of_cards] Spice. Appease [number_of_cards] Cards in discard pile."
	card_pearldiplomat.card_type = CardData.CARD_TYPES.SKILL
	card_pearldiplomat.card_rarity = CardData.CARD_RARITIES.COMMON
	card_pearldiplomat.card_requires_target = false
	card_pearldiplomat.card_energy_cost = 1
	card_pearldiplomat.card_values = {"card_influence": 1,"created_card_object_id": "card_spice",  "number_of_cards": 1}
	card_pearldiplomat.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_pearldiplomat.card_influence = 3
	card_pearldiplomat.card_play_actions = [{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 2,
		"max_card_amount": 2,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_TYPE: {"card_types": [CardData.CARD_TYPES.SKILL]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence": 1
			}},
			]
		}
		}
	]
	card_pearldiplomat.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_pearldiplomat)
	
	var card_pearlregaler: CardData = CardData.new("card_pearlregaler")
	card_pearlregaler.card_name = "Pearl Regaler"
	card_pearlregaler.card_color_id = "color_{0}".format([color])
	card_pearlregaler.card_texture_path = "external/sprites/cards/pearl/07_pearlregalerpng"
	card_pearlregaler.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlregaler.card_description = "Consume [money_amount] Money to gain 1 Insight. Upgrade 1 card."
	card_pearlregaler.card_type = CardData.CARD_TYPES.SKILL
	card_pearlregaler.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlregaler.card_requires_target = false
	card_pearlregaler.card_energy_cost = 1
	card_pearlregaler.card_values = {"card_influence": 1,"money_amount":-2, "insight_amount":1}
	card_pearlregaler.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_pearlregaler.card_influence = 3
	card_pearlregaler.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_VALIDATOR: {
			"validator_data": [
				{
				Scripts.VALIDATOR_ORE: {"money_amount": 2}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_ADD_MONEY:
				{
				}
				},
				{
				Scripts.ACTION_ADD_INSIGHT:
				{
				}
				}
			]
		}
		},
		{
		Scripts.ACTION_VALIDATOR: 
			{
				"validator_data": [{Scripts.VALIDATOR_INSIGHT:{ "insight_amount": 1}}],
				"passed_action_data": [{
					Scripts.ACTION_PICK_UPGRADE_CARDS: {
					"min_card_amount": 1,
					"max_card_amount": 1,
					"min_cards_are_required_for_action": true,
					"random_selection": false,
					"card_pick_type": HandManager.HAND_PILE,
					"card_pick_text": "Choose up to {0} card(s) to discard. {1} cards selected",
					"validator_data": [
					{Scripts.VALIDATOR_CARD_UPGRADEABLE: {}},
					],
					"action_data": [
						{Scripts.ACTION_ADD_INSIGHT: {"insight_amount":-1}}
					]
					}
				}]
			}
		}
	]
	card_pearlregaler.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_pearlregaler)
	
		
	var card_flintlockaccountant: CardData = CardData.new("card_flintlockaccountant")
	card_flintlockaccountant.card_name = "Flintlock Accountant"
	card_flintlockaccountant.card_color_id = "color_{0}".format([color])
	card_flintlockaccountant.card_texture_path = "external/sprites/cards/pearl/08_flintlockaccountant.png"
	card_flintlockaccountant.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_flintlockaccountant.card_description = "Return 2 Crafts from your discard pile to your hand. Increase 2 Durability to selected cards."
	card_flintlockaccountant.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockaccountant.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_flintlockaccountant.card_requires_target = false
	card_flintlockaccountant.card_energy_cost = 1
	card_flintlockaccountant.card_values = {"card_influence": 1, "max_card_amount": 2}
	card_flintlockaccountant.card_upgrade_value_improvements = {"max_card_amount": 1}
	card_flintlockaccountant.card_influence = 3
	card_flintlockaccountant.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_PICK_CARDS: 
			{
			"min_card_amount": 1,
			"min_cards_are_required_for_action": true,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to discard. {1} cards selected",
			"validator_data": [
			{Scripts.VALIDATOR_CARD_TYPE: {"card_types": [CardData.CARD_RARITIES.GENERATED]}}
			],
			"action_data": [
			{Scripts.ACTION_CHANGE_CARD_DURABILITY: {"card_durability": 2
			}},
			]
			}
		}
	]
	card_flintlockaccountant.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_flintlockaccountant)
	
	var card_pearlscribe: CardData = CardData.new("card_pearlscribe")
	card_pearlscribe.card_name = "Pearl Scribe"
	card_pearlscribe.card_color_id = "color_{0}".format([color])
	card_pearlscribe.card_texture_path = "external/sprites/cards/pearl/09_pearlscribe"
	card_pearlscribe.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlscribe.card_description = "If you have draw pile 20 or more, gain [insight_amount] Insight."
	card_pearlscribe.card_type = CardData.CARD_TYPES.SKILL
	card_pearlscribe.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlscribe.card_requires_target = false
	card_pearlscribe.card_energy_cost = 1
	card_pearlscribe.card_values = {"card_influence": 1, "insight_amount": 2}
	card_pearlscribe.card_upgrade_value_improvements = {"insight_amount": 1}
	card_pearlscribe.card_influence = 3
	card_pearlscribe.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_VALIDATOR: 
			{
			"validator_data": [
			{Scripts.VALIDATOR_PILE_SIZE: {"card_pick_type": HandManager.DRAW_PILE, "operator":">=","comparison_value":30}}
			],
			"action_data": [
			{Scripts.ACTION_ADD_INSIGHT: {
			}},
			]
			}
		}
	]
	card_pearlscribe.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_pearlscribe)
	
	var card_pearlsmuggler: CardData = CardData.new("card_pearlsmuggler")
	card_pearlsmuggler.card_name = "Pearl Scribe"
	card_pearlsmuggler.card_color_id = "color_{0}".format([color])
	card_pearlsmuggler.card_texture_path = "external/sprites/cards/pearl/10_pearlsmuggler.png"
	card_pearlsmuggler.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlsmuggler.card_description = "Draw [draw_count], discard 2. Wield 3"
	card_pearlsmuggler.card_type = CardData.CARD_TYPES.SKILL
	card_pearlsmuggler.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlsmuggler.card_requires_target = false
	card_pearlsmuggler.card_energy_cost = 1
	card_pearlsmuggler.card_values = {"card_influence": -1, "draw_count": 2}
	card_pearlsmuggler.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlsmuggler.card_influence = 3
	card_pearlsmuggler.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}},
		{
		Scripts.ACTION_DRAW_GENERATOR:{
		}
		},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount": 2,
			"max_card_amount": 2,
			"min_cards_are_required_for_action": true,
			"random_selection": false,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to discard. {1} cards selected",
			"action_data": [
			{Scripts.ACTION_DISCARD_CARDS: {}
			}
			]
		}},
		{
		Scripts.ACTION_VALIDATOR:
			{
				"validator_data": [{
					Scripts.VALIDATOR_MONEY: {
						"money_amount": 0, "operator": ">="
					}
				}],
				"action_data": [{		
					Scripts.ACTION_PICK_CARDS:
				{
				"min_card_amount": 3,
				"max_card_amount": 3,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.GENERATED]}}],
				"action_data": [{Scripts.ACTION_PLAY_CARDS:{}}]
			}}]
			}	
		}
	]
	card_pearlsmuggler.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_pearlsmuggler)
	
	var card_pearlseer: CardData = CardData.new("card_pearlseer")
	card_pearlseer.card_name = "Pearl Seer"
	card_pearlseer.card_color_id = "color_{0}".format([color])
	card_pearlseer.card_texture_path = "external/sprites/cards/pearl/11_pearlseer.png"
	card_pearlseer.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlseer.card_description = "Draw [draw_count], then gain [money_amount] Money for each generated card in hand."
	card_pearlseer.card_type = CardData.CARD_TYPES.SKILL
	card_pearlseer.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlseer.card_requires_target = false
	card_pearlseer.card_energy_cost = 1
	card_pearlseer.card_values = {"card_influence": 1, "draw_count": 2, "money_amount": 1}
	card_pearlseer.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlseer.card_influence = 3
	card_pearlseer.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount": 99,
			"max_card_amount": 99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to discard. {1} cards selected",
			"validator_data": [{
				Scripts.VALIDATOR_CARD_RARITY: {Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.GENERATED]}}
			}],
			"action_data": [
			{Scripts.ACTION_ADD_MONEY: {}
			}
			]
		}}
	]
	card_pearlseer.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_pearlseer)
	
	
	var card_mastertactician: CardData = CardData.new("card_mastertactician")
	card_mastertactician.card_name = "Master Tactician"
	card_mastertactician.card_color_id = "color_{0}".format([color])
	card_mastertactician.card_texture_path = "external/sprites/cards/pearl/12_mastertactician.png"
	card_mastertactician.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_mastertactician.card_description = "Create [number_of_cards] Swords. Wield [min_card_amount]."
	card_mastertactician.card_type = CardData.CARD_TYPES.SKILL
	card_mastertactician.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_mastertactician.card_requires_target = true
	card_mastertactician.card_energy_cost = 1
	card_mastertactician.card_values = {"card_influence": 1, "created_card_object_id": "card_sword", "number_of_cards": 2,	"min_card_amount": 3,
				"max_card_amount": 3,}
	card_mastertactician.card_upgrade_value_improvements = {"number_of_cards":1, "min_card_amount": 1,
				"max_card_amount": 1,}
	card_mastertactician.card_influence = 3
	card_mastertactician.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
			}
		},
		{		
		Scripts.ACTION_PICK_CARDS:
			{
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.GENERATED]}}],
				"action_data": [{Scripts.ACTION_PLAY_CARDS:{}}]
		}}
	]
	card_mastertactician.card_end_of_turn_actions = [
			{
				Scripts.ACTION_VALIDATOR: {
				"validator_data":
				[
					{
					Scripts.VALIDATOR_CARD_PROPERTIES: 
						{
						"card_property_name": "card_influence",
						"operator": "<=",
						"comparison_value": 0,
						"invert_validation": false,
						}
					}
				],
				"passed_action_data": 
				[
					{
					Scripts.ACTION_TRANSFORM_CARDS: {
						"transform_into_card_object_id": "card_rebel",
						"pick_played_card": true
						},
					},
				]
				}
			},
			{
				Scripts.ACTION_CHANGE_CARD_INFLUENCE:
					{
						"pick_played_card": true,
						"card_influence": -1
					}
			}
		]
	Global.register_rod(card_mastertactician)
	
	var card_schemingplanner: CardData = CardData.new("card_schemingplanner")
	card_schemingplanner.card_name = "Scheming Planner"
	card_schemingplanner.card_color_id = "color_{0}".format([color])
	card_schemingplanner.card_texture_path = "external/sprites/cards/13_schemingplanner.png"
	card_schemingplanner.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_schemingplanner.card_description = "Gain [money_amount] Money. Refresh Shop."
	card_schemingplanner.card_type = CardData.CARD_TYPES.SKILL
	card_schemingplanner.card_rarity = CardData.CARD_RARITIES.RARE
	card_schemingplanner.card_requires_target = false
	card_schemingplanner.card_energy_cost = 1
	card_schemingplanner.card_values = {"card_influence": 1, "money_amount": 3}
	card_schemingplanner.card_upgrade_value_improvements = {"money_amount": 2}
	card_schemingplanner.card_influence = 3
	card_schemingplanner.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ADD_MONEY: {
		}
		}
	]
	card_schemingplanner.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_schemingplanner)
	
	var card_courthand: CardData = CardData.new("card_courthand")
	card_courthand.card_name = "Court Hand"
	card_courthand.card_color_id = "color_{0}".format([color])
	card_courthand.card_texture_path = "external/sprites/cards/pearl/14_courthand.png"
	card_courthand.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_courthand.card_description = "Create 1 Performance."
	card_courthand.card_type = CardData.CARD_TYPES.SKILL
	card_courthand.card_rarity = CardData.CARD_RARITIES.RARE
	card_courthand.card_requires_target = false
	card_courthand.card_energy_cost = 1
	card_courthand.card_values = {"card_influence": 1, "created_card_object_id": "card_performance", "number_of_cards": 1}
	card_courthand.card_upgrade_value_improvements = {"number_of_cards":1}
	card_courthand.card_influence = 3
	card_courthand.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK:{}}]
			}
		}
	]
	card_courthand.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_courthand)
	
	var card_wizenedcommander: CardData = CardData.new("card_wizenedcommander")
	card_wizenedcommander.card_name = "Court Hand"
	card_wizenedcommander.card_color_id = "color_{0}".format([color])
	card_wizenedcommander.card_texture_path = "external/sprites/cards/pearl/15_wizenedcommander.png"
	card_pearlemissary.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_wizenedcommander.card_description = "Create 1 Performance."
	card_wizenedcommander.card_type = CardData.CARD_TYPES.SKILL
	card_wizenedcommander.card_rarity = CardData.CARD_RARITIES.RARE
	card_wizenedcommander.card_requires_target = false
	card_wizenedcommander.card_energy_cost = 1
	card_wizenedcommander.card_values = {"card_influence": 1, "damage": 1}
	card_wizenedcommander.card_upgrade_value_improvements = {"number_of_cards":1}
	card_wizenedcommander.card_influence = 3
	card_wizenedcommander.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities": [CardData.CARD_RARITIES.GENERATED]}}],
				"action_data": [{Scripts.ACTION_VARIABLE_CARDSET_MODIFIER: {
				"multiplied_values": ["damage"],
				"action_data": [{Scripts.ACTION_ATTACK_GENERATOR: {
					"time_delay": 0.5
					}}]}
			}]
		}}
	]
	card_wizenedcommander.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_wizenedcommander)
	
#endregion

	#region Generated Cards
	var card_performance: CardData = CardData.new("card_performance")
	card_performance.card_name = "Performance"
	card_performance.card_color_id = "color_{0}".format([color])
	card_performance.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_performance.card_description = "Appeases all cards in discard pile."
	card_performance.card_type = CardData.CARD_TYPES.SKILL
	card_performance.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_performance.card_requires_target = false
	card_performance.card_energy_cost = 0
	card_performance.card_values = {"influence_count": 1}
	card_performance.card_upgrade_value_improvements = {"influence_count": 1}
	card_performance.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
				"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {}}]
		}}
	]
	
	Global.register_rod(card_performance)
	#endregion
	
	#region aniseed
func add_cards_black() -> void:
	var color: String = "black"
	
	var card_aniseedemissary: CardData = CardData.new("card_aniseedemissary")
	card_aniseedemissary.card_name = "aniseed Emissary"
	card_aniseedemissary.card_color_id = "color_{0}".format([color])
	card_aniseedemissary.card_texture_path = "external/sprites/cards/aniseed/01_aniseedemissary.png"
	card_aniseedemissary.card_description = "Gains [ore_amount] Ore. Inspect."
	card_aniseedemissary.card_type = CardData.CARD_TYPES.SKILL
	card_aniseedemissary.card_rarity = CardData.CARD_RARITIES.COMMON
	card_aniseedemissary.card_requires_target = false
	card_aniseedemissary.card_energy_cost = 1
	card_aniseedemissary.card_values = {"card_influence": -3,"ore_amount": 3}
	card_aniseedemissary.card_upgrade_value_improvements = {"ore_amount": 2}
	card_aniseedemissary.card_influence = 3
	card_aniseedemissary.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedemissary.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ADD_ORE: {},
		},
				{
		Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount": 1,
				"max_card_amount": 1,
				"min_cards_are_required_for_action": true,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_rock"}}],
				"action_data": [{
				Scripts.ACTION_VALIDATOR:
				{
				"validator_data":
					[{Scripts.VALIDATOR_PILE_SIZE:
						{"card_pick_type":HandManager.EXHAUST_PILE,
						"operator":">=",
						"comparison_value": 5}}],
				"passed_action_data":
					[{
						Scripts.ACTION_IMPROVE_CARD_VALUES: {
						"card_value_improvements":{"ore_amount":1},
						"time_delay": 0.1,
						"pick_played_card": true,
						"modify_parent_card": false,
						}},
						{
						Scripts.ACTION_VALIDATOR:
						{
						"validator_data":
							[{Scripts.VALIDATOR_PILE_SIZE:
							{"card_pick_type":HandManager.EXHAUST_PILE,
							"operator":">=",
							"comparison_value": 15}}],
						"passed_action_data":
							[{
							Scripts.ACTION_IMPROVE_CARD_VALUES: {
							"card_value_improvements":{"ore_amount":2},
							"time_delay": 0.1,
							"pick_played_card": true,
							"modify_parent_card": false,
						}}],	
						}					
					}]
				}
		}]}
		}]
	card_aniseedemissary.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]

	Global.register_rod(card_aniseedemissary)
		
	var card_eagersailor: CardData = CardData.new("card_eagersailor")
	card_eagersailor.card_name = "Eager Sailor"
	card_eagersailor.card_color_id = "color_{0}".format([color])
	card_eagersailor.card_texture_path = "external/sprites/cards/aniseed/02_eagersailor.png"
	card_eagersailor.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_eagersailor.card_description = "Explore [damage]."
	card_eagersailor.card_type = CardData.CARD_TYPES.ATTACK
	card_eagersailor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_eagersailor.card_requires_target = true
	card_eagersailor.card_energy_cost = 1
	card_eagersailor.card_values = {"card_influence":1,"damage": 3, "number_of_attacks": 1}
	card_eagersailor.card_upgrade_value_improvements = {"damage": 1}
	card_eagersailor.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ATTACK_GENERATOR: {"time_delay": 0.5},
		}]
	card_eagersailor.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_eagersailor)

		
	var card_fishwrangler: CardData = CardData.new("card_fishwrangler")
	card_fishwrangler.card_name = "Fish Wrangler"
	card_fishwrangler.card_color_id = "color_{0}".format([color])
	card_fishwrangler.card_texture_path = "external/sprites/cards/aniseed/03_fishwrangler.png"
	card_fishwrangler.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_fishwrangler.card_description = "Create Fish. If you have 3 or more Fishes in hand, gain 2 Food."
	card_fishwrangler.card_type = CardData.CARD_TYPES.SKILL
	card_fishwrangler.card_rarity = CardData.CARD_RARITIES.COMMON
	card_fishwrangler.card_requires_target = false
	card_fishwrangler.card_energy_cost = 1
	card_fishwrangler.card_values = {"card_influence":1,"created_card_object_id": "card_fish",  "number_of_cards": 1, "food_amount": 2}
	card_fishwrangler.card_upgrade_value_improvements = {"food_amount": 1}
	card_fishwrangler.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}
		},
		{
		Scripts.ACTION_VALIDATOR:{"validator_data":[{Scripts.VALIDATOR_CARD_ID_IN_HAND:{
			"card_id":"card_fish",
			"card_type_minimum":3,
			"card_tortype_maximum":99}}],
			"passed_action_data":[{Scripts.ACTION_ADD_FOOD:{}}]}
		}]
	card_fishwrangler.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_fishwrangler)
	
	var card_spicepicker: CardData = CardData.new("card_spicepicker")
	card_spicepicker.card_name = "Spice Picker"
	card_spicepicker.card_color_id = "color_{0}".format([color])
	card_spicepicker.card_texture_path = "external/sprites/cards/aniseed/04_spicepicker.png"
	card_spicepicker.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_spicepicker.card_description = "Create [number_of_cards] Spice. If you have 3 or more Spice cards in hand, create 2 Grains."
	card_spicepicker.card_type = CardData.CARD_TYPES.SKILL
	card_spicepicker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_spicepicker.card_requires_target = false
	card_spicepicker.card_energy_cost = 1
	card_spicepicker.card_values = {"card_influence":1,"created_card_object_id": "card_spice",  "number_of_cards": 1}
	card_spicepicker.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_spicepicker.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}
		},
		{
		Scripts.ACTION_VALIDATOR:{"validator_data":[{Scripts.VALIDATOR_CARD_ID_IN_HAND:{
			"card_id":"card_spice",
			"card_type_minimum":3,
			"card_tortype_maximum":99}}],
			"passed_action_data":[{Scripts.ACTION_CREATE_CARDS:{
				"created_card_object_id":"card_grain",
				"number_of_cards": 2,
				"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}}]}
		}]
	card_spicepicker.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_spicepicker)
	
	var card_reveredcraftsworker: CardData = CardData.new("card_reveredcraftsworker")
	card_reveredcraftsworker.card_name = "Revered Craftsworker"
	card_reveredcraftsworker.card_color_id = "color_{0}".format([color])
	card_reveredcraftsworker.card_texture_path = "external/sprites/cards/aniseed/05_reveredcraftsworker.png"
	card_reveredcraftsworker.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_reveredcraftsworker.card_description = "Consume 1 Ore to Craft [number_of_cards] Treasure. If you have 3 or more Spice cards in hand, create 2 Grains."
	card_reveredcraftsworker.card_type = CardData.CARD_TYPES.SKILL
	card_reveredcraftsworker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_reveredcraftsworker.card_requires_target = false
	card_reveredcraftsworker.card_energy_cost = 1
	card_reveredcraftsworker.card_values = {"card_influence":1,"created_card_object_id": "card_treasure",  "number_of_cards": 1}
	card_reveredcraftsworker.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_reveredcraftsworker.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_VALIDATOR:{"validator_data": [{Scripts.VALIDATOR_ORE:{ "ore_amount": 1}}],
				"passed_action_data": [{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}},
		{Scripts.ACTION_ADD_ORE:{"ore_amount":-1}}]}
		},{
		Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount": 2,
				"max_card_amount": 2,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_rock"}}],
				"action_data": [{
				Scripts.ACTION_VALIDATOR:
				{
				"validator_data":
					[{Scripts.VALIDATOR_PILE_SIZE:
						{"card_pick_type":HandManager.EXHAUST_PILE,
						"operator":">=",
						"comparison_value": 5}}],
				"passed_action_data":
					[{
						Scripts.ACTION_IMPROVE_CARD_VALUES: {
						"card_value_improvements":{"ore_amount":1},
						"time_delay": 0.1,
						"pick_played_card": true,
						"modify_parent_card": false,
						}},
						{
						Scripts.ACTION_VALIDATOR:
						{
						"validator_data":
							[{Scripts.VALIDATOR_PILE_SIZE:
							{"card_pick_type":HandManager.EXHAUST_PILE,
							"operator":">=",
							"comparison_value": 15}}],
						"passed_action_data":
							[{
							Scripts.ACTION_IMPROVE_CARD_VALUES: {
							"card_value_improvements":{"ore_amount":2},
							"time_delay": 0.1,
							"pick_played_card": true,
							"modify_parent_card": false,
						}}],	
						}					
					}]
				}
		}]}}]
	card_reveredcraftsworker.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_reveredcraftsworker)
	
	var card_cartographersassistant: CardData = CardData.new("card_cartographersassistant")
	card_cartographersassistant.card_name = "Cartographer's Assistant"
	card_cartographersassistant.card_color_id = "color_{0}".format([color])
	card_cartographersassistant.card_texture_path = "external/sprites/cards/aniseed/06_cartographersassistant.png"
	card_cartographersassistant.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_cartographersassistant.card_description = "Explore [damage]. Consume 3 Ore to gain 1 Insight."
	card_cartographersassistant.card_type = CardData.CARD_TYPES.ATTACK
	card_cartographersassistant.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cartographersassistant.card_requires_target = true
	card_cartographersassistant.card_energy_cost = 1
	card_cartographersassistant.card_values = {"card_influence":1,"damage": 2,"number_of_attacks":1, "insight_amount": 1}
	card_cartographersassistant.card_upgrade_value_improvements = {"damage": 2}
	card_cartographersassistant.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ATTACK_GENERATOR: {
			"time_delay":0.5
		}
		},
		{
		Scripts.ACTION_VALIDATOR:{"validator_data":[{Scripts.VALIDATOR_ORE:{
			"ore_amount": 3}}],
			"passed_action_data":[{Scripts.ACTION_ADD_ORE:{
				"ore_amount":-3}},{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":1}}]}
		}]
	card_cartographersassistant.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_cartographersassistant)
	
	var card_flintlockmage: CardData = CardData.new("card_flintlockmage")
	card_flintlockmage.card_name = "Flintlock Mage"
	card_flintlockmage.card_color_id = "color_{0}".format([color])
	card_flintlockmage.card_texture_path = "external/sprites/cards/aniseed/07_flintlockmage.png"
	card_flintlockmage.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_flintlockmage.card_description = "Craft [number_of_cards] Sword. Draw [draw_count], then discard a card."
	card_flintlockmage.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockmage.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_flintlockmage.card_requires_target = false
	card_flintlockmage.card_energy_cost = 1
	card_flintlockmage.card_values = {"card_influence":1,"created_card_object_id": "card_sword",  "number_of_cards": 1, "draw_count":1}
	card_flintlockmage.card_upgrade_value_improvements = {"draw_count": 1}
	card_flintlockmage.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		
		{
		Scripts.ACTION_PICK_CARDS:{
			"min_card_amount": 1,
			"max_card_amount": 1,
			"min_cards_are_required_for_action": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose up to {0} card(s) to discard. {1} cards selected",
			"random_selection": false,
			"action_data": [{Scripts.ACTION_DISCARD_CARDS: {
			}
			}]
			}}
		]
	card_flintlockmage.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_flintlockmage)
	
	var card_aniseedscribe: CardData = CardData.new("card_aniseedscribe")
	card_aniseedscribe.card_name = "aniseed Scribe"
	card_aniseedscribe.card_color_id = "color_{0}".format([color])
	card_aniseedscribe.card_texture_path = "external/sprites/cards/aniseed/08_aniseedscribe.png"
	card_aniseedscribe.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedscribe.card_description = "Draw [draw_count]. If discard pile is empty, gain 1 Insight."
	card_aniseedscribe.card_type = CardData.CARD_TYPES.SKILL
	card_aniseedscribe.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_aniseedscribe.card_requires_target = false
	card_aniseedscribe.card_energy_cost = 1
	card_aniseedscribe.card_values = {"card_influence":1,"created_card_object_id": "card_sword",  "number_of_cards": 1, "draw_count":1}
	card_aniseedscribe.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_aniseedscribe.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		{
		Scripts.ACTION_VALIDATOR:{
			"validator_data":[{Scripts.VALIDATOR_PILE_SIZE:{"card_pick_type": HandManager.DISCARD_PILE,
			 "operator":"==","comparison_value":0}}],
			"action_data": [{Scripts.ACTION_ADD_INSIGHT: {"insight_amount": 1
			}}]
			}
		}]
	card_aniseedscribe.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_aniseedscribe)
	
	var card_peddlerveteran: CardData = CardData.new("card_peddlerveteran")
	card_peddlerveteran.card_name = "Peddler Veteran"
	card_peddlerveteran.card_color_id = "color_{0}".format([color])
	card_peddlerveteran.card_texture_path = "external/sprites/cards/aniseed/09_peddlerveteran.png"
	card_peddlerveteran.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_peddlerveteran.card_description = "Gain [money_amount] Money. Refresh Shop."
	card_peddlerveteran.card_type = CardData.CARD_TYPES.SKILL
	card_peddlerveteran.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_peddlerveteran.card_requires_target = false
	card_peddlerveteran.card_energy_cost = 1
	card_peddlerveteran.card_values = {"card_influence":1,"money_amount": 2}
	card_peddlerveteran.card_upgrade_value_improvements = {"money_amount": 2}
	card_peddlerveteran.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		},
		},
		{
		Scripts.ACTION_ADD_MONEY: {}
		}]
	card_peddlerveteran.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_peddlerveteran)
	
	var card_intrepidsailor: CardData = CardData.new("card_intrepidsailor")
	card_intrepidsailor.card_name = "Intrepid Sailor"
	card_intrepidsailor.card_color_id = "color_{0}".format([color])
	card_intrepidsailor.card_texture_path = "external/sprites/cards/aniseed/10_intrepidsailor.png"
	card_intrepidsailor.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_intrepidsailor.card_description = "Explore [damage]. Consume 2 Food to Wield [min_card_amount]."
	card_intrepidsailor.card_type = CardData.CARD_TYPES.ATTACK
	card_intrepidsailor.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_intrepidsailor.card_requires_target = true
	card_intrepidsailor.card_energy_cost = 1
	card_intrepidsailor.card_values = {"card_influence":1,"damage": 2,"number_of_attacks":1, "min_card_amount": 2,
				"max_card_amount": 2}
	card_intrepidsailor.card_upgrade_value_improvements = {"damage":1,"min_card_amount": 2,"max_card_amount": 2}
	card_intrepidsailor.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR: {
			"time_delay":0.5
		}
		},
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_VALIDATOR: {
			"validator_data":[{Scripts.VALIDATOR_FOOD: {
				"food_amount":2
				}}],
			"action_data": [{
				Scripts.ACTION_ADD_FOOD: {
				"food_amount":-2
				}
				},{
				Scripts.ACTION_PICK_CARDS:
				{
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_SUBTYPE: {"card_subtypes": [CardData.CARD_SUBTYPES.CRAFT]}}],
				"action_data": [{Scripts.ACTION_PLAY_CARDS:{}}]
				}
				}]
		}
		}]
	card_intrepidsailor.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_intrepidsailor)
		
	var card_keeneyedbuccaneer: CardData = CardData.new("card_keeneyedbuccaneer")
	card_keeneyedbuccaneer.card_name = "Keen-Eyed Buccaneer"
	card_keeneyedbuccaneer.card_color_id = "color_{0}".format([color])
	card_keeneyedbuccaneer.card_texture_path = "external/sprites/cards/aniseed/11_keeneyedbuccaneer.png"
	card_keeneyedbuccaneer.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_keeneyedbuccaneer.card_description = "Shuffle your discard pile into your draw pile. Gain 1 Explore for each Sword in your draw pile."
	card_keeneyedbuccaneer.card_type = CardData.CARD_TYPES.ATTACK
	card_keeneyedbuccaneer.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_keeneyedbuccaneer.card_requires_target = true
	card_keeneyedbuccaneer.card_energy_cost = 1
	card_keeneyedbuccaneer.card_values = {"card_influence":1,"damage": 1,"number_of_attacks":1}
	card_keeneyedbuccaneer.card_upgrade_value_improvements = {"damage":1}
	card_keeneyedbuccaneer.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_RESHUFFLE: {}
		},
		{
		Scripts.ACTION_PICK_CARDS: {
			"min_card_amount": 99,
			"max_card_amount": 99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DRAW_PILE,
			"card_pick_text": "Choose up to {0} card(s) to discard. {1} cards selected",
			"validator_data":[{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_sword"}}],
			"action_data": [
				{Scripts.ACTION_VARIABLE_CARDSET_MODIFIER: {
				"multiplied_values": ["damage"],
				"action_data": [{Scripts.ACTION_ATTACK_GENERATOR: {
				"time_delay": 0.5
				}}]
				}}]
		}
		}]
	card_keeneyedbuccaneer.card_end_of_turn_actions = [
	{
		Scripts.ACTION_VALIDATOR: {
		"validator_data":
		[
			{
			Scripts.VALIDATOR_CARD_PROPERTIES: 
				{
				"card_property_name": "card_influence",
				"operator": "<=",
				"comparison_value": 0,
				"invert_validation": false,
				}
			}
		],
		"passed_action_data": 
		[
			{
			Scripts.ACTION_TRANSFORM_CARDS: {
				"transform_into_card_object_id": "card_rebel",
				"pick_played_card": true
				},
			},
		]
		}
	},
	{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE:
			{
				"pick_played_card": true,
				"card_influence": -1
			}
	}
	]
	Global.register_rod(card_keeneyedbuccaneer)
	
	
	var card_aniseedtaxcollector: CardData = CardData.new("card_aniseedtaxcollector")
	card_aniseedtaxcollector.card_name = "aniseed Tax Collector"
	card_aniseedtaxcollector.card_color_id = "color_{0}".format([color])
	card_aniseedtaxcollector.card_texture_path = "external/sprites/cards/aniseed/12_aniseedtaxcollector.png"
	card_aniseedtaxcollector.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedtaxcollector.card_description = "Inspect [min_number_amount]. Gain 1 Glass for each card Inspected."
	card_aniseedtaxcollector.card_type = CardData.CARD_TYPES.SKILL
	card_aniseedtaxcollector.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_aniseedtaxcollector.card_requires_target = false
	card_aniseedtaxcollector.card_energy_cost = 1
	card_aniseedtaxcollector.card_values = {"card_influence":1,"min_card_amount":2,"max_card_amount":2}
	card_aniseedtaxcollector.card_upgrade_value_improvements = {"min_card_amount":1,"max_card_amount":1}
	card_aniseedtaxcollector.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_PICK_CARDS:
			{
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_rock"}}],
				"action_data": [{
				Scripts.ACTION_VALIDATOR:
				{
				"validator_data":
					[{Scripts.VALIDATOR_PILE_SIZE:
						{"card_pick_type":HandManager.EXHAUST_PILE,
						"operator":">=",
						"comparison_value": 5}}],
				"passed_action_data":
					[{
						Scripts.ACTION_ADD_MONEY:{"money_amount":1}},
						{
						Scripts.ACTION_IMPROVE_CARD_VALUES: {
						"card_value_improvements":{"ore_amount":1},
						"time_delay": 0.1,
						"pick_played_card": true,
						"modify_parent_card": false,
						}},
						{
						Scripts.ACTION_VALIDATOR:
						{
						"validator_data":
							[{Scripts.VALIDATOR_PILE_SIZE:
							{"card_pick_type":HandManager.EXHAUST_PILE,
							"operator":">=",
							"comparison_value": 15}}],
						"passed_action_data":
							[{
							Scripts.ACTION_IMPROVE_CARD_VALUES: {
							"card_value_improvements":{"ore_amount":2},
							"time_delay": 0.1,
							"pick_played_card": true,
							"modify_parent_card": false,
						}}],	
						}					
					}]
				}
		}]}
		}]
	card_aniseedtaxcollector.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_aniseedtaxcollector)

	var card_peddlerinformant: CardData = CardData.new("card_peddlerinformant")
	card_peddlerinformant.card_name = "Peddler Informant"
	card_peddlerinformant.card_color_id = "color_{0}".format([color])
	card_peddlerinformant.card_texture_path = "external/sprites/cards/aniseed/card_peddlerinformant.png"
	card_peddlerinformant.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_peddlerinformant.card_description = "Upgrade 2 cards."
	card_peddlerinformant.card_type = CardData.CARD_TYPES.SKILL
	card_peddlerinformant.card_rarity = CardData.CARD_RARITIES.RARE
	card_peddlerinformant.card_requires_target = false
	card_peddlerinformant.card_energy_cost = 1
	card_peddlerinformant.card_values = {"card_influence":1,"damage": 1,"number_of_attacks":1}
	card_peddlerinformant.card_upgrade_value_improvements = {"damage":1}
	card_peddlerinformant.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_RESHUFFLE: {}
		},
		{
		Scripts.ACTION_VALIDATOR: 
			{
				"validator_data": [{Scripts.VALIDATOR_INSIGHT:{ "insight_amount": 2}}],
				"passed_action_data": [{
					Scripts.ACTION_PICK_UPGRADE_CARDS: {
					"min_card_amount": 2,
					"max_card_amount": 2,
					"min_cards_are_required_for_action": false,
					"random_selection": false,
					"card_pick_type": HandManager.HAND_PILE,
					"card_pick_text": "Choose up to {0} card(s) to upgrade. {1} cards selected",
					"validator_data": [
					{Scripts.VALIDATOR_CARD_UPGRADEABLE: {}},
					],
					"action_data": [
						{Scripts.ACTION_ADD_INSIGHT: {"insight_amount":-1}}
					]
					}
				}]
			}
		}]
	card_peddlerinformant.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_peddlerinformant)
	
	var card_taxfarmer: CardData = CardData.new("card_taxfarmer")
	card_taxfarmer.card_name = "Tax Farmer"
	card_taxfarmer.card_color_id = "color_{0}".format([color])
	card_taxfarmer.card_texture_path = "external/sprites/cards/aniseed/14_taxfarmer.png"
	card_taxfarmer.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_taxfarmer.card_description = "Gain 1 money for every 5 cards in draw pile. ([money_amount] Money)."
	card_taxfarmer.card_type = CardData.CARD_TYPES.SKILL
	card_taxfarmer.card_rarity = CardData.CARD_RARITIES.RARE
	card_taxfarmer.card_requires_target = false
	card_taxfarmer.card_energy_cost = 1
	card_taxfarmer.card_values = {"money_amount":int(HandManager.player_draw.size()/5)}
	#card_taxfarmer.card_upgrade_value_improvements = {"damage":1}
	card_taxfarmer.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_ADD_MONEY:{}
		}]
	card_taxfarmer.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_taxfarmer)
	
	var card_swashbucklingchamp: CardData = CardData.new("card_swashbucklingchamp")
	card_swashbucklingchamp.card_name = "Swashbuckling Champ"
	card_swashbucklingchamp.card_color_id = "color_{0}".format([color])
	card_swashbucklingchamp.card_texture_path = "external/sprites/cards/aniseed/15_swashbucklingchamp.png"
	card_swashbucklingchamp.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_swashbucklingchamp.card_description = "Wield [min_card_amount]. Improve wielded cards."
	card_swashbucklingchamp.card_type = CardData.CARD_TYPES.SKILL
	card_swashbucklingchamp.card_rarity = CardData.CARD_RARITIES.RARE
	card_swashbucklingchamp.card_requires_target = false
	card_swashbucklingchamp.card_energy_cost = 1
	card_swashbucklingchamp.card_values = {"card_influence":1,"min_card_amount":1,"max_card_amount":1}
	card_swashbucklingchamp.card_upgrade_value_improvements = {"min_card_amount":1,"max_card_amount":1}
	card_swashbucklingchamp.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to wield. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_sword"}}],
			"action_data": [{
			Scripts.ACTION_PLAY_CARDS: {}},
			{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"card_value_improvements":{"explore_amount":1,"ore_amount":1},
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}}]
		}}]
	card_swashbucklingchamp.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]

	Global.register_rod(card_swashbucklingchamp)
#endregion
func add_cards_green() -> void:
	var color: String = "green"

	var card_cofferskeeper: CardData = CardData.new("card_cofferskeeper")
	card_cofferskeeper.card_name = "Coffers Keeper"
	card_cofferskeeper.card_color_id = "color_{0}".format([color])
	card_cofferskeeper.card_texture_path = "external/sprites/cards/jade/01_cofferskeeper.png"
	card_cofferskeeper.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_cofferskeeper.card_description = "Gain [ore_amount] Ore, [money_amount] Money, [food_amount] Food [min_card_amount]."
	card_cofferskeeper.card_type = CardData.CARD_TYPES.SKILL
	card_cofferskeeper.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cofferskeeper.card_requires_target = false
	card_cofferskeeper.card_energy_cost = 1
	card_cofferskeeper.card_values = {"card_influence": 1,"ore_amount":1,"money_amount":1,"food_amount":1}
	card_cofferskeeper.card_upgrade_value_improvements = {"food_amount":1}
	card_cofferskeeper.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_ADD_ORE: {}
		},
		{
		Scripts.ACTION_ADD_MONEY: {}
		},
		{
		Scripts.ACTION_ADD_FOOD: {}
		}]
	card_cofferskeeper.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_cofferskeeper)
	
	var card_youngmentor: CardData = CardData.new("card_youngmentor")
	card_youngmentor.card_name = "Young Mentor"
	card_youngmentor.card_color_id = "color_{0}".format([color])
	card_youngmentor.card_texture_path = "external/sprites/cards/jade/02_youngmentor.png"
	card_youngmentor.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_youngmentor.card_description = "Create [number_of_cards] Fish, Discard up to 2 cards."
	card_youngmentor.card_type = CardData.CARD_TYPES.SKILL
	card_youngmentor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_youngmentor.card_requires_target = false
	card_youngmentor.card_energy_cost = 1
	card_youngmentor.card_values = {"card_influence": 1,"created_card_object_id":"card_fish","number_of_cards":2}
	card_youngmentor.card_upgrade_value_improvements = {"number_of_cards":1}
	card_youngmentor.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},		{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 0,
		"max_card_amount": 2,
		"min_cards_are_required_for_action": false,
		"card_pick_type": HandManager.HAND_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"action_data": [
			{Scripts.ACTION_DISCARD_CARDS: {
			}},
			]
		},

		},
		{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]}
		}]
	card_youngmentor.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_youngmentor)
	
	var card_luckfinder: CardData = CardData.new("card_luckfinder")
	card_luckfinder.card_name = "Luck Finder"
	card_luckfinder.card_color_id = "color_{0}".format([color])
	card_luckfinder.card_texture_path = "external/sprites/cards/jade/luckfinder.png"
	card_luckfinder.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_luckfinder.card_description = "Consume 2 Ore to Fertilise all Grains in deck. If not played, add [number_of_cards] Grain."
	card_luckfinder.card_type = CardData.CARD_TYPES.SKILL
	card_luckfinder.card_rarity = CardData.CARD_RARITIES.COMMON
	card_luckfinder.card_requires_target = false
	card_luckfinder.card_energy_cost = 1
	card_luckfinder.card_values = {"card_influence": 1,"created_card_object_id":"card_grain","number_of_cards":1}
	card_luckfinder.card_upgrade_value_improvements = {"number_of_cards":1}
	card_luckfinder.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_VALIDATOR: {
			"validator_data": [{Scripts.VALIDATOR_ORE: {"ore_amount":2}}],
			"passed_action_data": [{Scripts.ACTION_ADD_ORE:{"ore_amount":-2}},
			{		
			Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DRAW_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"created_card_object_id": "card_grain"}}],
				"action_data": [{Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"card_value_improvements":{"food_amount":1},
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
			}]
		}}]
		}
		}
	]
	card_luckfinder.card_end_of_turn_actions = [
		{
		Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}
		},
		{
		Scripts.ACTION_VALIDATOR: {
		"validator_data":
		[
			{
			Scripts.VALIDATOR_CARD_PROPERTIES: 
				{
				"card_property_name": "card_influence",
				"operator": "<=",
				"comparison_value": 0,
				"invert_validation": false,
				}
			}
		],
		"passed_action_data": 
		[
			{
			Scripts.ACTION_TRANSFORM_CARDS: {
				"transform_into_card_object_id": "card_rebel",
				"pick_played_card": true
				},
			},
		]
		}
	},
	{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE:
			{
				"pick_played_card": true,
				"card_influence": -1
			}
	}
	]
	Global.register_rod(card_luckfinder)
	
	var card_greeninformant: CardData = CardData.new("card_greeninformant")
	card_greeninformant.card_name = "Green Informant"
	card_greeninformant.card_color_id = "color_{0}".format([color])
	card_greeninformant.card_texture_path = "external/sprites/cards/jade/04_greeninformant.png"
	card_greeninformant.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_greeninformant.card_description = "Does nothing but gain [card_influence] influence when played. When discarded, lose 5 Influence to gain [insight_amount] Insight."
	card_greeninformant.card_type = CardData.CARD_TYPES.SKILL
	card_greeninformant.card_rarity = CardData.CARD_RARITIES.COMMON
	card_greeninformant.card_requires_target = false
	card_greeninformant.card_energy_cost = 1
	card_greeninformant.card_values = {"card_influence": 2,"insight_amount":1}
	card_greeninformant.card_upgrade_value_improvements = {"card_influence":1}
	card_greeninformant.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		}]
	card_greeninformant.card_discard_actions = [
		{
			Scripts.ACTION_VALIDATOR:{
				"validator_data":[{Scripts.VALIDATOR_CARD_PROPERTIES:{"card_property_name":"card_influence","comparison_value":5}}],
				"action_data":[{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{"card_influence":-5,"pick_played_card":true,"modify_parent_card":false}},
				{Scripts.ACTION_ADD_INSIGHT:{}}]
			}
		}]
	card_greeninformant.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_greeninformant)
	
	var card_goldenconscript: CardData = CardData.new("card_goldenconscript")
	card_goldenconscript.card_name = "Golden Conscript"
	card_goldenconscript.card_color_id = "color_{0}".format([color])
	card_goldenconscript.card_texture_path = "external/sprites/cards/jade/05_goldenconscript.png"
	card_goldenconscript.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_goldenconscript.card_description = "Draw [draw_count], Explore [damage]."
	card_goldenconscript.card_type = CardData.CARD_TYPES.ATTACK
	card_goldenconscript.card_rarity = CardData.CARD_RARITIES.COMMON
	card_goldenconscript.card_requires_target = true
	card_goldenconscript.card_energy_cost = 1
	card_goldenconscript.card_values = {"card_influence":1,"draw_count": 1,"damage":2,"number_of_attacks":1}
	card_goldenconscript.card_upgrade_value_improvements = {"draw_count":1,"damage":1}
	card_goldenconscript.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_DRAW_GENERATOR:{}
		},
		{Scripts.ACTION_ATTACK_GENERATOR:{"time_delay": 0.5}}]
	card_goldenconscript.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_goldenconscript)
	
	var card_militantoutsourcer: CardData = CardData.new("card_militantoutsourcer")
	card_militantoutsourcer.card_name = "Militant Outsourcer"
	card_militantoutsourcer.card_color_id = "color_{0}".format([color])
	card_militantoutsourcer.card_texture_path = "external/sprites/cards/jade/06_militantoutsourcer.png"
	card_militantoutsourcer.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_militantoutsourcer.card_description = "Explore [damage]. Return 1 card from your discard pile to your hand."
	card_militantoutsourcer.card_type = CardData.CARD_TYPES.ATTACK
	card_militantoutsourcer.card_rarity = CardData.CARD_RARITIES.COMMON
	card_militantoutsourcer.card_requires_target = true
	card_militantoutsourcer.card_energy_cost = 1
	card_militantoutsourcer.card_values = {"card_influence":1,"damage":2,"number_of_attacks":1}
	card_militantoutsourcer.card_upgrade_value_improvements = {"damage":2}
	card_militantoutsourcer.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{Scripts.ACTION_ATTACK_GENERATOR:{"time_delay": 0.5}},
		{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 1,
		"max_card_amount": 1,
		"min_cards_are_required_for_action": false,
		"random_selection": false,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose up to {0} card(s) to return. {1} cards selected",
		"action_data": [
			{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
		}
		}]
	card_militantoutsourcer.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_militantoutsourcer)
	
	var card_facetrecaster: CardData = CardData.new("card_facetrecaster")
	card_facetrecaster.card_name = "Facet Recaster"
	card_facetrecaster.card_color_id = "color_{0}".format([color])
	card_facetrecaster.card_texture_path = "external/sprites/cards/jade/07_facetrecaster.png"
	card_facetrecaster.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_facetrecaster.card_description = "Add [number_of_cards] Grain to your draw_pile."
	card_facetrecaster.card_type = CardData.CARD_TYPES.SKILL
	card_facetrecaster.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_facetrecaster.card_requires_target = false
	card_facetrecaster.card_energy_cost = 1
	card_facetrecaster.card_values = {"card_influence": 1,"created_card_object_id":"card_grain","number_of_cards":3}
	card_facetrecaster.card_upgrade_value_improvements = {"number_of_cards":1}
	card_facetrecaster.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS:{
				"card_pick_type": ActionBasePickCards.PICK_PARENT_CARD,
				"min_card_amount": 1,
				"max_card_amount": 1,
				"min_cards_are_required_for_action": true,
				"random_selection": true,
				"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence":1
				}
				}]
			}
		},
		{
		Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_ADD_CARDS_TO_DRAW:{}}]
		}}]
	card_facetrecaster.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_facetrecaster)
	
	var card_shockrider: CardData = CardData.new("card_shockrider")
	card_shockrider.card_name = "Shock Rider"
	card_shockrider.card_color_id = "color_{0}".format([color])
	card_shockrider.card_texture_path = "external/sprites/cards/jade/08_shockrider.png"
	card_shockrider.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_shockrider.card_description = "Explore [damage]. Consume 2 Food to Wield 2."
	card_shockrider.card_type = CardData.CARD_TYPES.ATTACK
	card_shockrider.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_shockrider.card_requires_target = true
	card_shockrider.card_energy_cost = 1
	card_shockrider.card_values = {"card_influence":1,"damage":2,"number_of_attacks":1}
	card_shockrider.card_upgrade_value_improvements = {"damage":1}
	card_shockrider.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{Scripts.ACTION_ATTACK_GENERATOR:{"time_delay": 0.5}},
		{
		Scripts.ACTION_VALIDATOR:
			{
				"validator_data":[{Scripts.VALIDATOR_FOOD:{"food_amount":2}}],
				"passed_action_data":[{
				Scripts.ACTION_PICK_CARDS: {
					"min_card_amount": 3,
					"max_card_amount": 3,
					"min_cards_are_required_for_action": false,
					"random_selection": true,
					"card_pick_type": HandManager.DISCARD_PILE,
					"card_pick_text": "Choose up to {0} card(s) to return. {1} cards selected",
					"validator_data":[{Scripts.VALIDATOR_CARD_SUBTYPE:[{"card_subtypes":CardData.CARD_SUBTYPES.CRAFT}]}],
					"action_data": [
					{Scripts.ACTION_PLAY_CARDS:{}}]
					}
				}]
			}
		}]
	card_shockrider.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_shockrider)
	
	var card_everymanleader: CardData = CardData.new("card_everymanleader")
	card_everymanleader.card_name = "Everyman Leader"
	card_everymanleader.card_color_id = "color_{0}".format([color])
	card_everymanleader.card_texture_path = "external/sprites/cards/jade/09_everymanleader.png"
	card_everymanleader.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_everymanleader.card_description = "Appease twice [min_card_amount] cards in discard pile. Return them to your hand."
	card_everymanleader.card_type = CardData.CARD_TYPES.SKILL
	card_everymanleader.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_everymanleader.card_requires_target = false
	card_everymanleader.card_energy_cost = 1
	card_everymanleader.card_values = {"card_influence":1, "max_card_amount":2}
	card_everymanleader.card_upgrade_value_improvements = {"max_card_amount":1}
	card_everymanleader.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_cards_are_required_for_action": false,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to appease and return. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":2,
			"time_delay": 0.1,
			"pick_played_card": true,
			"modify_parent_card": false,
		}}]
		}
		}]
	card_everymanleader.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_everymanleader)
	
	var card_inspiredgossipmonger: CardData = CardData.new("card_inspiredgossipmonger")
	card_inspiredgossipmonger.card_name = "Inspired Gossipmonger"
	card_inspiredgossipmonger.card_color_id = "color_{0}".format([color])
	card_inspiredgossipmonger.card_texture_path = "external/sprites/cards/jade/10_inspiredgossipmonger.png"
	card_inspiredgossipmonger.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_inspiredgossipmonger.card_description = "Rattle all cards in draw pile to gain [insight_amount] Insight. Do this only if draw pile is at least [comparison_value]."
	card_inspiredgossipmonger.card_type = CardData.CARD_TYPES.SKILL
	card_inspiredgossipmonger.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_inspiredgossipmonger.card_requires_target = false
	card_inspiredgossipmonger.card_energy_cost = 1
	card_inspiredgossipmonger.card_values = {"insight_amount":1,"card_influence":1, "comparison_value":13}
	card_inspiredgossipmonger.card_upgrade_value_improvements = {"comparison_value":-3}
	card_inspiredgossipmonger.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}},
				{
		Scripts.ACTION_VALIDATOR: 
			{
			"validator_data": [
			{Scripts.VALIDATOR_PILE_SIZE: {"card_pick_type": HandManager.DRAW_PILE, "operator":">="}}
			],
			"action_data": [
			{Scripts.ACTION_ADD_INSIGHT: {
			}},
					{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DRAW_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":-1,
			"time_delay": 0.1,
			"pick_played_card": true,
			"modify_parent_card": false,
		}}]
		}
		}
			]
			}
		}]
	card_inspiredgossipmonger.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_inspiredgossipmonger)
	
	var card_wizenedforager: CardData = CardData.new("card_wizenedforager")
	card_wizenedforager.card_name = "Wizened Forager"
	card_wizenedforager.card_color_id = "color_{0}".format([color])
	card_wizenedforager.card_texture_path = "external/sprites/cards/jade/11_wizenedforager.png"
	card_wizenedforager.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_wizenedforager.card_description = "Create 3 Grain in discard pile. When discarded, create [number_of_cards] Fish in discard pile instead."
	card_wizenedforager.card_type = CardData.CARD_TYPES.SKILL
	card_wizenedforager.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_wizenedforager.card_requires_target = false
	card_wizenedforager.card_energy_cost = 1
	card_wizenedforager.card_values = {"card_influence":1, "created_card_object_id":"card_fish","number_of_cards":1}
	card_wizenedforager.card_upgrade_value_improvements = {"number_of_cards":1}
	card_wizenedforager.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"created_card_object_id":"card_grain",
				"number_of_cards":3,
				"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
			}
		}]
	card_wizenedforager.card_discard_actions = [
		{
			Scripts.ACTION_CREATE_CARDS:
				{
					"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
				}
		}
	]
	card_wizenedforager.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_wizenedforager)
	
	var card_hoardingstowaway: CardData = CardData.new("card_hoardingstowaway")
	card_hoardingstowaway.card_name = "Hoarding Stowaway"
	card_hoardingstowaway.card_color_id = "color_{0}".format([color])
	card_hoardingstowaway.card_texture_path = "external/sprites/cards/jade/12_hoardingstowaway.png"
	card_hoardingstowaway.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_hoardingstowaway.card_description = "Consume [ore_amount] Ore to gain 2 Insight."
	card_hoardingstowaway.card_type = CardData.CARD_TYPES.SKILL
	card_hoardingstowaway.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_hoardingstowaway.card_requires_target = false
	card_hoardingstowaway.card_energy_cost = 1
	card_hoardingstowaway.card_values = {"card_influence":1, "ore_amount":-8, "insight_amount":2}
	card_hoardingstowaway.card_upgrade_value_improvements = {"ore_amount":2}
	card_hoardingstowaway.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
			Scripts.ACTION_VALIDATOR:
			{
				"validator_data": [{
				Scripts.VALIDATOR_ORE:{"ore_amount": -1 * card_hoardingstowaway.card_values["ore_amount"]}
				}],
				"passed_action_data": [{
				Scripts.ACTION_ADD_ORE:{}
				},
				{Scripts.ACTION_ADD_INSIGHT:{}}]
		}}]
	card_hoardingstowaway.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_hoardingstowaway)
	
	var card_supremerecaster: CardData = CardData.new("card_supremerecaster")
	card_supremerecaster.card_name = "Supreme Recaster"
	card_supremerecaster.card_color_id = "color_{0}".format([color])
	card_supremerecaster.card_texture_path = "external/sprites/cards/jade/13_supremerecaster.png"
	card_supremerecaster.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_supremerecaster.card_description = "Consume 1 Grain and 1 Fish to Gain 2 Delicacies."
	card_supremerecaster.card_type = CardData.CARD_TYPES.SKILL
	card_supremerecaster.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_supremerecaster.card_requires_target = false
	card_supremerecaster.card_energy_cost = 1
	card_supremerecaster.card_values = {"card_influence":1, "ore_amount":-8, "insight_amount":2}
	card_supremerecaster.card_upgrade_value_improvements = {"ore_amount":2}
	card_supremerecaster.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
			Scripts.ACTION_VALIDATOR:
			{
				"validator_data": [{
				Scripts.VALIDATOR_ORE:{"ore_amount": -1 * card_hoardingstowaway.card_values["ore_amount"]}
				}],
				"passed_action_data": [{
				Scripts.ACTION_ADD_ORE:{}
				},
				{Scripts.ACTION_ADD_INSIGHT:{}}]
		}}]
	card_supremerecaster.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_supremerecaster)
	
		
	var card_villagehero: CardData = CardData.new("card_villagehero")
	card_villagehero.card_name = "Supreme Recaster"
	card_villagehero.card_color_id = "color_{0}".format([color])
	card_villagehero.card_texture_path = "external/sprites/cards/jade/villagehero.png"
	card_villagehero.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_villagehero.card_description = "Gain 1 Explore for each Faction card."
	card_villagehero.card_type = CardData.CARD_TYPES.ATTACK
	card_villagehero.card_rarity = CardData.CARD_RARITIES.RARE
	card_villagehero.card_requires_target = true
	card_villagehero.card_energy_cost = 1
	card_villagehero.card_values = {"card_influence":1, "damage":1, "number_of_attacks":1}
	card_villagehero.card_upgrade_value_improvements = {"damage":1}
	card_villagehero.card_play_actions = [
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_VARIABLE_CARDSET_MODIFIER: {
			"multiplied_values": ["damage"],
			"action_data": [{Scripts.ACTION_ATTACK_GENERATOR: {
				"time_delay": 0.5
							}}]}
			}]
		}
		}]
	card_villagehero.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_villagehero)
	
	var card_solverofriddles: CardData = CardData.new("card_solverofriddles")
	card_solverofriddles.card_name = "Supreme Recaster"
	card_solverofriddles.card_color_id = "color_{0}".format([color])
	card_solverofriddles.card_texture_path = "external/sprites/cards/jade/15_solverofriddles.png"
	card_solverofriddles.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_solverofriddles.card_description = "Does nothing and is shuffled into deck. When it is drawn, loses 1 influence to appease others. When it is played with 5 influence, loses 3 influence to gain 2 Food, 2 Ore, 2 Money, 2 Insight"
	card_solverofriddles.card_type = CardData.CARD_TYPES.SKILL
	card_solverofriddles.card_rarity = CardData.CARD_RARITIES.RARE
	card_solverofriddles.card_requires_target = false
	card_solverofriddles.card_energy_cost = 1
	card_solverofriddles.card_values = {"card_influence":1, "damage":1, "number_of_attacks":1}
	card_solverofriddles.card_upgrade_value_improvements = {"damage":1}
	card_solverofriddles.card_draw_actions = [{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence": -1,
			"pick_played_card": true,
			"modify_parent_card": false,
		}},
					{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to appease. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":1,
			"time_delay": 0.1,
			"pick_played_card": true,
			"modify_parent_card": false,
		}}]
		}
		}
	]
	card_solverofriddles.card_play_actions = [
		{
		Scripts.ACTION_VALIDATOR:
			{"validator_data":[{Scripts.VALIDATOR_CARD_PROPERTIES:{"card_property_name":"card_influence","comparison_value":5}}],
			"action_data":[{Scripts.ACTION_ADD_FOOD:{"food_amount":2}},{Scripts.ACTION_ADD_ORE:{"ore_amount":2}},{Scripts.ACTION_ADD_MONEY:{"money_amount":2}},{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":2}},{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{"card_influence":-5}}]
			}
		},
		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
		}
		},
		{Scripts.ACTION_ADD_CARDS_TO_DRAW:
			{
				"pick_played_card": true
			}}]
	card_solverofriddles.card_end_of_turn_actions = [
		{
			Scripts.ACTION_VALIDATOR: {
			"validator_data":
			[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES: 
					{
					"card_property_name": "card_influence",
					"operator": "<=",
					"comparison_value": 0,
					"invert_validation": false,
					}
				}
			],
			"passed_action_data": 
			[
				{
				Scripts.ACTION_TRANSFORM_CARDS: {
					"transform_into_card_object_id": "card_rebel",
					"pick_played_card": true
					},
				},
			]
			}
		},
		{
			Scripts.ACTION_CHANGE_CARD_INFLUENCE:
				{
					"pick_played_card": true,
					"card_influence": -1
				}
		}
	]
	Global.register_rod(card_solverofriddles)
func add_cards_gold() -> void:
	var color: String = "gold"


#region Card Packs

func add_card_packs() -> void:
	# all cards in game, with no filtering
	var card_pack_all: CardPackData = CardPackData.new("card_pack_all")
	card_pack_all.exclude_non_standard_rarities = false
	card_pack_all.exclude_non_standard_types = false
	Global.register_rod(card_pack_all)
	
	# all draftable cards, ignoring non-standard types and rarities
	var card_pack_prismatic: CardPackData = CardPackData.new("card_pack_prismatic")
	Global.register_rod(card_pack_prismatic)

	var card_pack_grey: CardPackData = CardPackData.new("card_pack_grey")
	card_pack_grey.card_pack_color_id = "color_grey"
	card_pack_grey.exclude_non_standard_rarities = false
	card_pack_grey.exclude_non_standard_types = false
	Global.register_rod(card_pack_grey)
	
	var card_pack_black: CardPackData = CardPackData.new("card_pack_black")
	card_pack_black.card_pack_color_id = "color_black"
	card_pack_black.card_pack_displays_in_codex = true
	Global.register_rod(card_pack_black)
	
	var card_pack_gold: CardPackData = CardPackData.new("card_pack_gold")
	card_pack_gold.card_pack_color_id = "color_gold"
	card_pack_gold.card_pack_displays_in_codex = true
	Global.register_rod(card_pack_gold)
	
	var card_pack_green: CardPackData = CardPackData.new("card_pack_green")
	card_pack_green.card_pack_color_id = "color_green"
	card_pack_green.card_pack_displays_in_codex = true
	Global.register_rod(card_pack_green)
	
	var card_pack_purple: CardPackData = CardPackData.new("card_pack_purple")
	card_pack_purple.card_pack_color_id = "color_purple"
	card_pack_purple.card_pack_displays_in_codex = true
	Global.register_rod(card_pack_purple)
	
	var card_pack_white: CardPackData = CardPackData.new("card_pack_white")
	card_pack_white.card_pack_color_id = "color_white"
	card_pack_white.card_pack_displays_in_codex = true
	Global.register_rod(card_pack_white)
	


#endregion
#region Artifact Packs

func add_artifact_packs() -> void:
	# all artifacts in game, with no filtering
	var artifact_pack_all: ArtifactPackData = ArtifactPackData.new("artifact_pack_all")
	artifact_pack_all.exclude_non_standard_rarities = false
	Global.register_rod(artifact_pack_all)
	
	# common pool artifacts, ignoring non-standard types and rarities
	# all characters should have this and their color by default
	var artifact_pack_white: ArtifactPackData = ArtifactPackData.new("artifact_pack_white")
	artifact_pack_white.artifact_pack_color_id = "color_white"
	Global.register_rod(artifact_pack_white)
	
	var artifact_pack_black: ArtifactPackData = ArtifactPackData.new("artifact_pack_black")
	artifact_pack_black.artifact_pack_color_id = "color_black"
	Global.register_rod(artifact_pack_black)
	
	var artifact_pack_gold: ArtifactPackData = ArtifactPackData.new("artifact_pack_gold")
	artifact_pack_gold.artifact_pack_color_id = "color_gold"
	Global.register_rod(artifact_pack_gold)
	
	var artifact_pack_green: ArtifactPackData = ArtifactPackData.new("artifact_pack_green")
	artifact_pack_green.artifact_pack_color_id = "color_green"
	Global.register_rod(artifact_pack_green)
	
	var artifact_pack_purple: ArtifactPackData = ArtifactPackData.new("artifact_pack_purple")
	artifact_pack_purple.artifact_pack_color_id = "color_purple"
	Global.register_rod(artifact_pack_purple)

#endregion

#region Consumable Packs
func add_consumable_packs() -> void:
	# all consumables in game, with no filtering
	var consumable_pack_all: ConsumablePackData = ConsumablePackData.new("consumable_pack_all")
	Global.register_rod(consumable_pack_all)
	
	# common pool consumables, ignoring non-standard types and rarities
	# all characters should have this and their color by default
	var consumable_pack_white: ConsumablePackData = ConsumablePackData.new("consumable_pack_white")
	consumable_pack_white.consumable_pack_color_id = "color_white"
	Global.register_rod(consumable_pack_white)
	
	var consumable_pack_gold: ConsumablePackData = ConsumablePackData.new("consumable_pack_gold")
	consumable_pack_gold.consumable_pack_color_id = "color_gold"
	Global.register_rod(consumable_pack_gold)
	
	var consumable_pack_black: ConsumablePackData = ConsumablePackData.new("consumable_pack_black")
	consumable_pack_black.consumable_pack_color_id = "color_black"
	Global.register_rod(consumable_pack_black)
	
	var consumable_pack_green: ConsumablePackData = ConsumablePackData.new("consumable_pack_green")
	consumable_pack_green.consumable_pack_color_id = "color_green"
	Global.register_rod(consumable_pack_green)
	
	var consumable_pack_purple: ConsumablePackData = ConsumablePackData.new("consumable_pack_purple")
	consumable_pack_purple.consumable_pack_color_id = "color_purple"
	Global.register_rod(consumable_pack_purple)

#endregion
