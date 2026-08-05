 ## Singleton for data generation in actual production.
## This is used to make content programmatically instead of messing with more fragile external JSON files.
extends Node

#region standard action data
var influence_action: Dictionary = 		{
		Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"pick_played_card": true,
			"modify_parent_card": false,
			"card_influence":1,
		},
		Scripts.ACTION_VALIDATOR: {
			"validator_data":
				[
				{
				Scripts.VALIDATOR_CARD_PROPERTIES:
					{
					"card_property_name": "card_influence",
					"operator": ">=",
					"comparison_value": 7,
					"invert_validation": false,	
					}
				},
				{
					Scripts.VALIDATOR_CARD_UPGRADEABLE:
						{}
				}
				],
			"passed_action_data":
				[
					{
						Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/upgrade.wav"},
					},
					{
						Scripts.ACTION_UPGRADE_CARDS:
						{
							"pick_played_card": true
						}
					},
					{
						Scripts.ACTION_CHANGE_CARD_INFLUENCE:
							{
								"pick_played_card": true,
								"modify_parent_card": false,
								"card_influence": -4,
							}
					}
				]
		}
	}

var durability_action_data: Array[Dictionary] = [
			# check flag when drawn	
		{Scripts.ACTION_VALIDATOR: {
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
				# exhaust
				"passed_action_data":
				[
					{
					Scripts.ACTION_CHANGE_CARD_PLAY_DESTINATION: {
						"card_destination": HandManager.EXHAUST_PILE
						},
					},
				]
			}
		},
		{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{
			"pick_played_card": true,
			"modify_parent_card": false,
			"card_influence":-1,
		}},
	]

var exhaust_action: Dictionary = {
		Scripts.ACTION_PICK_CARDS: {
			"min_card_amount": 0,
			"max_card_amount": 1,
			"min_cards_are_required_for_action": false,
			"random_selection": false,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose up to {0} card(s) to exhaust. {1} cards selected",
			"action_data": [
			{Scripts.ACTION_EXHAUST_CARDS:{}}
			]
			}}
			
var inspect_action: Dictionary = {
		Scripts.ACTION_PICK_CARDS:
			{
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_rock","card_treasure","card_spice"]}}],
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
						"card_value_improvements":{"ore_amount":1,"money_amount":1},
						"time_delay": 0.1,
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
							"card_value_improvements":{"ore_amount":2,"money_amount":2},
							"time_delay": 0.1,
							"modify_parent_card": false,
						}}],
						}
					}]
				}
		}]}
		}

var cook_action: Dictionary = {
		Scripts.ACTION_VALIDATOR:{
			"validator_data": [{Scripts.VALIDATOR_FOOD:{ "food_required": 3}}],
			"passed_action_data": [
				{
				Scripts.ACTION_CREATE_CARDS: {
					"created_card_object_id":"card_delicacy",
					"number_of_cards": 1,
					"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
					}
					},
			{
				Scripts.ACTION_ADD_FOOD:{"food_amount":-3}
				}
				]
				}
			}
			
var forge_action: Dictionary = {
		Scripts.ACTION_VALIDATOR:{
			"validator_data": [{Scripts.VALIDATOR_ORE:{}}],
			"passed_action_data": [
				{
				Scripts.ACTION_CREATE_CARDS: {
					"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
					}
					},
			{
				Scripts.ACTION_ADD_ORE:{}
				}
				]
				}
			}
			
var weave_action: Dictionary = {
		Scripts.ACTION_VALIDATOR:{
			"validator_data": [{Scripts.VALIDATOR_INSIGHT:{}}],
			"passed_action_data": [
				{
				Scripts.ACTION_CREATE_CARDS: {
					"created_card_object_id":"card_scroll",
					"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
					}
					},
			{
				Scripts.ACTION_ADD_INSIGHT:{}
				}
				]
				}
			}
			
var wield_action: Dictionary = {
		Scripts.ACTION_PICK_CARDS:
				{
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_sword"]}}],
				"action_data": [{Scripts.ACTION_PLAY_CARDS:{}}]
		}
		}

var influence_upgrade_action: Dictionary = {
	Scripts.ACTION_VALIDATOR:
	{
		"validator_data": [{
			Scripts.VALIDATOR_CARD_PROPERTIES:
				{
					"card_property_name": "card_influence",
					"operator": ">=",
					"comparison_value": 8,
					"invert_validation": false,
				}
		},{Scripts.VALIDATOR_CARD_UPGRADEABLE:
			{
			}}],
		"action_data": [{
			Scripts.ACTION_UPGRADE_CARDS: {"pick_played_card": true}
		}, {Scripts.ACTION_CHANGE_CARD_INFLUENCE:{"pick_played_card":true,"card_infuence":-5}}]
	}
	}

var end_action_data: Array[Dictionary] = [
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
#endregion

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
	var artifact_add_size: ArtifactData = ArtifactData.new("artifact_add_size")
	artifact_add_size.artifact_name = "Town Hall"
	artifact_add_size.artifact_texture_path = "external/sprites/artifacts/townhall.svg"
	artifact_add_size.artifact_description = "Adds 7 Size when obtained."
	artifact_add_size.artifact_shop_description = "Adds 7 Size when obtained."
	artifact_add_size.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_add_size.artifact_add_actions = [{Scripts.ACTION_ADD_KINGDOM_SIZE: {"size_amount": 7}}]
	Global.register_rod(artifact_add_size)
	
	var artifact_add_room: ArtifactData = ArtifactData.new("artifact_add_room")
	artifact_add_room.artifact_name = "Landscaping Office"
	artifact_add_room.artifact_texture_path = "external/sprites/artifacts/landscapingoffice.svg"
	artifact_add_room.artifact_description = "Adds 3 Room when obtained."
	artifact_add_room.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_add_room.artifact_shop_description = "Adds 3 Room when obtained."
	artifact_add_room.artifact_add_actions = [{Scripts.ACTION_ADD_ROOM: {"room_amount": 3}}]
	Global.register_rod(artifact_add_room)
	
	var artifact_food_per_turn: ArtifactData = ArtifactData.new("artifact_food_per_turn")
	artifact_food_per_turn.artifact_name = "Granary"
	artifact_food_per_turn.artifact_texture_path = "external/sprites/artifacts/granary.svg"
	artifact_food_per_turn.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_food_per_turn.artifact_description = "Adds 1 Food per turn. Increases by 1 per 5 Insight (3 max)."
	artifact_food_per_turn.artifact_shop_description = "Adds 1 Food per turn."
	artifact_food_per_turn.artifact_turn_start_actions = [{Scripts.ACTION_ADD_FOOD: {"food_amount": 1}},
	{Scripts.ACTION_VALIDATOR: {"validator_data":[{Scripts.VALIDATOR_INSIGHT:{"insight_required":5}}],"passed_action_data":[{Scripts.ACTION_ADD_FOOD:{"food_amount":1}}]}},
	{Scripts.ACTION_VALIDATOR: {"validator_data":[{Scripts.VALIDATOR_INSIGHT:{"insight_required":10}}],"passed_action_data":[{Scripts.ACTION_ADD_FOOD:{"food_amount":1}}]}}
	]
	Global.register_rod(artifact_food_per_turn)
	
	var artifact_ore_per_turn: ArtifactData = ArtifactData.new("artifact_ore_per_turn")
	artifact_ore_per_turn.artifact_name = "Quarry"
	artifact_ore_per_turn.artifact_texture_path = "external/sprites/artifacts/quarry.svg"
	artifact_ore_per_turn.artifact_description = "Adds 1 Ore per turn. Increases by 1 per 7 Insight (3 max)."
	artifact_ore_per_turn.artifact_shop_description = "Adds 1 Ore per turn."
	artifact_ore_per_turn.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_ore_per_turn.artifact_turn_start_actions = [{Scripts.ACTION_ADD_ORE: {"ore_amount": 1}},
	{Scripts.ACTION_VALIDATOR: {"validator_data":[{Scripts.VALIDATOR_INSIGHT:{"insight_required":7}}],"passed_action_data":[{Scripts.ACTION_ADD_ORE:{"ore_amount":1}}]}},
	{Scripts.ACTION_VALIDATOR: {"validator_data":[{Scripts.VALIDATOR_INSIGHT:{"insight_required":14}}],"passed_action_data":[{Scripts.ACTION_ADD_ORE:{"ore_amount":1}}]}}
	]
	Global.register_rod(artifact_ore_per_turn)
	
	var artifact_insight_periodic: ArtifactData = ArtifactData.new("artifact_insight_periodic")
	artifact_insight_periodic.artifact_name = "Library"
	artifact_insight_periodic.artifact_texture_path = "external/sprites/artifacts/library.svg"
	artifact_insight_periodic.artifact_description = "Adds 1 Insight every 4 turns."
	artifact_insight_periodic.artifact_shop_description = "Adds 1 Insight every 4 turns."
	artifact_insight_periodic.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_insight_periodic.artifact_turn_start_actions = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{}}]
	artifact_insight_periodic.artifact_counter_max = 4
	artifact_insight_periodic.artifact_max_counter_actions = [{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":1}}]

	Global.register_rod(artifact_insight_periodic)
	
	var artifact_fertiliser: ArtifactData = ArtifactData.new("artifact_fertiliser")
	artifact_fertiliser.artifact_name = "Fertiliser"
	artifact_fertiliser.artifact_texture_path = "external/sprites/artifacts/fertiliser.svg"
	artifact_fertiliser.artifact_description = "Fertilises grains in draw pile at 2 charges. Increase by 1 charge per turn."
	#artifact_fertiliser.artifact_shop_description = "Adds 1 Insight every 4 turns."
	artifact_fertiliser.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BASIC
	artifact_fertiliser.artifact_turn_start_actions = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{}}]
	#artifact_fertiliser.artifact_script_path = "res://scripts/artifacts/ArtifactFertiliseChargeIncrease.gd"
	artifact_fertiliser.artifact_counter_max = 2
	artifact_fertiliser.artifact_max_counter_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 99,
		"max_card_amount": 99,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DRAW_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_ID: {"card_object_ids":["card_grain"]}}
		],
		"action_data": [
		{Scripts.ACTION_IMPROVE_CARD_VALUES:{"card_value_improvements": {"food_amount": 1}}}
			]
		}
	}]

	Global.register_rod(artifact_fertiliser)
	#
	#var artifact_discard_appease: ArtifactData = ArtifactData.new("artifact_discard_appease")
	#artifact_discard_appease.artifact_name = "Artifact Discard Appease"
	#artifact_discard_appease.artifact_description = "Every 4 Faction cards discarded, appease 2 random cards in discard pile."
	#artifact_discard_appease.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	#artifact_discard_appease.artifact_counter_max = 4
	#artifact_discard_appease.artifact_script_path = "res://scripts/artifacts/ArtifactDiscardAppease.gd"
	#artifact_discard_appease.artifact_max_counter_actions = [{		
		#Scripts.ACTION_PICK_CARDS: {
		#"min_card_amount": 2,
		#"max_card_amount": 2,
		#"min_cards_are_required_for_action": false,
		#"random_selection": true,
		#"card_pick_type": HandManager.DISCARD_PILE,
		#"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		#"validator_data": [
			#{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		#],
		#"action_data": [
			#{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence": 1
			#}},
			#]
		#}
		#}]
	#
	#Global.register_rod(artifact_discard_appease)
	#
	#var artifact_draw_on_kill: ArtifactData = ArtifactData.new("artifact_draw_on_kill")
	#artifact_draw_on_kill.artifact_name = "Artifact Draw on Kill"
	#artifact_draw_on_kill.artifact_description = "Draws %s card(s) when an enemy is killed. (Draw 1 more card per 5 insight.)"
	#artifact_draw_on_kill.artifact_insight_increment = {"base": 1, "insight": 5, "increment": 1}
	#artifact_draw_on_kill.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	#artifact_draw_on_kill.artifact_script_path = "res://scripts/artifacts/ArtifactDrawOnKill.gd"
	#
	#Global.register_rod(artifact_draw_on_kill)
	#
	#var artifact_energy_every_four_turns: ArtifactData = ArtifactData.new("artifact_energy_every_four_turns")
	#artifact_energy_every_four_turns.artifact_name = "Artifact Every Few Turns"
	#artifact_energy_every_four_turns.artifact_description = "Gain %s energy every 4 turns. (Gain 1 more energy per 8 insight.)"
	#artifact_energy_every_four_turns.artifact_insight_increment = {"base": 1, "insight": 8, "increment": 1}
	#artifact_energy_every_four_turns.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	#artifact_energy_every_four_turns.artifact_color_id = "color_white"
	#artifact_energy_every_four_turns.artifact_texture_path = "external/sprites/artifacts/artifact_white.png"
	#artifact_energy_every_four_turns.artifact_counter_wraparound = true
	#artifact_energy_every_four_turns.artifact_turn_start_actions = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{}}]
	#artifact_energy_every_four_turns.artifact_counter_max = 4
	#artifact_energy_every_four_turns.artifact_max_counter_actions = [{Scripts.ACTION_ADD_ARTIFACT_ENERGY: {"energy_amount": 1}}]
	#
	#Global.register_rod(artifact_energy_every_four_turns)
	#
		#
	var artifact_inspect_on_exhaust: ArtifactData = ArtifactData.new("artifact_inspect_on_exhaust")
	artifact_inspect_on_exhaust.artifact_name = "Inspectorate"
	artifact_inspect_on_exhaust.artifact_texture_path = "external/sprites/artifacts/inspectorate.svg"
	artifact_inspect_on_exhaust.artifact_description = "Whenever a card is exhausted, gain %s charge. Then, spend 3 charges to Inspect once. (Improve charge gain by 1 per 5 insight.)"
	artifact_inspect_on_exhaust.artifact_shop_description = "Every few cards exhausted, Inspect."
	artifact_inspect_on_exhaust.artifact_insight_increment = {"base": 1, "insight": 5, "increment": 1}
	artifact_inspect_on_exhaust.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_inspect_on_exhaust.artifact_color_id = "color_white"
	artifact_inspect_on_exhaust.artifact_counter_wraparound = true
	artifact_inspect_on_exhaust.artifact_script_path = "res://scripts/artifacts/ArtifactExhaustInspect.gd"
	artifact_inspect_on_exhaust.artifact_counter_max = 3
	var artifact_inspect_action: Dictionary = {
		Scripts.ACTION_PICK_CARDS:
			{
				"min_card_amount":1,
				"max_card_amount":1,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_rock","card_treasure","card_spice"]}}],
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
						"card_value_improvements":{"ore_amount":1,"money_amount":1},
						"time_delay": 0.1,
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
							"card_value_improvements":{"ore_amount":2,"money_amount":2},
							"time_delay": 0.1,
							"modify_parent_card": false,
						}}],
						}
					}]
				}
		}]}
		}
	artifact_inspect_on_exhaust.artifact_max_counter_actions.append(artifact_inspect_action)
#
	Global.register_rod(artifact_inspect_on_exhaust)
	
	var artifact_money_on_exhaust: ArtifactData = ArtifactData.new("artifact_money_on_exhaust")
	artifact_money_on_exhaust.artifact_name = "Caravan"
	artifact_money_on_exhaust.artifact_texture_path = "external/sprites/artifacts/caravan.svg"
	artifact_money_on_exhaust.artifact_description = "Whenever a card is exhausted, gain %s charge. Then, spend 3 charges to gain 2 Money. (Improve charge gain by 1 per 5 insight.)"
	artifact_money_on_exhaust.artifact_shop_description = "Every few cards exhausted, gain 2 Money."
	artifact_money_on_exhaust.artifact_insight_increment = {"base": 1, "insight": 5, "increment": 1}
	artifact_money_on_exhaust.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	artifact_money_on_exhaust.artifact_color_id = "color_white"
	artifact_money_on_exhaust.artifact_counter_wraparound = true
	artifact_money_on_exhaust.artifact_script_path = "res://scripts/artifacts/ArtifactExhaustInspect.gd"
	artifact_money_on_exhaust.artifact_counter_max = 3
	artifact_money_on_exhaust.artifact_max_counter_actions.append(artifact_inspect_action)
#
	Global.register_rod(artifact_money_on_exhaust)
#

	var artifact_check_scroll: ArtifactData = ArtifactData.new("artifact_check_scroll")
	artifact_check_scroll.artifact_name = "Artifact Check Scroll"
	artifact_check_scroll.artifact_description = "Draft a Book after 3 Scroll plays."
	artifact_check_scroll.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.BASIC
	artifact_check_scroll.artifact_color_id = "color_red"
	artifact_check_scroll.artifact_texture_path = "external/sprites/artifacts/artifact_red.png"
	artifact_check_scroll.artifact_script_path = "res://scripts/artifacts/ArtifactCheckScroll.gd"
	artifact_check_scroll.artifact_counter_max = 3
	artifact_check_scroll.artifact_turn_end_actions = []
	artifact_check_scroll.artifact_counter_wraparound = true
	artifact_check_scroll.artifact_max_counter_actions = [{Scripts.ACTION_PICK_CARDS:
		{
			"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			"pick_draft_cards": false,
			"draft_from_card_pool": true,
			"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}},{Scripts.ACTION_ADD_CARDS_TO_DECK:{}}],
			"validator_data": [],
			# use same rng as player drafting so it counts as draft
			"rng_name": "rng_card_drafting",
			"draft_card_pack_id": "card_pack_blue"
		}}]
	
	Global.register_rod(artifact_check_scroll)
	
	### Enables a rest action when obtained, which grants a damage increase at the start of combat
	#var artifact_improve_explore: ArtifactData = ArtifactData.new("artifact_improve_explore")
	#artifact_improve_explore.artifact_name = "Barracks"
	#artifact_improve_explore.artifact_description = "Increases Explore by 1."
	#artifact_improve_explore.artifact_shop_description = "Increases Explore by 1."
	##artifact_improve_explore.artifact_insight_increment = {"base": 1, "insight": 8, "increment": 1}
	#artifact_improve_explore.artifact_counter_reset_on_turn_start = 1
	#artifact_improve_explore.artifact_counter_max = 1
	#artifact_improve_explore.artifact_color_id = "color_orange"
	#artifact_improve_explore.artifact_texture_path = "external/sprites/artifacts/barracks.svg"
	#artifact_improve_explore.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	#artifact_improve_explore.artifact_first_turn_actions = [{
		#Scripts.ACTION_APPLY_STATUS: {
			#"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
			#"status_effect_object_id": "status_effect_damage_increase",
			#"custom_key_names": {
					## convert artifact counter passed in from BaseArtifact, into the status charges
				#"status_charge_amount": "artifact_counter"
			#}}
		#}]
	#
	#Global.register_rod(artifact_improve_explore)
	
	### Enables a rest action when obtained, which grants a damage increase at the start of combat
	#var artifact_improve_explore: ArtifactData = ArtifactData.new("artifact_improve_explore")
	#artifact_improve_explore.artifact_name = "Barracks"
	#artifact_improve_explore.artifact_description = "Increases Explore by 1."
	#artifact_improve_explore.artifact_shop_description = "Increases Explore by 1."
	##artifact_improve_explore.artifact_insight_increment = {"base": 1, "insight": 8, "increment": 1}
	#artifact_improve_explore.artifact_counter_reset_on_turn_start = 1
	#artifact_improve_explore.artifact_counter_max = 1
	#artifact_improve_explore.artifact_color_id = "color_orange"
	#artifact_improve_explore.artifact_texture_path = "external/sprites/artifacts/barracks.svg"
	#artifact_improve_explore.artifact_rarity = ArtifactData.ARTIFACT_RARITIES.SHOP
	#artifact_improve_explore.artifact_first_turn_actions = [{
		#Scripts.ACTION_APPLY_STATUS: {
			#"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
			#"status_effect_object_id": "status_effect_damage_increase",
			#"custom_key_names": {
					## convert artifact counter passed in from BaseArtifact, into the status charges
				#"status_charge_amount": "artifact_counter"
			#}}
		#}]
	#
	#Global.register_rod(artifact_improve_explore)

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
				"money_required": 25
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
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE: {"artifact_id": "a"}},
	]
	
	Global.register_rod(rest_action_increase_attack_on_rest)
#endregion

#region Status Effects
func add_status_effects() -> void:
	
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
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_fish_reward: StatusEffectData = StatusEffectData.new("status_effect_fish_reward")
	status_effect_fish_reward.status_effect_name = "Fish"
	status_effect_fish_reward.status_effect_texture_path = "external/sprites/status_effects/fish.svg"
	status_effect_fish_reward.status_effect_is_visible = true
	status_effect_fish_reward.status_effect_decay_rate = 0
	status_effect_fish_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_fish_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_fish_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_fish_reward)

	# Reward (simply to explain what objects of interest do)
	var status_effect_delicacy_reward: StatusEffectData = StatusEffectData.new("status_effect_delicacy_reward")
	status_effect_delicacy_reward.status_effect_name = "Delicacy"
	status_effect_delicacy_reward.status_effect_texture_path = "external/sprites/status_effects/delicacy.svg"
	status_effect_delicacy_reward.status_effect_is_visible = true
	status_effect_delicacy_reward.status_effect_decay_rate = 0
	status_effect_delicacy_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_delicacy_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_delicacy_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_delicacy_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_rock_reward: StatusEffectData = StatusEffectData.new("status_effect_rock_reward")
	status_effect_rock_reward.status_effect_name = "Rock"
	status_effect_rock_reward.status_effect_texture_path = "external/sprites/status_effects/rock.svg"
	status_effect_rock_reward.status_effect_is_visible = true
	status_effect_rock_reward.status_effect_decay_rate = 0
	status_effect_rock_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_rock_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_rock_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_rock_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_refresh_reward: StatusEffectData = StatusEffectData.new("status_effect_refresh_reward")
	status_effect_refresh_reward.status_effect_name = "Shop Refresh"
	status_effect_refresh_reward.status_effect_texture_path = "external/sprites/status_effects/refresh.svg"
	status_effect_refresh_reward.status_effect_is_visible = true
	status_effect_refresh_reward.status_effect_decay_rate = 0
	status_effect_refresh_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_refresh_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_refresh_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_refresh_reward)
	
		# Reward (simply to explain what objects of interest do)
	var status_effect_insight_reward: StatusEffectData = StatusEffectData.new("status_effect_insight_reward")
	status_effect_insight_reward.status_effect_name = "Insight"
	status_effect_insight_reward.status_effect_texture_path = "external/sprites/status_effects/insight.svg"
	status_effect_insight_reward.status_effect_is_visible = true
	status_effect_insight_reward.status_effect_decay_rate = 0
	status_effect_insight_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_insight_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_insight_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_insight_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_grain_reward: StatusEffectData = StatusEffectData.new("status_effect_grain_reward")
	status_effect_grain_reward.status_effect_name = "Grain"
	status_effect_grain_reward.status_effect_texture_path = "external/sprites/status_effects/grain.svg"
	status_effect_grain_reward.status_effect_is_visible = true
	status_effect_grain_reward.status_effect_decay_rate = 0
	status_effect_grain_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_grain_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_grain_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_grain_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_fertiliser_reward: StatusEffectData = StatusEffectData.new("status_effect_fertiliser_reward")
	status_effect_fertiliser_reward.status_effect_name = "Fertilise"
	status_effect_fertiliser_reward.status_effect_texture_path = "external/sprites/artifacts/fertiliser.svg"
	status_effect_fertiliser_reward.status_effect_is_visible = true
	status_effect_fertiliser_reward.status_effect_decay_rate = 0
	status_effect_fertiliser_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_fertiliser_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_fertiliser_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_fertiliser_reward)
	
		# Reward (simply to explain what objects of interest do)
	var status_effect_money_reward: StatusEffectData = StatusEffectData.new("status_effect_money_reward")
	status_effect_money_reward.status_effect_name = "Money"
	status_effect_money_reward.status_effect_texture_path = "external/sprites/status_effects/money.svg"
	status_effect_money_reward.status_effect_is_visible = true
	status_effect_money_reward.status_effect_decay_rate = 0
	status_effect_money_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_money_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_money_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_money_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_room_reward: StatusEffectData = StatusEffectData.new("status_effect_room_reward")
	status_effect_room_reward.status_effect_name = "Room"
	status_effect_room_reward.status_effect_texture_path = "external/sprites/status_effects/room.svg"
	status_effect_room_reward.status_effect_is_visible = true
	status_effect_room_reward.status_effect_decay_rate = 0
	status_effect_room_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_room_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_room_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_room_reward)
	
		# Reward (simply to explain what objects of interest do)
	var status_effect_spice_reward: StatusEffectData = StatusEffectData.new("status_effect_spice_reward")
	status_effect_spice_reward.status_effect_name = "Spice"
	status_effect_spice_reward.status_effect_texture_path = "external/sprites/status_effects/spice.svg"
	status_effect_spice_reward.status_effect_is_visible = true
	status_effect_spice_reward.status_effect_decay_rate = 0
	status_effect_spice_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_spice_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_spice_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_spice_reward)
	
	# Reward (simply to explain what objects of interest do)
	var status_effect_size_reward: StatusEffectData = StatusEffectData.new("status_effect_size_reward")
	status_effect_size_reward.status_effect_name = "Size"
	status_effect_size_reward.status_effect_texture_path = "external/sprites/status_effects/size.svg"
	status_effect_size_reward.status_effect_is_visible = true
	status_effect_size_reward.status_effect_decay_rate = 0
	status_effect_size_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_size_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_size_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_size_reward)
	
		# Reward (simply to explain what objects of interest do)
	var status_effect_treasure_reward: StatusEffectData = StatusEffectData.new("status_effect_treasure_reward")
	status_effect_treasure_reward.status_effect_name = "Treasure"
	status_effect_treasure_reward.status_effect_texture_path = "external/sprites/status_effects/treasure.svg"
	status_effect_treasure_reward.status_effect_is_visible = true
	status_effect_treasure_reward.status_effect_decay_rate = 0
	status_effect_treasure_reward.status_effect_decay_type = StatusEffectData.STATUS_EFFECT_DECAY_TYPES.LINEAR
	status_effect_treasure_reward.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_treasure_reward.status_effect_action_process_times = []
	
	Global.register_rod(status_effect_treasure_reward)
	
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
	
		# increases attack damage by charge amount
	# uses an interceptor
	var status_effect_temp_damage_increase: StatusEffectData = StatusEffectData.new("status_effect_temp_damage_increase")
	status_effect_temp_damage_increase.status_effect_name = "Temp Damage Increase"
	status_effect_temp_damage_increase.status_effect_texture_path = "external/sprites/status_effects/status_effect_green.png"
	status_effect_temp_damage_increase.status_effect_decay_rate = -99
	status_effect_temp_damage_increase.status_effect_type = StatusEffectData.STATUS_EFFECT_TYPES.BUFF
	status_effect_temp_damage_increase.status_effect_interceptor_ids = ["interceptor_temp_damage_increase"]
	
	Global.register_rod(status_effect_temp_damage_increase)
	
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
	
	act_1.act_medium_plains_event_pool_object_id = "event_pool_act_1_plains_medium"
	act_1.act_medium_forest_event_pool_object_id = "event_pool_act_1_forest_medium"
	act_1.act_medium_desert_event_pool_object_id = "event_pool_act_1_desert_medium"
	act_1.act_medium_coast_event_pool_object_id = "event_pool_act_1_coast_medium"
	act_1.act_medium_swamp_event_pool_object_id = "event_pool_act_1_swamp_medium"
	
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
		{"field_patch": 1},
		{"rock": 1}]
	
	Global.register_rod(event_act_1_easy_plains_1)
	
	var event_act_1_easy_plains_2: EventData = EventData.new("event_act_1_easy_plains_2")
	event_act_1_easy_plains_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_plains_2.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"field_patch": 1},
		{"pond": 1}]
	
	Global.register_rod(event_act_1_easy_plains_2)
	
	var event_act_1_easy_plains_3: EventData = EventData.new("event_act_1_easy_plains_3")
	event_act_1_easy_plains_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_plains_3.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"field_patch": 1},
		{"mound": 1}]
	
	Global.register_rod(event_act_1_easy_plains_3)
	
	var event_act_1_medium_plains_1: EventData = EventData.new("event_act_1_medium_plains_1")
	event_act_1_medium_plains_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_plains_1.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"pond": 1},
		{"chargedvista": 0.5}
		]
	
	Global.register_rod(event_act_1_medium_plains_1)
	
	var event_act_1_medium_plains_2: EventData = EventData.new("event_act_1_medium_plains_2")
	event_act_1_medium_plains_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_plains_2.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"rock": 1},
		{"animalherd": 0.5}
		]
	
	Global.register_rod(event_act_1_medium_plains_2)
	
	var event_act_1_medium_plains_3: EventData = EventData.new("event_act_1_medium_plains_3")
	event_act_1_medium_plains_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_plains_3.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"field_patch": 1},
		{"chargedvista": 0.5},
		{"animalherd": 0.5}
		]
		
	var event_act_1_hard_plains_1: EventData = EventData.new("event_act_1_hard_plains_1")
	event_act_1_hard_plains_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_1.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"chargedvista": 1}
		]
	
	Global.register_rod(event_act_1_hard_plains_1)
	
	var event_act_1_hard_plains_2: EventData = EventData.new("event_act_1_hard_plains_2")
	event_act_1_hard_plains_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_2.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"rock": 1},
		{"rock": 1},
		{"animalherd": 1}
		]
	
	Global.register_rod(event_act_1_hard_plains_2)
	
	var event_act_1_hard_plains_3: EventData = EventData.new("event_act_1_hard_plains_3")
	event_act_1_hard_plains_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_plains_3.event_weighted_enemy_object_ids = [
		{"field_patch": 1},
		{"field_patch": 1},
		{"chargedvista": 1},
		{"animalherd": 1}
		]
	
	Global.register_rod(event_act_1_hard_plains_3)
	
		## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_desert_1: EventData = EventData.new("event_act_1_easy_desert_1")
	event_act_1_easy_desert_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_1.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"boulder": 1},
		{"barrenwastes":0.6}
		]
	
	Global.register_rod(event_act_1_easy_desert_1)
	
	var event_act_1_easy_desert_2: EventData = EventData.new("event_act_1_easy_desert_2")
	event_act_1_easy_desert_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_2.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder":1},
		]
	
	Global.register_rod(event_act_1_easy_desert_2)
	
	var event_act_1_easy_desert_3: EventData = EventData.new("event_act_1_easy_desert_3")
	event_act_1_easy_desert_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_desert_3.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"mound": 1},
		{"barrenwastes":0.6},
		]
	
	Global.register_rod(event_act_1_easy_desert_3)
	
	var event_act_1_medium_desert_1: EventData = EventData.new("event_act_1_medium_desert_1")
	event_act_1_medium_desert_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_desert_1.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder":1},
		{"barrenwastes": 0.6}
		]
	
	Global.register_rod(event_act_1_medium_desert_1)
	
	var event_act_1_medium_desert_2: EventData = EventData.new("event_act_1_medium_desert_2")
	event_act_1_medium_desert_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_desert_2.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder": 1},
		{"islandanomaly":0.6}
		]
	
	Global.register_rod(event_act_1_medium_desert_2)
	
	var event_act_1_medium_desert_3: EventData = EventData.new("event_act_1_medium_desert_3")
	event_act_1_medium_desert_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_desert_3.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder": 1},
		{"barren_wastes": 0.6},
		{"islandanomaly":0.6}
		]
	
	Global.register_rod(event_act_1_medium_desert_3)
	
	var event_act_1_hard_desert_1: EventData = EventData.new("event_act_1_hard_desert_1")
	event_act_1_hard_desert_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_1.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"bigboulder": 1},
		{"barrenwastes": 1},
		{"barrenwastes": 1}
		]
	
	Global.register_rod(event_act_1_hard_desert_1)
	
	var event_act_1_hard_desert_2: EventData = EventData.new("event_act_1_hard_desert_2")
	event_act_1_hard_desert_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_2.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"boulder": 1},
		{"islandanomaly":1}
		]
	
	Global.register_rod(event_act_1_hard_desert_2)
	
	var event_act_1_hard_desert_3: EventData = EventData.new("event_act_1_hard_desert_3")
	event_act_1_hard_desert_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_desert_3.event_weighted_enemy_object_ids = [
		{"boulder": 1},
		{"boulder": 1},
		{"bigboulder": 1},
		{"barren_wastes": 1},
		{"islandanomaly":1}
		]
	
	Global.register_rod(event_act_1_hard_desert_3)
	
	## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_easy_forest_1: EventData = EventData.new("event_act_1_easy_forest_1")
	event_act_1_easy_forest_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_1.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestfloor": 1},
		]
	
	Global.register_rod(event_act_1_easy_forest_1)
	
	var event_act_1_easy_forest_2: EventData = EventData.new("event_act_1_easy_forest_2")
	event_act_1_easy_forest_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_2.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestmulch": 1},
		]
	
	Global.register_rod(event_act_1_easy_forest_2)
	
	var event_act_1_easy_forest_3: EventData = EventData.new("event_act_1_easy_forest_3")
	event_act_1_easy_forest_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_forest_3.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestfloor": 1},
		{"forestfloor": 0.6},
		]
	
	Global.register_rod(event_act_1_easy_forest_3)
	
		# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_medium_forest_1: EventData = EventData.new("event_act_1_medium_forest_1")
	event_act_1_medium_forest_1.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_forest_1.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"den": 1},
		]
	
	Global.register_rod(event_act_1_medium_forest_1)
	
	var event_act_1_medium_forest_2: EventData = EventData.new("event_act_1_medium_forest_2")
	event_act_1_medium_forest_2.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_forest_2.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestfloor": 1},
		{"hideout": 0.6},
		]
	
	Global.register_rod(event_act_1_medium_forest_2)
	
	var event_act_1_medium_forest_3: EventData = EventData.new("event_act_1_medium_forest_3")
	event_act_1_medium_forest_3.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_forest_3.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestfloor": 1},
		{"forestfloor": 1},
		]
	
	Global.register_rod(event_act_1_medium_forest_3)
	
	
	var event_act_1_hard_forest_1: EventData = EventData.new("event_act_1_hard_forest_1")
	event_act_1_hard_forest_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_1.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"den": 1},
		]
	
	Global.register_rod(event_act_1_hard_forest_1)
	
	var event_act_1_hard_forest_2: EventData = EventData.new("event_act_1_hard_forest_2")
	event_act_1_hard_forest_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_2.event_weighted_enemy_object_ids = [
		{"forestfloor": 1},
		{"forestfloor": 1},
		{"hideout": 1},
		]
	
	Global.register_rod(event_act_1_hard_forest_2)
	
	var event_act_1_hard_forest_3: EventData = EventData.new("event_act_1_hard_forest_3")
	event_act_1_hard_forest_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_forest_3.event_weighted_enemy_object_ids = [
		{"forestmulch": 1},
		{"forestmulch": 1},
		{"forestfloor": 1},
		{"den": 1},
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
		{"shore":1},
		{"rockface": 0.5},
		]
	
	Global.register_rod(event_act_1_easy_coast_1)
	
	var event_act_1_easy_coast_2: EventData = EventData.new("event_act_1_easy_coast_2")
	event_act_1_easy_coast_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_coast_2.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"shore": 1},
		{"rockface": 1},
		]
	
	Global.register_rod(event_act_1_easy_coast_2)
	
	var event_act_1_easy_coast_3: EventData = EventData.new("event_act_1_easy_coast_3")
	event_act_1_easy_coast_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_coast_3.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"rockface": 1},
		{"rockface": 1},
		]
	
	Global.register_rod(event_act_1_easy_coast_3)
	
	
		
	## Act 1 Combat
	# has an equal chance of spawning 1 of 3 enemies in each slot
	var event_act_1_medium_coast_1: EventData = EventData.new("event_act_1_medium_coast_1")
	event_act_1_medium_coast_1.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_coast_1.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"shore": 1},
		{"sandbed":1},
		{"cave": 0.5},
		]
	
	Global.register_rod(event_act_1_medium_coast_1)
	
	var event_act_1_medium_coast_2: EventData = EventData.new("event_act_1_medium_coast_2")
	event_act_1_medium_coast_2.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_coast_2.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"sandbed": 1},
		{"sandbed": 1},
		]
	
	Global.register_rod(event_act_1_medium_coast_2)
	
	var event_act_1_medium_coast_3: EventData = EventData.new("event_act_1_medium_coast_3")
	event_act_1_medium_coast_3.event_death_message_bbcode = "Died to medium event"
	event_act_1_medium_coast_3.event_weighted_enemy_object_ids = [
		{"shore": 1},
		{"rockface": 1},
		{"sandbed": 1},
		]
	
	Global.register_rod(event_act_1_medium_coast_3)
	
	
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
		{"cave": 1},
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
		{"infestedwaters": 0.5},
		{"mangroveroots": 0.4}
		]
	
	Global.register_rod(event_act_1_easy_swamp_1)
	
	var event_act_1_easy_swamp_2: EventData = EventData.new("event_act_1_easy_swamp_2")
	event_act_1_easy_swamp_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_swamp_2.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"infestedwaters":1},
		{"mangroveroots": 0.4}
		]
	
	Global.register_rod(event_act_1_easy_swamp_2)
	
	var event_act_1_easy_swamp_3: EventData = EventData.new("event_act_1_easy_swamp_3")
	event_act_1_easy_swamp_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_easy_swamp_3.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"dryfield": 1},
		{"dryfield": 1},
		{"mangroveroots": 1}
		]
	
	Global.register_rod(event_act_1_easy_swamp_3)
	
	
	var event_act_1_medium_swamp_1: EventData = EventData.new("event_act_1_medium_swamp_1")
	event_act_1_medium_swamp_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_swamp_1.event_weighted_enemy_object_ids = [
		{"dryfield": 1},
		{"mangroveroots": 1},
		{"mangroveroots": 1},
		{"infestedwaters": 1}
		]
	
	Global.register_rod(event_act_1_medium_swamp_1)
	
	var event_act_1_medium_swamp_2: EventData = EventData.new("event_act_1_medium_swamp_2")
	event_act_1_medium_swamp_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_swamp_2.event_weighted_enemy_object_ids = [
		{"mangroveroots": 1},
		{"mangroveroots": 1},
		{"brackishbeds": 1},
		]
	
	Global.register_rod(event_act_1_medium_swamp_2)
	
	var event_act_1_medium_swamp_3: EventData = EventData.new("event_act_1_medium_swamp_3")
	event_act_1_medium_swamp_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_medium_swamp_3.event_weighted_enemy_object_ids = [
		{"mangroveroots": 1},
		{"infestedwaters": 1},
		{"brackishbeds":1}
		]
	
	Global.register_rod(event_act_1_medium_swamp_3)
	
	
	var event_act_1_hard_swamp_1: EventData = EventData.new("event_act_1_hard_swamp_1")
	event_act_1_hard_swamp_1.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_1.event_weighted_enemy_object_ids = [
		{"mangroveroots": 1},
		{"brackishbeds": 1},
		{"brackishbeds": 1},
		{"infestedwaters": 1}
		]
	
	Global.register_rod(event_act_1_hard_swamp_1)
	
	var event_act_1_hard_swamp_2: EventData = EventData.new("event_act_1_hard_swamp_2")
	event_act_1_hard_swamp_2.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_2.event_weighted_enemy_object_ids = [
		{"brackishbeds": 1},
		{"infestedwaters": 1},
		{"hut": 1},
		]
	
	Global.register_rod(event_act_1_hard_swamp_2)
	
	var event_act_1_hard_swamp_3: EventData = EventData.new("event_act_1_hard_swamp_3")
	event_act_1_hard_swamp_3.event_death_message_bbcode = "Died to easy event"
	event_act_1_hard_swamp_3.event_weighted_enemy_object_ids = [
		{"mangroveroots": 1},
		{"mangroveroots": 1},
		{"hut": 1},
		{"brackishbeds":1}
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
		{Scripts.VALIDATOR_MONEY: {"money_required": 50}},
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
	
		# increases damage done by attackers
	var interceptor_temp_damage_increase: ActionInterceptorData = ActionInterceptorData.new("interceptor_temp_damage_increase")
	interceptor_temp_damage_increase.action_interceptor_priority = 10000
	interceptor_temp_damage_increase.action_interceptor_modifies_parent = true
	interceptor_temp_damage_increase.action_interceptor_script_path = Scripts.INTERCEPTOR_TEMP_DAMAGE_INCREASE
	interceptor_temp_damage_increase.action_intercepted_action_paths = [Scripts.ACTION_ATTACK]
	
	Global.register_rod(interceptor_temp_damage_increase)
	
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
	
	# prevents gaining money
	var interceptor_negate_add_food: ActionInterceptorData = ActionInterceptorData.new("interceptor_negate_add_food")
	interceptor_negate_add_food.action_interceptor_priority = 10000
	interceptor_negate_add_food.action_interceptor_modifies_parent = true
	interceptor_negate_add_food.action_interceptor_script_path = Scripts.INTERCEPTOR_NEGATE_ADD_FOOD
	interceptor_negate_add_food.action_intercepted_action_paths = [Scripts.ACTION_ADD_FOOD]
	
	Global.register_rod(interceptor_negate_add_food)
	
	# prevents gaining money
	var interceptor_negate_add_ore: ActionInterceptorData = ActionInterceptorData.new("interceptor_negate_add_ore")
	interceptor_negate_add_ore.action_interceptor_priority = 10000
	interceptor_negate_add_ore.action_interceptor_modifies_parent = true
	interceptor_negate_add_ore.action_interceptor_script_path = Scripts.INTERCEPTOR_NEGATE_ADD_ORE
	interceptor_negate_add_ore.action_intercepted_action_paths = [Scripts.ACTION_ADD_ORE]
	
	Global.register_rod(interceptor_negate_add_ore)
	
	# increases damage done by attackers
	var interceptor_food_increase: ActionInterceptorData = ActionInterceptorData.new("interceptor_food_increase")
	interceptor_food_increase.action_interceptor_priority = 11000
	interceptor_food_increase.action_interceptor_modifies_parent = true
	interceptor_food_increase.action_interceptor_script_path = Scripts.INTERCEPTOR_FOOD_INCREASE
	interceptor_food_increase.action_intercepted_action_paths = [Scripts.ACTION_ADD_FOOD]
	
	Global.register_rod(interceptor_temp_damage_increase)

#endregion

#region Colors

func add_colors() -> void:
	var color_green: ColorData = ColorData.new("color_green")
	color_green.color = Color.WEB_GREEN
	color_green.color_name = "Green"
	color_green.color_energy_icon_texture_path = "external/sprites/colors/jadeenergy.svg"
	Global.register_rod(color_green)
	
	var color_gold: ColorData = ColorData.new("color_gold")
	color_gold.color = Color.CORAL
	color_gold.color_name = "Gold"
	color_gold.color_energy_icon_texture_path = "external/sprites/colors/cengkihenergy.svg"
	Global.register_rod(color_gold)
	
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
	color_purple.color_energy_icon_texture_path = "external/sprites/colors/pearlenergy.svg"
	Global.register_rod(color_purple)

	var color_black: ColorData = ColorData.new("color_black")
	color_black.color = Color.BLACK
	color_black.color_name = "Black"
	color_black.color_energy_icon_texture_path = "external/sprites/colors/anisenergy.svg"
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
	
	var keyword_ore: KeywordData = KeywordData.new("keyword_ore")
	keyword_ore.keyword_name = "Ore"
	keyword_ore.keyword_text_bb_code = "Ore is used to make Crafts and Artifacts."
	Global.register_rod(keyword_ore)
	
	var keyword_forge: KeywordData = KeywordData.new("keyword_forge")
	keyword_forge.keyword_name = "Forge"
	keyword_forge.keyword_text_bb_code = "Spend 1 Ore to create a Craft."
	Global.register_rod(keyword_forge)
	
	var keyword_weave: KeywordData = KeywordData.new("keyword_weave")
	keyword_weave.keyword_name = "Weave"
	keyword_weave.keyword_text_bb_code = "Spend 1 Insight to create a Scroll."
	Global.register_rod(keyword_weave)
	
	var keyword_wield: KeywordData = KeywordData.new("keyword_wield")
	keyword_wield.keyword_name = "Wield"
	keyword_wield.keyword_text_bb_code = "Plays X random Swords in the discard pile."
	Global.register_rod(keyword_wield)
	
	var keyword_cook: KeywordData = KeywordData.new("keyword_cook")
	keyword_cook.keyword_name = "Cook"
	keyword_cook.keyword_text_bb_code = "Spend 3 food to create a Delicacy."
	Global.register_rod(keyword_cook)
	
	var keyword_inspect: KeywordData = KeywordData.new("keyword_inspect")
	keyword_inspect.keyword_name = "Inspect"
	keyword_inspect.keyword_text_bb_code = "Improve values of inspected card by 1. This increases by 1 for 5 cards in exhaust, and by 2 for 15 cards in exhaust."
	Global.register_rod(keyword_inspect)

	var keyword_fertilise: KeywordData = KeywordData.new("keyword_fertilise")
	keyword_fertilise.keyword_name = "Fertilise"
	keyword_fertilise.keyword_text_bb_code = "Increases Fertiliser charges by X amount."
	Global.register_rod(keyword_fertilise)

	var keyword_sword: KeywordData = KeywordData.new("keyword_sword")
	keyword_sword.keyword_name = "Sword"
	keyword_sword.keyword_text_bb_code = "Craft that explores 1. Can be Wielded. Has 2 durability."
	Global.register_rod(keyword_sword)
	
	var keyword_debt: KeywordData = KeywordData.new("keyword_debt")
	keyword_debt.keyword_name = "Debt"
	keyword_debt.keyword_text_bb_code = "Craft that cannot be played. Lose 1 Money at the end of turn. Has 2 durability."
	Global.register_rod(keyword_debt)
	
	var keyword_spice: KeywordData = KeywordData.new("keyword_spice")
	keyword_spice.keyword_name = "Spice"
	keyword_spice.keyword_text_bb_code = "Craft that appeases all cards in hand. Has 2 durability."
	Global.register_rod(keyword_spice)
	
	var keyword_treasure: KeywordData = KeywordData.new("keyword_treasure")
	keyword_treasure.keyword_name = "Treasure"
	keyword_treasure.keyword_text_bb_code = "Craft that gains 1 money. Can be inspected. Has 3 durability."
	Global.register_rod(keyword_treasure)
		
	var keyword_delicacy: KeywordData = KeywordData.new("keyword_delicacy")
	keyword_delicacy.keyword_name = "Delicacy"
	keyword_delicacy.keyword_text_bb_code = "Craft that draws 1 and gains 1 energy. Has 2 durability."
	Global.register_rod(keyword_delicacy)
	
	var keyword_scroll: KeywordData = KeywordData.new("keyword_scroll")
	keyword_scroll.keyword_name = "Scroll"
	keyword_scroll.keyword_text_bb_code = "Craft that is used to draft Books. Exhausts on play."
	Global.register_rod(keyword_scroll)
		
	var keyword_appease: KeywordData = KeywordData.new("keyword_appease")
	keyword_appease.keyword_name = "Appease"
	keyword_appease.keyword_text_bb_code = "Increases a Faction card's influence by 1."
	Global.register_rod(keyword_appease)
	
	var keyword_repair: KeywordData = KeywordData.new("keyword_repair")
	keyword_repair.keyword_name = "repair"
	keyword_repair.keyword_text_bb_code = "Increases a Craft card's durability by 1 (Does not affect cards with exhaust)."
	Global.register_rod(keyword_repair)
	
	var keyword_rattle: KeywordData = KeywordData.new("keyword_rattle")
	keyword_rattle.keyword_name = "rattle"
	keyword_rattle.keyword_text_bb_code = "Decreases a Faction card's influence by 1."
	Global.register_rod(keyword_rattle)
	
	var keyword_corrosion: KeywordData = KeywordData.new("keyword_corrosion")
	keyword_corrosion.keyword_name = "Corrosion"
	keyword_corrosion.keyword_status_effect_id = "status_effect_corrosion"
	keyword_corrosion.keyword_text_bb_code = "Deals damage each turn "
	Global.register_rod(keyword_corrosion)
	
	var keyword_fish_reward: KeywordData = KeywordData.new("keyword_fish_reward")
	keyword_fish_reward.keyword_name = "fish_reward"
	keyword_fish_reward.keyword_status_effect_id = "status_effect_fish_reward"
	keyword_fish_reward.keyword_text_bb_code = "Grants Fish"
	Global.register_rod(keyword_fish_reward)
	
	var keyword_bomb: KeywordData = KeywordData.new("keyword_bomb")
	keyword_bomb.keyword_name = "Bomb"
	keyword_bomb.keyword_text_bb_code = "Deals damage to all enemies when timer runs out "
	Global.register_rod(keyword_bomb)
	
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
	character_green.character_starting_artifact_ids = ["artifact_fertiliser", "artifact_check_scroll"]
	character_green.character_starting_artifact_pack_ids = ["artifact_pack_white", "artifact_pack_{0}".format([character_color])]
	character_green.character_starting_consumable_pack_ids = ["consumable_pack_white", "consumable_pack_{0}".format([character_color])]
	character_green.character_starting_card_object_ids = [
		"card_basic_ore_green", "card_basic_ore_green", "card_basic_explore_green", "card_basic_explore_green",
		"card_basic_ore_green", "card_basic_ore_green", "card_basic_explore_green", "card_basic_explore_green",
		"card_basic_explore_green", "card_basic_explore_green"
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
	#### Downsides
	# lose all money
	var run_start_option_lose_money: RunStartOptionData = RunStartOptionData.new("run_start_option_lose_money")
	run_start_option_lose_money.run_start_option_bb_code = "[color=red]Lose 5 money[/color]"
	run_start_option_lose_money.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_lose_money.run_start_option_actions = [{Scripts.ACTION_ADD_MONEY: {"money_amount": -5}}]
#
	Global.register_rod(run_start_option_lose_money)

	# lose all food
	var run_start_option_lose_food: RunStartOptionData = RunStartOptionData.new("run_start_option_lose_food")
	run_start_option_lose_food.run_start_option_bb_code = "[color=red]Lose 5 food[/color]"
	run_start_option_lose_food.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_lose_food.run_start_option_actions = [{Scripts.ACTION_ADD_FOOD: {"food_amount": -5}}]
#
	Global.register_rod(run_start_option_lose_food)
	
	# lose all ore
	var run_start_option_lose_ore: RunStartOptionData = RunStartOptionData.new("run_start_option_lose_ore")
	run_start_option_lose_ore.run_start_option_bb_code = "[color=red]Lose 3 ore[/color]"
	run_start_option_lose_ore.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_DOWNSIDE
	run_start_option_lose_ore.run_start_option_actions = [{Scripts.ACTION_ADD_ORE: {"ore_amount": -3}}]
#
	Global.register_rod(run_start_option_lose_ore)
	
	var run_start_option_add_ore: RunStartOptionData = RunStartOptionData.new("run_start_option_add_ore")
	run_start_option_add_ore.run_start_option_bb_code = "[color=green]Gain 5 ore[/color]"
	run_start_option_add_ore.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_add_ore.run_start_option_actions = [{Scripts.ACTION_ADD_ORE: {"ore_amount": 5}}]

	Global.register_rod(run_start_option_add_ore)
	
	### Upsides
	# add money
	var run_start_option_add_money: RunStartOptionData = RunStartOptionData.new("run_start_option_add_money")
	run_start_option_add_money.run_start_option_bb_code = "[color=green]Gain 10 money[/color]"
	run_start_option_add_money.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	run_start_option_add_money.run_start_option_actions = [{Scripts.ACTION_ADD_MONEY: {"money_amount": 10}}]

	Global.register_rod(run_start_option_add_money)
	
	## draft a card from player's pool
	## functions identically to a standard draft
	#var run_start_option_draft_card: RunStartOptionData = RunStartOptionData.new("run_start_option_draft_card")
	#run_start_option_draft_card.run_start_option_bb_code = "[color=green]Draft a card[/color]"
	#run_start_option_draft_card.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	#run_start_option_draft_card.run_start_option_actions = [
		#{
		#Scripts.ACTION_PICK_CARDS: {
			#"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			#"pick_draft_cards": false,
			#"draft_from_card_pool": true,
			#"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			## use same rng as player drafting so it counts as draft
			#"rng_name": "rng_card_drafting",
			#"validator_data": [], # this should always be empty if draft_use_player_draft = true
			## weighted draft from player draft pool with pity system
			#"draft_use_player_draft": true,
			#"draft_is_weighted": false,
			#"draft_use_pity_system": false,
			#}
		#}
	#]
	#
	#Global.register_rod(run_start_option_draft_card)
	
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
	
	#Global.register_rod(run_start_option_draft_common_card)
	#
	## gain a random common artifact
	#var run_start_option_gain_common_artifact: RunStartOptionData = RunStartOptionData.new("run_start_option_gain_common_artifact")
	#run_start_option_gain_common_artifact.run_start_option_bb_code = "[color=green]Gain Random Common Artifact[/color]"
	#run_start_option_gain_common_artifact.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	#run_start_option_gain_common_artifact.run_start_option_actions = [{Scripts.ACTION_ADD_ARTIFACTS_FROM_POOL:
		#{
		#"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
		#"artifact_count": 1,
		#"artifact_rarities": [ArtifactData.ARTIFACT_RARITIES.COMMON]
		#}
		#}]
	#
	#Global.register_rod(run_start_option_gain_common_artifact)
	
	## draft a colorless card from the white card pack
	#var run_start_option_draft_colorless_card: RunStartOptionData = RunStartOptionData.new("run_start_option_draft_colorless_card")
	#run_start_option_draft_colorless_card.run_start_option_bb_code = "[color=green]Draft a colorless card[/color]"
	#run_start_option_draft_colorless_card.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.PARTIAL_UPSIDE
	#run_start_option_draft_colorless_card.run_start_option_actions = [
		#{
		#Scripts.ACTION_PICK_CARDS: {
			#"card_pick_type": ActionBasePickCards.PICK_DRAFT,
			#"pick_draft_cards": false,
			#"draft_from_card_pool": true,
			#"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DECK: {}}],
			#"validator_data": [],
			## use same rng as player drafting so it counts as draft
			#"rng_name": "rng_card_drafting",
			## get white cards
			#"draft_card_pack_id": "card_pack_white"
			#}
		#}
	#]
	#
	#Global.register_rod(run_start_option_draft_colorless_card)
	#
	### Complete
	#
	## replace starting artifact with a random boss one
	#var run_start_option_artifact_swap: RunStartOptionData = RunStartOptionData.new("run_start_option_artifact_swap")
	#run_start_option_artifact_swap.run_start_option_bb_code = "[color=green]Replace Starting Artifact With Boss Artifact[/color]"
	#run_start_option_artifact_swap.run_start_option_type = RunStartOptionData.RUN_START_OPTION_TYPES.COMPLETE
	#run_start_option_artifact_swap.run_start_option_actions = [{Scripts.ACTION_SWAP_BOSS_ARTIFACT: {}}]
	#
	#Global.register_rod(run_start_option_artifact_swap)
	
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
	
	var basic_states: Array[EnemyIntentData] = [
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	]
	
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
	EnemyIntentData.new("intrtent_attack_2", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 2, "", 0, "", {"intent_attack_1": 1, "intent_attack_2": 1}),
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
	field_patch.enemy_initial_status_effects = {"status_effect_grain_reward": 2,"status_effect_fertiliser_reward":2}
	# initial dummy state used to map initial attack pattern weights on starting combat
	field_patch.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	field_patch.enemy_actions_on_death = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser","artifact_charge_increase":2}},{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	field_patch.add_intent_state(basic_states)
		
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
	mound.enemy_initial_status_effects = {"status_effect_grain_reward": 1,"status_effect_fertiliser_reward":2, "status_effect_size_reward": 2}
	mound.enemy_texture_path = "external/sprites/enemies/hills.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	mound.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	mound.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 2}},{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser","artifact_charge_increase":2}}]
	# an attack that hits harder on higher difficulties
	mound.add_intent_state(basic_states)
		
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
	rock.enemy_initial_status_effects = {"status_effect_rock_reward": 2}
	rock.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	rock.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_rock",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}}]
	# an attack that hits harder on higher difficulties
	rock.add_intent_state(basic_states)
		
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
	pond.enemy_initial_status_effects = {"status_effect_fish_reward": 2}
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
	
		# enemy that negates the first damage instance against it
	var animalherd: EnemyData = EnemyData.new("animalherd")
	animalherd.enemy_name = "animalherd"
	animalherd.add_health_bounds(15, 17)
	animalherd.add_health_bounds(19, 21, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	animalherd.enemy_texture_path = "external/sprites/enemies/herd.png"
	animalherd.enemy_initial_status_effects = {"status_effect_room_reward": 2,"status_effect_fertiliser_reward":5}
	# initial dummy state used to map initial attack pattern weights on starting combat
	animalherd.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	animalherd.enemy_actions_on_death = [{Scripts.ACTION_ADD_ROOM:{"room_amount": 2}},{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser","artifact_charge_increase":5}}]
	# an attack that hits harder on higher difficulties
	animalherd.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
	
		
	var _animalherd_anim: AnimationData = animalherd.add_standard_animations(
		["external/sprites/enemies/herd.png"]
	)

	Global.register_rod(animalherd)
	Global.register_rod(_animalherd_anim)
	
			# enemy that negates the first damage instance against it
	var chargedvista: EnemyData = EnemyData.new("chargedvista")
	chargedvista.enemy_name = "Charged Vista"
	chargedvista.add_health_bounds(30, 37)
	chargedvista.add_health_bounds(49, 52, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	chargedvista.enemy_texture_path = "external/sprites/enemies/chargedvista.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	chargedvista.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	chargedvista.enemy_initial_status_effects = {"status_effect_size_reward": 5,"status_effect_room_reward": 2}
	chargedvista.enemy_actions_on_death = [{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 5}},{Scripts.ACTION_ADD_ROOM:{"room_amount": 2}}]
	# an attack that hits harder on higher difficulties
	chargedvista.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _chargedvista_anim: AnimationData = chargedvista.add_standard_animations(
		["external/sprites/enemies/chargedvista.png"]
	)

	Global.register_rod(chargedvista)
	Global.register_rod(_chargedvista_anim)
#endregion

#region enemies desert
	# enemy that negates the first damage instance against it
	var boulder: EnemyData = EnemyData.new("boulder")
	boulder.enemy_name = "Boulder"
	boulder.add_health_bounds(7, 9)
	boulder.add_health_bounds(11, 13, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	boulder.enemy_texture_path = "external/sprites/enemies/rock.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	boulder.enemy_initial_status_effects = {"status_effect_rock_reward": 2,"status_effect_size_reward": 2}
	boulder.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	boulder.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_rock",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 2}}]
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
	var wateringhole: EnemyData = EnemyData.new("wateringhole")
	wateringhole.enemy_name = "Watering Hole"
	wateringhole.add_health_bounds(7, 9)
	wateringhole.add_health_bounds(11, 13, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	wateringhole.enemy_texture_path = "external/sprites/enemies/wateringhole.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	wateringhole.enemy_initial_status_effects = {"status_effect_fertiliser_reward": 2,"status_effect_refresh_reward": 3}
	wateringhole.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	wateringhole.enemy_actions_on_death = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_charge_increase":2}},{Scripts.ACTION_ADD_REFRESH:{"refresh_amount":-3}}]
	# an attack that hits harder on higher difficulties
	wateringhole.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _wateringhole_anim: AnimationData = wateringhole.add_standard_animations(
		["external/sprites/enemies/rock.png"]
	)
	Global.register_rod(wateringhole)
	Global.register_rod(_wateringhole_anim)
	
	# enemy that negates the first damage instance against it
	var bigboulder: EnemyData = EnemyData.new("bigboulder")
	bigboulder.enemy_name = "Big Boulder"
	bigboulder.add_health_bounds(22, 25)
	bigboulder.add_health_bounds(24, 29, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
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
	bigboulder.enemy_initial_status_effects = {"status_effect_rock_reward": 4}
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
	
	# enemy that negates the first damage instance against it
	var barrenwastes: EnemyData = EnemyData.new("barrenwastes")
	barrenwastes.enemy_name = "Barren Wastes"
	barrenwastes.add_health_bounds(9, 11)
	barrenwastes.add_health_bounds(14, 19, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	barrenwastes.enemy_texture_path = "external/sprites/enemies/wastes.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	barrenwastes.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	barrenwastes.enemy_initial_status_effects = {"status_effect_insight_reward": 1,"status_effect_room_reward":1}
	barrenwastes.enemy_actions_on_death = [{Scripts.ACTION_ADD_INSIGHT:{"insight_amount": 1}},{Scripts.ACTION_ADD_ROOM:{"room_amount": 1}}]
	# an attack that hits harder on higher difficulties
	barrenwastes.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _barrenwastes_anim: AnimationData = barrenwastes.add_standard_animations(
		["external/sprites/enemies/wastes.png"]
	)
	Global.register_rod(barrenwastes)
	Global.register_rod(_barrenwastes_anim)
	
	# enemy that negates the first damage instance against it
	var islandanomaly: EnemyData = EnemyData.new("islandanomaly")
	islandanomaly.enemy_name = "Island Anomaly"
	islandanomaly.add_health_bounds(30, 42)
	islandanomaly.add_health_bounds(44, 49, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	islandanomaly.enemy_texture_path = "external/sprites/enemies/island.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	islandanomaly.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	islandanomaly.enemy_initial_status_effects = {"status_effect_insight_reward": 5}
	islandanomaly.enemy_actions_on_death = [{Scripts.ACTION_ADD_INSIGHT:{"insight_amount": 5}}]
	# an attack that hits harder on higher difficulties
	islandanomaly.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _islandanomaly_anim: AnimationData = islandanomaly.add_standard_animations(
		["external/sprites/enemies/island.png"]
	)
	Global.register_rod(islandanomaly)
	Global.register_rod(_islandanomaly_anim)
#endregion

#region enemies coast
	# enemy that negates the first damage instance against it
	var shore: EnemyData = EnemyData.new("shore")
	shore.enemy_name = "Shore"
	shore.add_health_bounds(5, 7)
	shore.add_health_bounds(12, 14, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	shore.enemy_texture_path = "external/sprites/enemies/fish-escape.png"
	shore.enemy_initial_status_effects = {"status_effect_fish_reward": 2}
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
	var rockface: EnemyData = EnemyData.new("rockface")
	rockface.enemy_name = "rockface"
	rockface.add_health_bounds(8, 11)
	rockface.add_health_bounds(12, 14, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	rockface.enemy_texture_path = "external/sprites/enemies/stone-pile.png"
	rockface.enemy_initial_status_effects = {"status_effect_refresh_reward": 2,"status_effect_insight_reward": 1}
	# initial dummy state used to map initial attack pattern weights on starting combat
	rockface.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	rockface.enemy_actions_on_death = [{Scripts.ACTION_ADD_REFRESH:{"refresh_amount":-2}},{Scripts.ACTION_ADD_INSIGHT:{"insight_amount": 1}}]
	# an attack that hits harder on higher difficulties
	rockface.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _rockface_anim: AnimationData = rockface.add_standard_animations(
		["external/sprites/enemies/stone-pile.png"]
	)
	
	Global.register_rod(_rockface_anim)
	Global.register_rod(rockface)

	# enemy that negates the first damage instance against it
	var cave: EnemyData = EnemyData.new("cave")
	cave.enemy_name = "Cave"
	cave.add_health_bounds(25, 32)
	cave.add_health_bounds(35, 40, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	cave.enemy_texture_path = "external/sprites/enemies/cave-entrance.png"
	cave.enemy_initial_status_effects = {"status_effect_treasure_reward": 3, "status_effect_size_reward": 5}
	# initial dummy state used to map initial attack pattern weights on starting combat
	cave.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	cave.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_treasure",
		"number_of_cards":3,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 5}}]
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
	sandbed.enemy_initial_status_effects = {"status_effect_treasure_reward": 2}
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
	var forestmulch: EnemyData = EnemyData.new("forestmulch")
	forestmulch.enemy_name = "Forest Mulch"
	forestmulch.add_health_bounds(5, 9)
	forestmulch.add_health_bounds(9, 11, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	forestmulch.enemy_texture_path = "external/sprites/enemies/forestmulch.png"
	forestmulch.enemy_initial_status_effects = {"status_effect_fertiliser_reward": 5}
	# initial dummy state used to map initial attack pattern weights on starting combat
	forestmulch.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	forestmulch.enemy_actions_on_death = [{	Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_charge_increase":5,"artifact_id":"artifact_fertiliser"}}]
	# an attack that hits harder on higher difficulties
	forestmulch.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _forestmulch_anim: AnimationData = forestmulch.add_standard_animations(
		["external/sprites/enemies/forestmulch.png"]
	)

	Global.register_rod(forestmulch)
	Global.register_rod(_forestmulch_anim)
	
	# enemy that negates the first damage instance against it
	var forestfloor: EnemyData = EnemyData.new("forestfloor")
	forestfloor.enemy_name = "Forest Floor"
	forestfloor.add_health_bounds(12, 15)
	forestfloor.add_health_bounds(17, 19, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	forestfloor.enemy_texture_path = "external/sprites/enemies/forest.png"
	forestfloor.enemy_initial_status_effects = {"status_effect_size_reward": 2, "status_effect_room_reward": 1}
	# initial dummy state used to map initial attack pattern weights on starting combat
	forestfloor.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	forestfloor.enemy_actions_on_death = [{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 2}},{Scripts.ACTION_ADD_ROOM:{"room_amount": 1}}]
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
	den.enemy_initial_status_effects = {"status_effect_treasure_reward": 3, "status_effect_size_reward": 5}
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
			}},
			]
		}
	}]
	
	den.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	den.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_treasure",
		"number_of_cards":3,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 5}}]
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
	hideout.enemy_initial_status_effects = {"status_effect_spice_reward": 2,"status_effect_size_reward": 4}
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
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE: {"size_amount": 4}}]
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
	dryfield.enemy_initial_status_effects = {"status_effect_grain_reward": 1, "status_effect_size_reward": 2}
	dryfield.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_grain",
		"number_of_cards":1,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE: {"size_amount": 3}}]
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
	var mangroveroots: EnemyData = EnemyData.new("mangroveroots")
	mangroveroots.enemy_name = "Mangrove Roots"
	mangroveroots.add_health_bounds(8, 15)
	mangroveroots.add_health_bounds(15, 20, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	mangroveroots.enemy_texture_path = "external/sprites/enemies/agave.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	mangroveroots.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	mangroveroots.enemy_initial_status_effects = {"status_effect_delicacy_reward": 1, "status_effect_size_reward": 1}
	mangroveroots.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_delicacy",
		"number_of_cards":1,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 1}}]
	# an attack that hits harder on higher difficulties
	mangroveroots.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _mangroveroots_anim: AnimationData = mangroveroots.add_standard_animations(
		["external/sprites/enemies/agave.png"]
	)

	Global.register_rod(mangroveroots)
	Global.register_rod(_mangroveroots_anim)
	
	# enemy that negates the first damage instance against it
	var brackishbeds: EnemyData = EnemyData.new("brackishbeds")
	brackishbeds.enemy_name = "Brackish Beds"
	brackishbeds.add_health_bounds(14, 19)
	brackishbeds.add_health_bounds(21, 24, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	brackishbeds.enemy_texture_path = "external/sprites/enemies/brackish.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	brackishbeds.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	brackishbeds.enemy_initial_status_effects = {"status_effect_size_reward": 6}
	brackishbeds.enemy_actions_on_death = [{Scripts.ACTION_ADD_KINGDOM_SIZE:{"size_amount": 6}}]
	# an attack that hits harder on higher difficulties
	brackishbeds.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _brackishbeds_anim: AnimationData = brackishbeds.add_standard_animations(
		["external/sprites/enemies/brackish.png"]
	)

	Global.register_rod(brackishbeds)
	Global.register_rod(_brackishbeds_anim)
	
		# enemy that negates the first damage instance against it
	var infestedwaters: EnemyData = EnemyData.new("infestedwaters")
	infestedwaters.enemy_name = "Infested Waters"
	infestedwaters.add_health_bounds(7, 11)
	infestedwaters.add_health_bounds(11, 14, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	infestedwaters.enemy_texture_path = "external/sprites/enemies/infested.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	infestedwaters.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	infestedwaters.enemy_actions_on_death = [{Scripts.ACTION_ADD_INSIGHT:{"insight_amount": 2}}]
	infestedwaters.enemy_initial_status_effects = {"status_effect_insight_reward": 2}
	# an attack that hits harder on higher difficulties
	infestedwaters.add_intent_state([
		EnemyIntentData.new("intent_block", DIFFICULTY_STARTING, 0, 0, "", 0, ""),
		EnemyIntentData.new("intent_block", DIFFICULTY_STANDARD_ENEMIES_HARDER, 0, 0, "", 0, "", {"intent_block":1}),
	])
		
	var _infestedwaters_anim: AnimationData = infestedwaters.add_standard_animations(
		["external/sprites/enemies/infested.png"]
	)

	Global.register_rod(infestedwaters)
	Global.register_rod(_infestedwaters_anim)
	
		# enemy that negates the first damage instance against it
	var hut: EnemyData = EnemyData.new("hut")
	hut.enemy_name = "Hut"
	hut.add_health_bounds(20, 27)
	hut.add_health_bounds(23, 31, DIFFICULTY_STANDARD_ENEMIES_HARDER) # gets more health on later difficulty
	hut.enemy_texture_path = "external/sprites/enemies/hut.png"
	# initial dummy state used to map initial attack pattern weights on starting combat
	hut.add_intent_state([
		EnemyIntentData.new(EnemyIntentData.INTENT_INITIAL, DIFFICULTY_STARTING, 0, 0, "", 0, "", {"intent_block":1}),
		])
	hut.enemy_initial_status_effects = {"status_effect_spice_reward": 2, "status_effect_room_reward": 2}
	hut.enemy_actions_on_death = [{	Scripts.ACTION_CREATE_CARDS: {
		"created_card_object_id": "card_spice",
		"number_of_cards":2,
		"action_data": [{Scripts.ACTION_DISCARD_CARDS: {}}]
		}},{Scripts.ACTION_ADD_ROOM: {"room_amount": 2}}]
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
		card_basic_food.card_play_actions.append(influence_action)
		card_basic_food.card_end_of_turn_actions = end_action_data
		
		Global.register_rod(card_basic_food)
		
		# Basic block card
		var card_basic_ore: CardData = CardData.new("card_basic_ore_{0}".format([colors[i]]))
		card_basic_ore.card_name = "Basic Ore"
		card_basic_ore.card_color_id = "color_{0}".format([colors[i]])
		card_basic_ore.card_description = "Gain [ore_amount]{0}".format([Card.ORE_ICON_KEYWORD])
		card_basic_ore.card_texture_path = "external/sprites/cards/basic/06_tradingnovice.png"
		card_basic_ore.texture_bg_path = "external/sprites/cards/frames/basicframe.png"
		card_basic_ore.card_type = CardData.CARD_TYPES.SKILL
		card_basic_ore.card_rarity = CardData.CARD_RARITIES.BASIC
		card_basic_ore.card_requires_target = false
		card_basic_ore.card_keyword_object_ids = ["keyword_ore"]
		card_basic_ore.card_values = {"ore_amount": 1}
		card_basic_ore.card_upgrade_value_improvements = {"ore_amount": 1}
		card_basic_ore.card_play_actions = [{
		Scripts.ACTION_ADD_ORE: {}
		}]
		card_basic_ore.card_play_actions.append(influence_action)
		card_basic_ore.card_end_of_turn_actions = end_action_data
		Global.register_rod(card_basic_ore)
		
				# Basic attack card
		var card_basic_explore: CardData = CardData.new("card_basic_explore_{0}".format([colors[i]]))
		card_basic_explore.card_name = "Basic Explore"
		card_basic_explore.card_color_id = "color_{0}".format([colors[i]])
		card_basic_explore.card_description = "Explore [damage]{0}".format([Card.EXPLORE_ICON_KEYWORD])
		card_basic_explore.card_texture_path = "external/sprites/cards/basic/07_sailingnovice.png"
		card_basic_explore.card_type = CardData.CARD_TYPES.ATTACK
		card_basic_explore.card_requires_target = true
		card_basic_explore.card_rarity = CardData.CARD_RARITIES.BASIC
		card_basic_explore.card_keyword_object_ids = []
		card_basic_explore.card_values = {"damage": 2,"number_of_attacks":1}
		card_basic_explore.card_upgrade_value_improvements = {"damage": 1}
		#card_basic_explore.card_keyword_object_ids = ["keyword_explore"]
		card_basic_explore.card_play_actions = [{
		Scripts.ACTION_ATTACK_GENERATOR: {},
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/slash.wav"},
		}]
		card_basic_explore.card_play_actions.append(influence_action)
		card_basic_explore.card_end_of_turn_actions = end_action_data
		Global.register_rod(card_basic_explore)

#region generated
## Adds cards that have not yet been sorted into a color
func add_cards_misc() -> void:
	var color: String = "white"
	# energy_next_turn
	var card_fish: CardData = CardData.new("card_fish")
	card_fish.card_name = "Fish"
	card_fish.card_color_id = "color_{0}".format([color])
	card_fish.card_texture_path = "external/sprites/status_effects/fish.svg"
	card_fish.card_description = "Gain [food_amount]{0}. Improve by 2{0} when retained.".format([Card.FOOD_ICON_KEYWORD])
	card_fish.card_type = CardData.CARD_TYPES.SKILL
	card_fish.card_energy_cost = 0
	card_fish.card_influence = 0
	card_fish.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_fish.card_requires_target = false
	card_fish.card_play_destination = HandManager.EXHAUST_PILE
	card_fish.card_values = {"food_amount": 2, "card_value_improvements": {"food_amount": 2}}
	card_fish.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD:
			{
			}
		}
		]
	card_fish.card_retain_actions = [
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
	card_grain.card_texture_path = "external/sprites/status_effects/grain.svg"
	card_grain.card_description = "Gain [food_amount]{0}. Can be fertilised.".format([Card.FOOD_ICON_KEYWORD])
	card_grain.card_type = CardData.CARD_TYPES.SKILL
	card_grain.card_energy_cost = 0
	card_grain.card_durability = 0
	card_grain.card_influence = 0
	card_grain.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_grain.card_requires_target = false
	card_grain.card_play_destination = HandManager.EXHAUST_PILE
	card_grain.card_values = {"food_amount": 0, "card_value_improvements": {"food_amount": 1}}
	card_grain.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD:
			{
			}
		}
		]

	Global.register_rod(card_grain)

	var card_rock: CardData = CardData.new("card_rock")
	card_rock.card_name = "Rock"
	card_rock.card_color_id = "color_{0}".format([color])
	card_rock.card_texture_path = "external/sprites/status_effects/rock.svg"
	card_rock.card_description = "Gain [ore_amount]{0}. Can be Inspected.".format([Card.ORE_ICON_KEYWORD])
	card_rock.card_keyword_object_ids = ["keyword_inspect"]
	card_rock.card_type = CardData.CARD_TYPES.SKILL
	card_rock.card_energy_cost = 0
	card_rock.card_durability = 0
	card_rock.card_influence = 0
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
	
	var card_scroll: CardData = CardData.new("card_scroll")
	card_scroll.card_name = "Scroll"
	card_scroll.card_color_id = "color_{0}".format([color])
	card_scroll.card_texture_path = "external/sprites/status_effects/insight.svg"
	card_scroll.card_description = "Draw a card. For every 3rd Scroll played, draft a Book."
	card_scroll.card_type = CardData.CARD_TYPES.SKILL
	card_scroll.card_energy_cost = 0
	card_scroll.card_influence = 0
	card_scroll.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_scroll.card_requires_target = true
	card_scroll.card_play_destination = HandManager.EXHAUST_PILE
	card_scroll.card_values = {"draw_count": 1}
	card_scroll.card_play_actions = [
		{
			Scripts.ACTION_DRAW_GENERATOR:
			{
			}
		}
		]
	Global.register_rod(card_scroll)
	
	var card_delicacy: CardData = CardData.new("card_delicacy")
	card_delicacy.card_name = "Delicacy"
	card_delicacy.card_color_id = "color_{0}".format([color])
	card_delicacy.card_texture_path = "external/sprites/status_effects/delicacy.svg"
	card_delicacy.card_description = "Draw [draw_count], then gain [energy_amount]{0}.".format([Card.ENERGY_ICON_KEYWORD])
	card_delicacy.card_type = CardData.CARD_TYPES.SKILL
	card_delicacy.card_energy_cost = 0
	card_delicacy.card_influence = 2
	card_delicacy.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_delicacy.card_requires_target = false
	card_delicacy.card_values = {"draw_count": 1,"energy_amount":1}
	card_delicacy.card_play_actions = [
		{
			Scripts.ACTION_ADD_ENERGY:{}
		},
		{
			Scripts.ACTION_DRAW_GENERATOR:{}
		}
		]
	for action in durability_action_data:
		card_delicacy.card_play_actions.append(action)
	Global.register_rod(card_delicacy)
	
	
	var card_sword: CardData = CardData.new("card_sword")
	card_sword.card_name = "Sword"
	card_sword.card_color_id = "color_{0}".format([color])
	card_sword.card_texture_path = "external/sprites/status_effects/sword.svg"
	card_sword.card_description = "Explore [damage]{0}. Can be Wielded.".format([Card.EXPLORE_ICON_KEYWORD])
	card_sword.card_type = CardData.CARD_TYPES.ATTACK
	card_sword.card_keyword_object_ids = ["keyword_wield"]
	card_sword.card_energy_cost = 0
	card_sword.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_sword.card_influence = 2
	card_sword.card_requires_target = true
	card_sword.card_values = {"damage": 2, "number_of_attacks": 1, "card_influence": -1}
	card_sword.card_play_actions = [
		{
			Scripts.ACTION_ATTACK_GENERATOR:
			{
				"time_delay": 0.0, "actions_on_lethal": []
			}
		}
		]
	for action in durability_action_data:
		card_sword.card_play_actions.append(action)
	Global.register_rod(card_sword)
	
	var card_treasure: CardData = CardData.new("card_treasure")
	card_treasure.card_name = "Treasure"
	card_treasure.card_color_id = "color_{0}".format([color])
	card_treasure.card_texture_path = "external/sprites/status_effects/treasure.svg"
	card_treasure.card_description = "Gain [money_amount]{0}. Can be Inspected.".format([Card.MONEY_ICON_KEYWORD])
	card_treasure.card_keyword_object_ids = ["keyword_inspect"]
	card_treasure.card_type = CardData.CARD_TYPES.SKILL
	card_treasure.card_energy_cost = 0
	card_treasure.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_treasure.card_influence = 2
	card_treasure.card_requires_target = false
	card_treasure.card_values = {"money_amount": 1, "card_influence": -1}
	card_treasure.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY:
			{
			}}
		]
		
	for action in durability_action_data:
		card_treasure.card_play_actions.append(action)
	Global.register_rod(card_treasure)
		
	var card_spice: CardData = CardData.new("card_spice")
	card_spice.card_name = "Spice"
	card_spice.card_color_id = "color_{0}".format([color])
	card_spice.card_texture_path = "external/sprites/status_effects/spice.svg"
	card_spice.card_description = "Appease all cards in hand."
	card_spice.card_keyword_object_ids = ["keyword_appease"]
	card_spice.card_type = CardData.CARD_TYPES.SKILL
	card_spice.card_energy_cost = 0
	card_spice.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_spice.card_influence = 2
	card_spice.card_requires_target = false
	card_spice.card_values = {}
	card_spice.card_discard_actions = [
		{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"pick_played_card": true,
				"modify_parent_card": false,
			}
		}
		]
	card_spice.card_play_actions = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_card_amount": 99,
		"max_card_amount": 99,
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.HAND_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
				"card_influence": 1
			}},
			]
		}
	}]
	for action in durability_action_data:
		card_spice.card_play_actions.append(action)
	Global.register_rod(card_spice)
	
	var card_debt: CardData = CardData.new("card_debt")
	card_debt.card_name = "debt"
	card_debt.card_color_id = "color_{0}".format([color])
	card_debt.card_texture_path = "external/sprites/cards/basic/cash.png"
	card_debt.card_description = "Unplayable. Lose 1{0} at the end of turn.".format([Card.MONEY_ICON_KEYWORD])
	card_debt.card_type = CardData.CARD_TYPES.SKILL
	card_debt.card_energy_cost = 0
	card_debt.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_debt.card_influence = 2
	card_debt.card_requires_target = false
	card_debt.card_is_playable = false
	for action in durability_action_data:
		card_debt.card_end_of_turn_actions.append(action)
	card_debt.card_end_of_turn_actions.append({Scripts.ACTION_ADD_MONEY:{"money_amount":-1}})
	Global.register_rod(card_debt)


	var card_rebel: CardData = CardData.new("card_rebel")
	card_rebel.card_name = "Rebel"
	card_rebel.card_color_id = "color_{0}".format([color])
	card_rebel.card_texture_path = "external/sprites/cards/basic/05_battlenovice.png"
	card_rebel.card_description = "Lose [food_amount]{0}.".format([Card.FOOD_ICON_KEYWORD])
	card_rebel.card_type = CardData.CARD_TYPES.SKILL
	card_rebel.card_energy_cost = 0
	card_rebel.card_influence = 0
	card_rebel.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_rebel.card_requires_target = false
	card_rebel.card_is_playable = false
	card_rebel.card_values = {"food_amount": -1}
	card_rebel.card_end_of_turn_actions = [
		{
			Scripts.ACTION_ADD_FOOD:
		{
		}}]
	
	Global.register_rod(card_rebel)
	
	var card_blueprint: CardData = CardData.new("card_blueprint")
	card_blueprint.card_name = "Blueprint"
	card_blueprint.card_color_id = "color_{0}".format([color])
	card_blueprint.card_texture_path = "external/sprites/cards/basic/blueprint.svg"
	card_blueprint.card_description = "Spend 8{0} to gain [artifact_id].".format([Card.ORE_ICON_KEYWORD])
	card_blueprint.card_type = CardData.CARD_TYPES.SKILL
	card_blueprint.card_energy_cost = 0
	card_blueprint.card_influence = 0
	card_blueprint.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_blueprint.card_play_destination = HandManager.EXHAUST_PILE
	card_blueprint.card_requires_target = false
	card_blueprint.card_values = {"ore_amount": -8,"artifact_id":""}
	card_blueprint.card_play_validators = [{Scripts.VALIDATOR_ORE:{"ore_required":8}},{Scripts.VALIDATOR_ROOM:{"room_amount":1}}]
	card_blueprint.card_play_actions = [
			{Scripts.ACTION_ADD_ORE:{"ore_amount":-8}},
			{Scripts.ACTION_ADD_ARTIFACT:{
					"target_override": BaseAction.TARGET_OVERRIDES.PLAYER,
			}},{Scripts.ACTION_ADD_ROOM:{"room_amount":-1}}
		]
	
	Global.register_rod(card_blueprint)
	
	var card_draft: CardData = CardData.new("card_draft")
	card_draft.card_name = "Draft"
	card_draft.card_color_id = "color_{0}".format([color])
	card_draft.card_texture_path = "external/sprites/cards/basic/draft.svg"
	card_draft.card_description = "Spend 3 Insight to gain [card_object_id]."
	card_draft.card_type = CardData.CARD_TYPES.SKILL
	card_draft.card_energy_cost = 0
	card_draft.card_influence = 0
	card_draft.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_draft.card_play_destination = HandManager.EXHAUST_PILE
	card_draft.card_requires_target = false
	card_draft.card_values = {"card_object_id":""}
	card_draft.card_play_actions = [
		{
			Scripts.ACTION_VALIDATOR:
			{
				"validator_data":[{Scripts.VALIDATOR_INSIGHT:{"insight_required":3}}],
				"action_data":[{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":-3}},
				{
				Scripts.ACTION_CREATE_CARDS:
				{
					"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
				}
				}]
			}
		}]
	
	Global.register_rod(card_draft)
#endregion

func add_cards_trade() -> void:
#region Trade
	var color: String = "grey"
	var card_trade1: CardData = CardData.new("card_trade1")
	card_trade1.card_name = "Trade1"
	card_trade1.card_color_id = "color_{0}".format([color])
	card_trade1.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade1.card_description = "[ore_amount]{0}. Gain [money_amount]{1}.".format([Card.ORE_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_trade1.card_type = CardData.CARD_TYPES.SKILL
	card_trade1.card_energy_cost = 0
	card_trade1.card_influence = 0
	card_trade1.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade1.card_requires_target = false
	card_trade1.card_play_destination = HandManager.EXHAUST_PILE
	card_trade1.card_values = {"ore_amount": randi_range(-2, -3),"money_amount":randi_range(4, 6)}
	card_trade1.card_play_validators = [{Scripts.VALIDATOR_ORE:{"ore_required":abs(card_trade1.card_values["ore_amount"])}}]
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
	card_trade2.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade2.card_description = "[food_amount]{0}. Gain [money_amount]{1}.".format([Card.FOOD_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_trade2.card_type = CardData.CARD_TYPES.SKILL
	card_trade2.card_energy_cost = 0
	card_trade2.card_influence = 0
	card_trade2.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade2.card_requires_target = false
	card_trade2.card_play_destination = HandManager.EXHAUST_PILE
	card_trade2.card_values = {"food_amount": randi_range(-4, -8),"money_amount":randi_range(9, 12)}
	card_trade2.card_play_validators = [{Scripts.VALIDATOR_FOOD:{"food_required":abs(card_trade2.card_values["food_amount"])}}]
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
	card_trade3.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade3.card_description = "[insight_amount]{0}. Gain [money_amount]{1}.".format([Card.INSIGHT_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_trade3.card_type = CardData.CARD_TYPES.SKILL
	card_trade3.card_energy_cost = 0
	card_trade3.card_influence = 0
	card_trade3.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade3.card_requires_target = false
	card_trade3.card_play_destination = HandManager.EXHAUST_PILE
	card_trade3.card_values = {"insight_amount": randi_range(-2, -3),"money_amount":randi_range(9, 15)}
	card_trade3.card_play_validators = [{Scripts.VALIDATOR_INSIGHT:{"insight_required":abs(card_trade3.card_values["insight_amount"])}}]
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
	
	var card_trade4: CardData = CardData.new("card_trade4")
	card_trade4.card_name = "Trade4"
	card_trade4.card_color_id = "color_{0}".format([color])
	card_trade4.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade4.card_description = "[money_amount]{0}. Gain [ore_amount]{1}.".format([Card.MONEY_ICON_KEYWORD,Card.ORE_ICON_KEYWORD])
	card_trade4.card_type = CardData.CARD_TYPES.SKILL
	card_trade4.card_energy_cost = 0
	card_trade4.card_influence = 0
	card_trade4.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade4.card_requires_target = false
	card_trade4.card_play_destination = HandManager.EXHAUST_PILE
	card_trade4.card_values = {"ore_amount": randi_range(4, 6),"money_amount":randi_range(-4, -6)}
	card_trade4.card_play_validators = [{Scripts.VALIDATOR_MONEY:{"money_required":abs(card_trade4.card_values["money_amount"])}}]
	card_trade4.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY:
			{
			}
		},
		{
			Scripts.ACTION_ADD_ORE:
			{
			}
		}]
	Global.register_rod(card_trade4)
	
	var card_trade5: CardData = CardData.new("card_trade5")
	card_trade5.card_name = "Trade5"
	card_trade5.card_color_id = "color_{0}".format([color])
	card_trade5.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade5.card_description = "[money_amount]{0}. Gain [food_amount]{1}.".format([Card.MONEY_ICON_KEYWORD,Card.FOOD_ICON_KEYWORD])
	card_trade5.card_type = CardData.CARD_TYPES.SKILL
	card_trade5.card_energy_cost = 0
	card_trade5.card_influence = 0
	card_trade5.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade5.card_requires_target = false
	card_trade5.card_play_destination = HandManager.EXHAUST_PILE
	card_trade5.card_values = {"food_amount": randi_range(4, 8),"money_amount":randi_range(-4, -6)}
	card_trade5.card_play_validators = [{Scripts.VALIDATOR_MONEY:{"money_required":abs(card_trade5.card_values["money_amount"])}}]
	card_trade5.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY:
				{
				}
		},
		{
			Scripts.ACTION_ADD_FOOD:
			{
			}
		}]
	Global.register_rod(card_trade5)
	
	var card_trade6: CardData = CardData.new("card_trade6")
	card_trade6.card_name = "Trade6"
	card_trade6.card_color_id = "color_{0}".format([color])
	card_trade6.card_texture_path = "external/sprites/cards/basic/01_trade.png"
	card_trade6.card_description = "[money_amount]{0}. Gain [insight_amount]{1}.".format([Card.MONEY_ICON_KEYWORD,Card.INSIGHT_ICON_KEYWORD])
	card_trade6.card_type = CardData.CARD_TYPES.SKILL
	card_trade6.card_energy_cost = 0
	card_trade6.card_influence = 0
	card_trade6.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_trade6.card_requires_target = false
	card_trade6.card_play_destination = HandManager.EXHAUST_PILE
	card_trade6.card_values = {"insight_amount": randi_range(1, 3),"money_amount":randi_range(-9, -15)}
	card_trade6.card_play_validators = [{Scripts.VALIDATOR_MONEY:{"money_required":abs(card_trade6.card_values["money_amount"])}}]
	card_trade6.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY:
			{
			}
		},
		{
			Scripts.ACTION_ADD_ORE:
			{
			}
		}]
	Global.register_rod(card_trade6)
	
	var card_rejuvenating_tome: CardData = CardData.new("card_rejuvenating_tome")
	card_rejuvenating_tome.card_name = "Rejuvenating Tome"
	card_rejuvenating_tome.card_color_id = "color_blue"
	card_rejuvenating_tome.card_texture_path = "external/sprites/status_effects/book.svg"
	card_rejuvenating_tome.card_description = "Draw [draw_count], gain [energy_amount]{0}.".format([Card.ENERGY_ICON_KEYWORD])
	card_rejuvenating_tome.card_type = CardData.CARD_TYPES.SKILL
	card_rejuvenating_tome.card_energy_cost = 0
	card_rejuvenating_tome.card_influence = 0
	card_rejuvenating_tome.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_rejuvenating_tome.card_requires_target = false
	card_rejuvenating_tome.card_values = {"draw_count":2, "energy_amount":2}
	card_rejuvenating_tome.card_play_actions = [
			{Scripts.ACTION_ADD_ENERGY:{}},
			{Scripts.ACTION_DRAW_GENERATOR:{}}]
	Global.register_rod(card_rejuvenating_tome)
	
	var card_food_manual: CardData = CardData.new("card_food_manual")
	card_food_manual.card_name = "Food Manual"
	card_food_manual.card_color_id = "color_blue"
	card_food_manual.card_texture_path = "external/sprites/status_effects/book.svg"
	card_food_manual.card_description = "Improve {0} value of Rice and Fish in draw pile by 1.".format([Card.FOOD_ICON_KEYWORD])
	card_food_manual.card_type = CardData.CARD_TYPES.SKILL
	card_food_manual.card_energy_cost = 0
	card_food_manual.card_influence = 0
	card_food_manual.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_food_manual.card_requires_target = false
	card_food_manual.card_values = {"status_charge_amount": 1}
	card_food_manual.card_play_actions = [{
		Scripts.ACTION_PICK_CARDS:
				{
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DRAW_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_fish","card_grain"]}}],
				"action_data": [		{
				Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"time_delay": 0.1,
				"modify_parent_card": false,
				}
		}]
		}
		}]
	Global.register_rod(card_food_manual)
	
	var card_preservation_pamphlet: CardData = CardData.new("card_preservation_pamphlet")
	card_preservation_pamphlet.card_name = "Preservation Pamphlet"
	card_preservation_pamphlet.card_color_id = "color_blue"
	card_preservation_pamphlet.card_texture_path = "external/sprites/status_effects/book.svg"
	card_preservation_pamphlet.card_description = "Discard up to 5 cards from hand, then retain your hand for the turn."
	card_preservation_pamphlet.card_keyword_object_ids = ["keyword_retain"]
	card_preservation_pamphlet.card_type = CardData.CARD_TYPES.SKILL
	card_preservation_pamphlet.card_energy_cost = 0
	card_preservation_pamphlet.card_influence = 0
	card_preservation_pamphlet.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_preservation_pamphlet.card_requires_target = false
	card_preservation_pamphlet.card_values = {"status_charge_amount": 1}
	card_preservation_pamphlet.card_play_actions = [{Scripts.ACTION_PICK_CARDS:
		{
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.HAND_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"action_data": [		{
				Scripts.ACTION_RETAIN_CARDS:{}
		}]
		}},{
		Scripts.ACTION_PICK_CARDS:
				{
				"min_card_amount": 0,
				"max_card_amount": 5,
				"min_cards_are_required_for_action": false,
				"random_selection": false,
				"card_pick_type": HandManager.HAND_PILE,
				"card_pick_text": "Choose {0} card to discard. {1} cards selected",
				"action_data": [		{
				Scripts.ACTION_DISCARD_CARDS: {
				}
		}]
		}
		}]
	Global.register_rod(card_preservation_pamphlet)
	
	var card_exploration_tome: CardData = CardData.new("card_exploration_tome")
	card_exploration_tome.card_name = "Exploration Tome"
	card_exploration_tome.card_color_id = "color_blue"
	card_exploration_tome.card_texture_path = "external/sprites/status_effects/book.svg"
	card_exploration_tome.card_description = "Increases all {0} values by [status_charge_amount] for the turn.".format([Card.EXPLORE_ICON_KEYWORD])
	card_exploration_tome.card_type = CardData.CARD_TYPES.SKILL
	card_exploration_tome.card_influence = 0
	card_exploration_tome.card_energy_cost = 0
	card_exploration_tome.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_exploration_tome.card_requires_target = false
	card_exploration_tome.card_values = {"status_charge_amount":2}
	card_exploration_tome.card_play_actions = [
		{
			Scripts.ACTION_APPLY_STATUS:
			{
				"status_effect_object_id": "status_effect_temp_damage_increase",
				"target_override": BaseAction.TARGET_OVERRIDES.PLAYER
			}
		}]
	Global.register_rod(card_exploration_tome)
#endregion
func add_cards_purple() -> void:
	var color: String = "purple"

	#region Pearl
	
	var card_cunningtrader: CardData = CardData.new("card_cunningtrader")
	card_cunningtrader.card_name = "Cunning Trader"
	card_cunningtrader.card_color_id = "color_{0}".format([color])
	card_cunningtrader.card_texture_path = "external/sprites/cards/pearl/02_cunningtrader.png"
	card_cunningtrader.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_cunningtrader.card_description = "Gains [ore_amount]{0}. Create 1 Debt.".format([Card.ORE_ICON_KEYWORD])
	card_cunningtrader.card_keyword_object_ids = ["keyword_debt"]
	card_cunningtrader.card_type = CardData.CARD_TYPES.SKILL
	card_cunningtrader.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cunningtrader.card_requires_target = false
	card_cunningtrader.card_energy_cost = 1
	card_cunningtrader.card_values = {"ore_amount": 2,"created_card_object_id": "card_debt", "number_of_cards": 1}
	card_cunningtrader.card_upgrade_value_improvements = {"ore_amount": 1}
	card_cunningtrader.card_influence = 3
	card_cunningtrader.card_play_actions = [
		{
			Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]		
			},
			Scripts.ACTION_ADD_ORE:
				{
					
				}
		}]
	card_cunningtrader.card_play_actions.append(influence_action)
	card_cunningtrader.card_end_of_turn_actions = end_action_data
	
	Global.register_rod(card_cunningtrader)
	
	var card_pearlemissary: CardData = CardData.new("card_pearlemissary")
	card_pearlemissary.card_name = "Pearl Emissary"
	card_pearlemissary.card_color_id = "color_{0}".format([color])
	card_pearlemissary.card_texture_path = "external/sprites/cards/pearl/01_pearlemissary.png"
	card_pearlemissary.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlemissary.card_description = "Draws [draw_count]. When discarded, randomly Appease 2 cards in discard pile."
	card_pearlemissary.card_keyword_object_ids = ["keyword_appease"]
	card_pearlemissary.card_type = CardData.CARD_TYPES.SKILL
	card_pearlemissary.card_rarity = CardData.CARD_RARITIES.COMMON
	card_pearlemissary.card_requires_target = false
	card_pearlemissary.card_energy_cost = 1
	card_pearlemissary.card_values = {"card_influence": 1,"draw_count": 2}
	card_pearlemissary.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlemissary.card_influence = 3
	card_pearlemissary.card_play_actions = [
		{
		Scripts.ACTION_DRAW_GENERATOR: {},
		}]
	card_pearlemissary.card_play_actions.append(influence_action)
	card_pearlemissary.card_end_of_turn_actions = end_action_data

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
	card_joyfulsailor.card_description = "Explore [damage]{0}, Draw [draw_count], Create a Fish in discard pile.".format([Card.EXPLORE_ICON_KEYWORD])
	card_joyfulsailor.card_type = CardData.CARD_TYPES.ATTACK
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
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
			}
		}
	]
	card_joyfulsailor.card_play_actions.append(influence_action)
	card_joyfulsailor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_joyfulsailor)
	
	var card_saltexpert: CardData = CardData.new("card_saltexpert")
	card_saltexpert.card_name = "Salt Expert"
	card_saltexpert.card_color_id = "color_{0}".format([color])
	#card_saltexpert.card_texture_path = "external/sprites/cards/pearl/03_saltexpert.png"
	card_saltexpert.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_saltexpert.card_description = "Retain up to [max_card_amount] cards in hand. Appease 2 to retained cards."
	card_saltexpert.card_type = CardData.CARD_TYPES.SKILL
	card_saltexpert.card_rarity = CardData.CARD_RARITIES.COMMON
	card_saltexpert.card_requires_target = false
	card_saltexpert.card_energy_cost = 1
	card_saltexpert.card_values = {"min_card_amount":1, "max_card_amount": 2}
	card_saltexpert.card_upgrade_value_improvements = {"max_card_amount": 1}
	card_saltexpert.card_influence = 3
	card_saltexpert.card_play_actions = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_cards_are_required_for_action": true,
		"random_selection": false,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to retain. {1} cards selected",
		"action_data": [
			{Scripts.ACTION_RETAIN_CARDS:{}},
			{
				Scripts.ACTION_VALIDATOR:{
					"validator_data":[{Scripts.VALIDATOR_CARD_RARITY:{"card_rarities_exclude":[CardData.CARD_RARITIES.GENERATED]}}],
					"passed_action_data":[{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{"card_influence":2}}]
				}
			}]
		}
	}]
	card_saltexpert.card_play_actions.append(influence_action)
	card_saltexpert.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_saltexpert)
	
	var card_minnowtrader: CardData = CardData.new("card_minnowtrader")
	card_minnowtrader.card_name = "Minnow Trader"
	card_minnowtrader.card_color_id = "color_{0}".format([color])
	#card_minnowtrader.card_texture_path = "external/sprites/cards/pearl/03_minnowtrader.png"
	card_minnowtrader.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_minnowtrader.card_description = "Tick down Shop Refresh by [refresh_amount]. Return up to [max_card_amount] card from discard pile to your hand."
	card_minnowtrader.card_type = CardData.CARD_TYPES.SKILL
	card_minnowtrader.card_rarity = CardData.CARD_RARITIES.COMMON
	card_minnowtrader.card_requires_target = false
	card_minnowtrader.card_energy_cost = 1
	card_minnowtrader.card_values = {"min_card_amount":0, "max_card_amount": 1, "refresh_amount": -2}
	card_minnowtrader.card_upgrade_value_improvements = {"refresh_amount": 1}
	card_minnowtrader.card_influence = 3
	card_minnowtrader.card_play_actions = [
		{Scripts.ACTION_ADD_REFRESH:{}},{
		Scripts.ACTION_PICK_CARDS: {
		"min_cards_are_required_for_action": true,
		"random_selection": false,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to return to hand. {1} cards selected",
		"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
		}
	}]
	card_minnowtrader.card_play_actions.append(influence_action)
	card_minnowtrader.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_minnowtrader)
	

	var card_storiedspinner: CardData = CardData.new("card_storiedspinner")
	card_storiedspinner.card_name = "Storied Spinner"
	card_storiedspinner.card_color_id = "color_{0}".format([color])
	card_storiedspinner.card_texture_path = "external/sprites/cards/pearl/04_storiedspinner.png"
	card_storiedspinner.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_storiedspinner.card_description = "Draw [draw_count], Explore [damage]{0}.".format([Card.EXPLORE_ICON_KEYWORD])
	card_storiedspinner.card_type = CardData.CARD_TYPES.ATTACK
	card_storiedspinner.card_rarity = CardData.CARD_RARITIES.COMMON
	card_storiedspinner.card_requires_target = true
	card_storiedspinner.card_energy_cost = 1
	card_storiedspinner.card_values = {"draw_count": 1,"damage": 2,"number_of_attacks": 1}
	card_storiedspinner.card_upgrade_value_improvements = {"draw_count": 1}
	card_storiedspinner.card_influence = 3
	card_storiedspinner.card_play_actions = [
		{
		Scripts.ACTION_DRAW_GENERATOR: {},
		},
		{
		Scripts.ACTION_ATTACK_GENERATOR:
			{
				
			}
		}
		]
	card_storiedspinner.card_play_actions.append(influence_action)
	card_storiedspinner.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_storiedspinner)
	
	var card_recklessenvoy: CardData = CardData.new("card_recklessenvoy")
	card_recklessenvoy.card_name = "Reckless Envoy"
	card_recklessenvoy.card_color_id = "color_{0}".format([color])
	card_recklessenvoy.card_texture_path = "external/sprites/cards/pearl/05_recklessenvoy.png"
	card_recklessenvoy.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_recklessenvoy.card_description = "Explore [damage]{0}, then Forge 1 Sword.".format([Card.EXPLORE_ICON_KEYWORD])
	card_recklessenvoy.card_keyword_object_ids = ["keyword_forge","keyword_sword"]
	card_recklessenvoy.card_type = CardData.CARD_TYPES.ATTACK
	card_recklessenvoy.card_rarity = CardData.CARD_RARITIES.COMMON
	card_recklessenvoy.card_requires_target = true
	card_recklessenvoy.card_energy_cost = 1
	card_recklessenvoy.card_values = {"damage": 3, "number_of_attacks":1, "ore_required":1, "ore_amount":-1, "created_card_object_id": "card_sword",  "number_of_cards": 1}
	card_recklessenvoy.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_recklessenvoy.card_influence = 3
	card_recklessenvoy.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR:
			{
				"time_delay": 0.0, "actions_on_lethal": []
			},
		},
	]
	card_recklessenvoy.card_play_actions.append(forge_action)
	card_recklessenvoy.card_play_actions.append(influence_action)
	card_recklessenvoy.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_recklessenvoy)
	
	var card_pearldiplomat: CardData = CardData.new("card_pearldiplomat")
	card_pearldiplomat.card_name = "Pearl Diplomat"
	card_pearldiplomat.card_color_id = "color_{0}".format([color])
	card_pearldiplomat.card_texture_path = "external/sprites/cards/pearl/06_pearldiplomat.png"
	card_pearldiplomat.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearldiplomat.card_description = "Create [number_of_cards] Spice. Appease [max_card_amount] Cards in discard pile."
	card_pearldiplomat.card_keyword_object_ids = ["keyword_spice","keyword_appease"]
	card_pearldiplomat.card_type = CardData.CARD_TYPES.SKILL
	card_pearldiplomat.card_rarity = CardData.CARD_RARITIES.COMMON
	card_pearldiplomat.card_requires_target = false
	card_pearldiplomat.card_energy_cost = 3
	card_pearldiplomat.card_values = {"card_influence": 1,"created_card_object_id": "card_spice",  "min_card_amount": 2,"max_card_amount":2}
	card_pearldiplomat.card_upgrade_value_improvements = {"min_card_amount": 1,"max_card_amount":1}
	card_pearldiplomat.card_influence = 5
	card_pearldiplomat.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS: {
		"min_cards_are_required_for_action": false,
		"random_selection": true,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to discard. {1} cards selected",
		"validator_data": [
			{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}
		],
		"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence": 1
			}},
			]
		}
		},
		{
			Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}
		}
	]
	card_pearldiplomat.card_play_actions.append(influence_action)
	card_pearldiplomat.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_pearldiplomat)
	
	var card_pearlregaler: CardData = CardData.new("card_pearlregaler")
	card_pearlregaler.card_name = "Pearl Regaler"
	card_pearlregaler.card_color_id = "color_{0}".format([color])
	card_pearlregaler.card_texture_path = "external/sprites/cards/pearl/07_pearlregalerpng"
	card_pearlregaler.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlregaler.card_description = "Weave [insight_required] Scroll(s). Return up to 1 card to your hand."
	card_pearlregaler.card_keyword_object_ids = ["keyword_weave","keyword_scroll"]
	card_pearlregaler.card_type = CardData.CARD_TYPES.SKILL
	card_pearlregaler.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlregaler.card_requires_target = false
	card_pearlregaler.card_energy_cost = 1
	card_pearlregaler.card_values = {"created_card_object_id":"card_scroll","number_of_cards":1,"insight_amount":-1,"insight_required":1}
	card_pearlregaler.card_upgrade_value_improvements = {"number_of_cards": 2,"insight_amount":-1,"insight_required":1}
	card_pearlregaler.card_influence = 3
	card_pearlregaler.card_play_actions = [
				{
		Scripts.ACTION_PICK_CARDS:
			{
			"min_card_amount": 0,
			"max_card_amount": 1,
			"min_cards_are_required_for_action": true,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to return to hand. {1} card selected",
			"action_data": [
			{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}
			]
			}
		}
	]
	card_pearlregaler.card_play_actions.append(weave_action)
	card_pearlregaler.card_play_actions.append(influence_action)
	card_pearlregaler.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_pearlregaler)
	
		
	var card_fishsaucemaker: CardData = CardData.new("card_fishsaucemaker")
	card_fishsaucemaker.card_name = "Fish Sauce Maker"
	card_fishsaucemaker.card_color_id = "color_{0}".format([color])
	#card_fishsaucemaker.card_texture_path = "external/sprites/cards/pearl/03_fishsaucemaker.png"
	card_fishsaucemaker.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_fishsaucemaker.card_description = "Exhaust a Fish card in discard pile to Fertilise [artifact_charge_increase] and create a Delicacy."
	card_fishsaucemaker.card_keyword_object_ids = ["keyword_fertilise","keyword_delicacy"]
	card_fishsaucemaker.card_type = CardData.CARD_TYPES.SKILL
	card_fishsaucemaker.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_fishsaucemaker.card_requires_target = false
	card_fishsaucemaker.card_energy_cost = 1
	card_fishsaucemaker.card_values = {"min_card_amount":1,"max_card_amount": 1,"created_card_object_id":"card_delicacy","number_of_cards":1,"artifact_charge_increase":3}
	card_fishsaucemaker.card_upgrade_value_improvements = {"artifact_charge_increase":2}
	card_fishsaucemaker.card_influence = 3
	card_fishsaucemaker.card_play_actions = [{
		Scripts.ACTION_PICK_CARDS: {
		"min_cards_are_required_for_action": true,
		"random_selection": false,
		"card_pick_type": HandManager.DISCARD_PILE,
		"card_pick_text": "Choose {0} card to retain. {1} cards selected",
		"validator_data":[{Scripts.VALIDATOR_CARD_ID:{"card_object_ids":["card_fish"]}}],
		"action_data": [
			{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}},
			{Scripts.ACTION_EXHAUST_CARDS:{}},
			{Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}}]
		}
	}]
	card_fishsaucemaker.card_play_actions.append(influence_action)
	card_fishsaucemaker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_fishsaucemaker)
	
		
	var card_flintlockaccountant: CardData = CardData.new("card_flintlockaccountant")
	card_flintlockaccountant.card_name = "Flintlock Accountant"
	card_flintlockaccountant.card_color_id = "color_{0}".format([color])
	card_flintlockaccountant.card_texture_path = "external/sprites/cards/pearl/08_flintlockaccountant.png"
	card_flintlockaccountant.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_flintlockaccountant.card_description = "Return up to [max_card_amount] Crafts from your discard pile to your hand. Increase 3 durability to selected cards."
	card_flintlockaccountant.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockaccountant.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_flintlockaccountant.card_requires_target = false
	card_flintlockaccountant.card_energy_cost = 2
	card_flintlockaccountant.card_values = {"max_card_amount": 2}
	card_flintlockaccountant.card_upgrade_value_improvements = {"max_card_amount": 1}
	card_flintlockaccountant.card_influence = 4
	card_flintlockaccountant.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
			{
			"min_card_amount": 1,
			"min_cards_are_required_for_action": true,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to return to hand. {1} cards selected",
			"validator_data": [
			{Scripts.VALIDATOR_CARD_TYPE: {"card_types": [CardData.CARD_RARITIES.GENERATED]}}
			],
			"action_data": [
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence": 3
			}},
			{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}
			]
			}
		}
	]
	card_flintlockaccountant.card_play_actions.append(influence_action)
	card_flintlockaccountant.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_flintlockaccountant)
	
	var card_pearlscribe: CardData = CardData.new("card_pearlscribe")
	card_pearlscribe.card_name = "Pearl Scribe"
	card_pearlscribe.card_color_id = "color_{0}".format([color])
	card_pearlscribe.card_texture_path = "external/sprites/cards/pearl/09_pearlscribe"
	card_pearlscribe.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlscribe.card_description = "If you have draw pile 20 or more, gain [insight_amount]{0}. Weave 1 Scroll.".format([Card.INSIGHT_ICON_KEYWORD])
	card_pearlscribe.card_keyword_object_ids = ["keyword_weave","keyword_scroll"]
	card_pearlscribe.card_type = CardData.CARD_TYPES.SKILL
	card_pearlscribe.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlscribe.card_requires_target = false
	card_pearlscribe.card_energy_cost = 1
	card_pearlscribe.card_values = {"card_influence": 1, "insight_amount": 2,"created_card_object_id":"card_scroll","number_of_cards":1}
	card_pearlscribe.card_upgrade_value_improvements = {"insight_amount": 1}
	card_pearlscribe.card_influence = 3
	var adjust_weave_action: Dictionary = weave_action
	adjust_weave_action["insight_amount"] = -1
	adjust_weave_action["insight_required"] = 1
	card_pearlscribe.card_play_actions.append(adjust_weave_action)
	card_pearlscribe.card_play_actions.append({
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
		})
	card_pearlscribe.card_play_actions.append(influence_action)
	card_pearlscribe.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_pearlscribe)
	
	var card_pearlsmuggler: CardData = CardData.new("card_pearlsmuggler")
	card_pearlsmuggler.card_name = "Pearl Smuggler"
	card_pearlsmuggler.card_color_id = "color_{0}".format([color])
	card_pearlsmuggler.card_texture_path = "external/sprites/cards/pearl/10_pearlsmuggler.png"
	card_pearlsmuggler.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlsmuggler.card_description = "Draw [draw_count], discard 2. Wield [max_card_amount]."
	card_pearldiplomat.card_keyword_object_ids = ["keyword_wield"]
	card_pearlsmuggler.card_type = CardData.CARD_TYPES.SKILL
	card_pearlsmuggler.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlsmuggler.card_requires_target = false
	card_pearlsmuggler.card_energy_cost = 2
	card_pearlsmuggler.card_values = {"draw_count": 2, "min_card_amount":4,"max_card_amount":4}
	card_pearlsmuggler.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlsmuggler.card_influence = 4
	
	card_pearlsmuggler.card_play_actions.append(wield_action)
	var this_action_data: Array[Dictionary] = [
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
		Scripts.ACTION_DRAW_GENERATOR:{}
		},
		]
	for action in this_action_data:
		card_pearlsmuggler.card_play_actions.append(action)
	card_pearlsmuggler.card_play_actions.append(influence_action)
	card_pearlsmuggler.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_pearlsmuggler)
	
	var card_pearlseer: CardData = CardData.new("card_pearlseer")
	card_pearlseer.card_name = "Pearl Seer"
	card_pearlseer.card_color_id = "color_{0}".format([color])
	card_pearlseer.card_texture_path = "external/sprites/cards/pearl/11_pearlseer.png"
	card_pearlseer.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_pearlseer.card_description = "Draw [draw_count], then gain [money_amount]{0} for each generated card in hand.".format([Card.MONEY_ICON_KEYWORD])
	card_pearlseer.card_type = CardData.CARD_TYPES.SKILL
	card_pearlseer.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_pearlseer.card_requires_target = false
	card_pearlseer.card_energy_cost = 3
	card_pearlseer.card_values = {"draw_count": 2, "money_amount": 1}
	card_pearlseer.card_upgrade_value_improvements = {"draw_count": 1}
	card_pearlseer.card_influence = 5
	card_pearlseer.card_play_actions = [
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
	card_pearlseer.card_play_actions.append(influence_action)
	card_pearlseer.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_pearlseer)
	
	var card_mastertactician: CardData = CardData.new("card_mastertactician")
	card_mastertactician.card_name = "Master Tactician"
	card_mastertactician.card_color_id = "color_{0}".format([color])
	card_mastertactician.card_texture_path = "external/sprites/cards/pearl/12_mastertactician.png"
	card_mastertactician.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_mastertactician.card_description = "Forge [number_of_cards] Swords. Wield [min_card_amount]."
	card_mastertactician.card_keyword_object_ids = ["keyword_forge","keyword_sword","keyword_wield"]
	card_mastertactician.card_type = CardData.CARD_TYPES.SKILL
	card_mastertactician.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_mastertactician.card_requires_target = false
	card_mastertactician.card_energy_cost = 2
	card_mastertactician.card_values = {"created_card_object_id": "card_sword", "ore_required":1, "ore_amount":-1, "number_of_cards": 2,	"min_card_amount": 4,
		"max_card_amount": 4,}
	card_mastertactician.card_upgrade_value_improvements = {"number_of_cards":1, "min_card_amount": 2,
		"max_card_amount": 2,"ore_required":1, "ore_amount":-1}
	card_mastertactician.card_influence = 4
	card_mastertactician.card_play_actions.append(wield_action)
	card_mastertactician.card_play_actions.append(forge_action)
	card_mastertactician.card_play_actions.append(influence_action)
	card_mastertactician.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_mastertactician)
	
	var card_schemingplanner: CardData = CardData.new("card_schemingplanner")
	card_schemingplanner.card_name = "Scheming Planner"
	card_schemingplanner.card_color_id = "color_{0}".format([color])
	card_schemingplanner.card_texture_path = "external/sprites/cards/pearl/13_schemingplanner.png"
	card_schemingplanner.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_schemingplanner.card_description = "Gain [money_amount]{0}. Create 2 Debt. Tick down Shop Refresh by 3.".format([Card.MONEY_ICON_KEYWORD])
	card_schemingplanner.card_keyword_object_ids = ["keyword_debt"]
	card_schemingplanner.card_type = CardData.CARD_TYPES.SKILL
	card_schemingplanner.card_rarity = CardData.CARD_RARITIES.RARE
	card_schemingplanner.card_requires_target = false
	card_schemingplanner.card_energy_cost = 2
	card_schemingplanner.card_values = {"money_amount": 8,"refresh_amount":-3, "created_card_object_id": "card_debt","number_of_cards":2}
	card_schemingplanner.card_upgrade_value_improvements = {"money_amount": 2}
	card_schemingplanner.card_influence = 4
	card_schemingplanner.card_play_actions = [
		{
			Scripts.ACTION_CREATE_CARDS:{
				"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
			}
		},
		{
		Scripts.ACTION_ADD_REFRESH:{}},
		{
		Scripts.ACTION_ADD_MONEY: {
		}
		}
	]
	card_schemingplanner.card_play_actions.append(influence_action)
	card_schemingplanner.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_schemingplanner)
	
	var card_courthand: CardData = CardData.new("card_courthand")
	card_courthand.card_name = "Court Hand"
	card_courthand.card_color_id = "color_{0}".format([color])
	card_courthand.card_texture_path = "external/sprites/cards/pearl/14_courthand.png"
	card_courthand.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_courthand.card_description = "Create [number_of_cards] Spice."
	card_courthand.card_keyword_object_ids = ["keyword_spice"]
	card_courthand.card_type = CardData.CARD_TYPES.SKILL
	card_courthand.card_rarity = CardData.CARD_RARITIES.RARE
	card_courthand.card_requires_target = false
	card_courthand.card_energy_cost = 2
	card_courthand.card_values = {"created_card_object_id": "card_spice", "number_of_cards": 2}
	card_courthand.card_upgrade_value_improvements = {"number_of_cards":1}
	card_courthand.card_influence = 4
	card_courthand.card_play_actions = [
		{
		Scripts.ACTION_CREATE_CARDS:
			{
				"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
			}
		}
	]
	card_courthand.card_play_actions.append(influence_action)
	card_courthand.card_end_of_turn_actions = end_action_data
	
	Global.register_rod(card_courthand)
	
	var card_wizenedcommander: CardData = CardData.new("card_wizenedcommander")
	card_wizenedcommander.card_name = "Court Hand"
	card_wizenedcommander.card_color_id = "color_{0}".format([color])
	card_wizenedcommander.card_texture_path = "external/sprites/cards/pearl/15_wizenedcommander.png"
	card_wizenedcommander.texture_bg_path = "external/sprites/cards/frames/pearlframe.png"
	card_wizenedcommander.card_description = "Explore 1{0} for each generated card in your discard pile.".format([Card.EXPLORE_ICON_KEYWORD])
	card_wizenedcommander.card_type = CardData.CARD_TYPES.ATTACK
	card_wizenedcommander.card_rarity = CardData.CARD_RARITIES.RARE
	card_wizenedcommander.card_requires_target = true
	card_wizenedcommander.card_energy_cost = 1
	card_wizenedcommander.card_values = {"card_influence": 1, "damage": 1}
	card_wizenedcommander.card_upgrade_value_improvements = {"number_of_cards":1}
	card_wizenedcommander.card_influence = 3
	card_wizenedcommander.card_play_actions = [
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
					"time_delay": 0.1
					}}]}
			}]
		}}
	]
	card_wizenedcommander.card_play_actions.append(influence_action)
	card_wizenedcommander.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_wizenedcommander)
	
#endregion

	#region Generated Cards
	var card_performance: CardData = CardData.new("card_performance")
	card_performance.card_name = "Performance"
	card_performance.card_color_id = "color_{0}".format([color])
	card_performance.card_texture_path = "external/sprites/cards/{0}/card_{0}.png".format([color])
	card_performance.card_description = "Appeases all cards in discard pile."
	card_performance.card_keyword_object_ids = ["keyword_appease"]
	card_performance.card_type = CardData.CARD_TYPES.SKILL
	card_performance.card_rarity = CardData.CARD_RARITIES.GENERATED
	card_performance.card_requires_target = false
	card_performance.card_energy_cost = 1
	card_performance.card_values = {"card_influence": 1}
	card_performance.card_upgrade_value_improvements = {"card_influence": 1}
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
	card_aniseedemissary.card_name = "Aniseed Emissary"
	card_aniseedemissary.card_color_id = "color_{0}".format([color])
	card_aniseedemissary.card_texture_path = "external/sprites/cards/aniseed/01_aniseedemissary.png"
	card_aniseedemissary.card_description = "Explore [damage]{0}. Inspect [min_card_amount].".format([Card.EXPLORE_ICON_KEYWORD])
	card_aniseedemissary.card_keyword_object_ids = ["keyword_inspect"]
	card_aniseedemissary.card_type = CardData.CARD_TYPES.ATTACK
	card_aniseedemissary.card_rarity = CardData.CARD_RARITIES.COMMON
	card_aniseedemissary.card_requires_target = true
	card_aniseedemissary.card_energy_cost = 1
	card_aniseedemissary.card_values = {"damage": 2, "min_card_amount": 1, "max_card_amount": 1}
	card_aniseedemissary.card_upgrade_value_improvements = {"min_card_amount": 1,"max_card_amount": 1}
	card_aniseedemissary.card_influence = 3
	card_aniseedemissary.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedemissary.card_play_actions.append(inspect_action)
	card_aniseedemissary.card_play_actions.append(
		{
			Scripts.ACTION_ATTACK_GENERATOR:{}
		}
	)
	card_aniseedemissary.card_play_actions.append(influence_action)
	card_aniseedemissary.card_end_of_turn_actions = end_action_data

	Global.register_rod(card_aniseedemissary)
		
	var card_eagersailor: CardData = CardData.new("card_eagersailor")
	card_eagersailor.card_name = "Eager Sailor"
	card_eagersailor.card_color_id = "color_{0}".format([color])
	card_eagersailor.card_texture_path = "external/sprites/cards/aniseed/02_eagersailor.png"
	card_eagersailor.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_eagersailor.card_description = "Explore [damage]{0}. If you've completed the expedition, gain [money_amount]{1}.".format([Card.EXPLORE_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_eagersailor.card_type = CardData.CARD_TYPES.ATTACK
	card_eagersailor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_eagersailor.card_requires_target = true
	card_eagersailor.card_energy_cost = 1
	card_eagersailor.card_values = {"damage": 3, "number_of_attacks": 1, "money_amount": 2}
	card_eagersailor.card_upgrade_value_improvements = {"damage": 1}
	card_eagersailor.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR: {"time_delay": 0.5,"actions_on_lethal":[{Scripts.ACTION_ADD_MONEY: {}}]},
		}]
	card_eagersailor.card_play_actions.append(influence_action)
	card_eagersailor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_eagersailor)

	var card_fishwrangler: CardData = CardData.new("card_fishwrangler")
	card_fishwrangler.card_name = "Fish Wrangler"
	card_fishwrangler.card_color_id = "color_{0}".format([color])
	card_fishwrangler.card_texture_path = "external/sprites/cards/aniseed/03_fishwrangler.png"
	card_fishwrangler.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_fishwrangler.card_description = "Explore [damage]{0}. Create [number_of_cards] Fish. Fertilise [artifact_charge_increase]".format([Card.EXPLORE_ICON_KEYWORD])
	card_fishwrangler.card_keyword_object_ids = ["keyword_fertilise"]
	card_fishwrangler.card_type = CardData.CARD_TYPES.ATTACK
	card_fishwrangler.card_rarity = CardData.CARD_RARITIES.COMMON
	card_fishwrangler.card_requires_target = true
	card_fishwrangler.card_energy_cost = 1
	card_fishwrangler.card_values = {"created_card_object_id": "card_fish","number_of_cards":1,  "number_of_attacks": 1, "damage": 2,"artifact_charge_increase":1}
	card_fishwrangler.card_upgrade_value_improvements = {"number_of_cards":1}
	card_fishwrangler.card_play_actions = [
		{
			Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}
		},
		{
			Scripts.ACTION_CREATE_CARDS: {"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}
		},
		{
			Scripts.ACTION_ATTACK_GENERATOR:{}
		}]
	card_fishwrangler.card_play_actions.append(influence_action)
	card_fishwrangler.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_fishwrangler)
	
	var card_spicepicker: CardData = CardData.new("card_spicepicker")
	card_spicepicker.card_name = "Spice Picker"
	card_spicepicker.card_color_id = "color_{0}".format([color])
	card_spicepicker.card_texture_path = "external/sprites/cards/aniseed/04_spicepicker.png"
	card_spicepicker.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_spicepicker.card_description = "Explore [damage]{0}. If you've completed the exploration, create [number_of_cards] Spice.".format([Card.EXPLORE_ICON_KEYWORD])
	card_spicepicker.card_keyword_object_ids = ["keyword_spice"]
	card_spicepicker.card_type = CardData.CARD_TYPES.ATTACK
	card_spicepicker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_spicepicker.card_requires_target = true
	card_spicepicker.card_energy_cost = 1
	card_spicepicker.card_values = {"damage": 2,"number_of_attacks": 1, "created_card_object_id": "card_spice",  "number_of_cards": 1}
	card_spicepicker.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_spicepicker.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR:{
			"actions_on_lethal":[{Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}}]
		}
		}]
	card_spicepicker.card_play_actions.append(influence_action)
	card_spicepicker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_spicepicker)
	
	var card_gardentender: CardData = CardData.new("card_gardentender")
	card_gardentender.card_name = "Garden Tender"
	card_gardentender.card_color_id = "color_{0}".format([color])
	#card_gardentender.card_texture_path = "external/sprites/cards/aniseed/04_gardentender.png"
	card_gardentender.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_gardentender.card_description = "Fertilise [artifact_charge_increase].".format([Card.EXPLORE_ICON_KEYWORD])
	card_gardentender.card_keyword_object_ids = ["keyword_fertilise"]
	card_gardentender.card_type = CardData.CARD_TYPES.SKILL
	card_gardentender.card_rarity = CardData.CARD_RARITIES.COMMON
	card_gardentender.card_requires_target = false
	card_gardentender.card_influence = 4
	card_gardentender.card_energy_cost = 2
	card_gardentender.card_values = {"artifact_charge_increase": 5}
	card_gardentender.card_upgrade_value_improvements = {"artifact_charge_increase":3}
	card_gardentender.card_play_actions = [
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}}]
	card_gardentender.card_play_actions.append(influence_action)
	card_gardentender.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_gardentender)
	
	var card_incensestoker: CardData = CardData.new("card_incensestoker")
	card_incensestoker.card_name = "Incense Stoker"
	card_incensestoker.card_color_id = "color_{0}".format([color])
	#card_incensestoker.card_texture_path = "external/sprites/cards/aniseed/04_incensestoker.png"
	card_incensestoker.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_incensestoker.card_description = "Discard [max_card_amount], gain [energy_amount]{0}.".format([Card.ENERGY_ICON_KEYWORD])
	#card_incensestoker.card_keyword_object_ids = ["keyword_fertilise"]
	card_incensestoker.card_type = CardData.CARD_TYPES.SKILL
	card_incensestoker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_incensestoker.card_requires_target = false
	card_incensestoker.card_influence = 4
	card_incensestoker.card_energy_cost = 2
	card_incensestoker.card_values = {"energy_amount": 3,"max_card_amount":1,"min_card_amount":1}
	card_incensestoker.card_upgrade_value_improvements = {"energy_amount": 1,"max_card_amount":1,"min_card_amount":1}
	card_incensestoker.card_play_actions = [
		{Scripts.ACTION_ADD_ENERGY:{}},
		{Scripts.ACTION_PICK_CARDS:{
			"min_cards_are_required_for_action": true,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} cards to discard. {1} cards selected",
			"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
	}}]
	card_incensestoker.card_play_actions.append(influence_action)
	card_incensestoker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_incensestoker)
	
	var card_reveredcraftsworker: CardData = CardData.new("card_reveredcraftsworker")
	card_reveredcraftsworker.card_name = "Revered Craftsworker"
	card_reveredcraftsworker.card_color_id = "color_{0}".format([color])
	card_reveredcraftsworker.card_texture_path = "external/sprites/cards/aniseed/05_reveredcraftsworker.png"
	card_reveredcraftsworker.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_reveredcraftsworker.card_description = "Forge [number_of_cards] Treasure. Inspect [min_card_amount]."
	card_reveredcraftsworker.card_keyword_object_ids = ["keyword_forge","keyword_treasure","keyword_inspect"]
	card_reveredcraftsworker.card_type = CardData.CARD_TYPES.SKILL
	card_reveredcraftsworker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_reveredcraftsworker.card_influence = 4
	card_reveredcraftsworker.card_requires_target = false
	card_reveredcraftsworker.card_energy_cost = 2
	card_reveredcraftsworker.card_values = {"ore_required":1, "ore_amount":-1,"created_card_object_id": "card_treasure",  "number_of_cards": 1,	"min_card_amount": 2,
				"max_card_amount": 2}
	card_reveredcraftsworker.card_upgrade_value_improvements = {"number_of_cards": 1,"min_card_amount":1,"max_card_amount":1}
	card_reveredcraftsworker.card_play_actions.append(inspect_action)
	card_reveredcraftsworker.card_play_actions.append(forge_action)
	card_reveredcraftsworker.card_play_actions.append(influence_action)
	card_reveredcraftsworker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_reveredcraftsworker)
	
	var card_cartographersassistant: CardData = CardData.new("card_cartographersassistant")
	card_cartographersassistant.card_name = "Cartographer's Assistant"
	card_cartographersassistant.card_color_id = "color_{0}".format([color])
	card_cartographersassistant.card_texture_path = "external/sprites/cards/aniseed/06_cartographersassistant.png"
	card_cartographersassistant.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_cartographersassistant.card_description = "Explore [damage]{0}. Consume [ore_required]{1} to gain [insight_amount]{2}.".format([Card.EXPLORE_ICON_KEYWORD,Card.ORE_ICON_KEYWORD,Card.INSIGHT_ICON_KEYWORD])
	card_cartographersassistant.card_type = CardData.CARD_TYPES.ATTACK
	card_cartographersassistant.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cartographersassistant.card_requires_target = true
	card_cartographersassistant.card_energy_cost = 1
	card_cartographersassistant.card_values = {"damage": 2,"number_of_attacks":1, "ore_required": 4 ,"ore_amount": -4, "insight_amount": 1}
	card_cartographersassistant.card_upgrade_value_improvements = {"damage": 1,"ore_required": -1, "ore_amount": 1}
	card_cartographersassistant.card_play_actions = [
		{
		Scripts.ACTION_ATTACK_GENERATOR: {
			"time_delay":0.5
		}
		},
		{
		Scripts.ACTION_VALIDATOR:{"validator_data":[{Scripts.VALIDATOR_ORE:{}}],
			"passed_action_data":[{Scripts.ACTION_ADD_ORE:{}},
			{Scripts.ACTION_ADD_INSIGHT:{"insight_amount":1}}]}
		}]
	card_cartographersassistant.card_play_actions.append(influence_action)
	card_cartographersassistant.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cartographersassistant)
	
	var card_flintlockmage: CardData = CardData.new("card_flintlockmage")
	card_flintlockmage.card_name = "Flintlock Mage"
	card_flintlockmage.card_color_id = "color_{0}".format([color])
	card_flintlockmage.card_texture_path = "external/sprites/cards/aniseed/07_flintlockmage.png"
	card_flintlockmage.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_flintlockmage.card_description = "Forge [number_of_cards] Sword. Draw [draw_count], then discard a card."
	card_flintlockmage.card_keyword_object_ids = ["keyword_forge","keyword_sword"]
	card_flintlockmage.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockmage.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_flintlockmage.card_requires_target = false
	card_flintlockmage.card_energy_cost = 1
	card_flintlockmage.card_values = {"ore_required":1, "ore_amount":-1,"created_card_object_id": "card_sword",  "number_of_cards": 1, "draw_count":1}
	card_flintlockmage.card_upgrade_value_improvements = {"ore_required":1, "ore_amount":-1,"draw_count": 1}
	card_flintlockmage.card_play_actions = [
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
		}},
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		]
	card_flintlockmage.card_play_actions.append(forge_action)
	card_flintlockmage.card_play_actions.append(influence_action)
	card_flintlockmage.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_flintlockmage)
	
	var card_aniseedscribe: CardData = CardData.new("card_aniseedscribe")
	card_aniseedscribe.card_name = "Aniseed Scribe"
	card_aniseedscribe.card_color_id = "color_{0}".format([color])
	card_aniseedscribe.card_texture_path = "external/sprites/cards/aniseed/08_aniseedscribe.png"
	card_aniseedscribe.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedscribe.card_description = "Draw [draw_count]. If discard pile is empty, gain [insight_amount]{0}.".format([Card.INSIGHT_ICON_KEYWORD])
	card_aniseedscribe.card_type = CardData.CARD_TYPES.SKILL
	card_aniseedscribe.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_aniseedscribe.card_requires_target = false
	card_aniseedscribe.card_energy_cost = 2
	card_aniseedscribe.card_values = {"draw_count":3,"insight_amount":1}
	card_aniseedscribe.card_upgrade_value_improvements = {"draw_count":2}
	card_aniseedscribe.card_play_actions = [
		{
		Scripts.ACTION_DRAW_GENERATOR: {}
		},
		{
		Scripts.ACTION_VALIDATOR:{
			"validator_data":[{Scripts.VALIDATOR_PILE_SIZE:{"card_pick_type": HandManager.DISCARD_PILE,
				"operator":"==","comparison_value":0}}],
			"action_data": [{Scripts.ACTION_ADD_INSIGHT: {}}]
			}
		}]
	card_aniseedscribe.card_play_actions.append(influence_action)
	card_aniseedscribe.card_end_of_turn_actions = end_action_data	
	Global.register_rod(card_aniseedscribe)
	
	var card_peddlerveteran: CardData = CardData.new("card_peddlerveteran")
	card_peddlerveteran.card_name = "Peddler Veteran"
	card_peddlerveteran.card_color_id = "color_{0}".format([color])
	card_peddlerveteran.card_texture_path = "external/sprites/cards/aniseed/09_peddlerveteran.png"
	card_peddlerveteran.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_peddlerveteran.card_description = "Gain [money_amount]{0}. Tick down Refresh Shop by 2.".format([Card.MONEY_ICON_KEYWORD])
	card_peddlerveteran.card_type = CardData.CARD_TYPES.SKILL
	card_peddlerveteran.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_peddlerveteran.card_requires_target = false
	card_peddlerveteran.card_energy_cost = 1
	card_peddlerveteran.card_values = {"money_amount": 2,"refresh_amount":-2}
	card_peddlerveteran.card_upgrade_value_improvements = {"money_amount": 2}
	card_peddlerveteran.card_play_actions = [
		{
			Scripts.ACTION_ADD_REFRESH: {}
		},
		{
		Scripts.ACTION_ADD_MONEY: {}
		}]
	card_peddlerveteran.card_play_actions.append(influence_action)
	card_peddlerveteran.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_peddlerveteran)
	
	var card_intrepidsailor: CardData = CardData.new("card_intrepidsailor")
	card_intrepidsailor.card_name = "Intrepid Sailor"
	card_intrepidsailor.card_color_id = "color_{0}".format([color])
	card_intrepidsailor.card_texture_path = "external/sprites/cards/aniseed/10_intrepidsailor.png"
	card_intrepidsailor.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_intrepidsailor.card_description = "Explore [damage]{0}. Consume [food_required]{1} to Wield [min_card_amount].".format([Card.EXPLORE_ICON_KEYWORD,Card.FOOD_ICON_KEYWORD])
	card_intrepidsailor.card_keyword_object_ids = ["keyword_wield"]
	card_intrepidsailor.card_type = CardData.CARD_TYPES.ATTACK
	card_intrepidsailor.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_intrepidsailor.card_requires_target = true
	card_intrepidsailor.card_energy_cost = 3
	card_intrepidsailor.card_values = {"damage": 4,"number_of_attacks":1, "min_card_amount": 2,
		"max_card_amount": 2, "food_required":2,"food_amount":-2}
	card_intrepidsailor.card_upgrade_value_improvements = {"damage":1,"min_card_amount": 2,"max_card_amount": 2}
	card_intrepidsailor.card_play_actions = [
		{
		Scripts.ACTION_VALIDATOR: {
			"validator_data":[{Scripts.VALIDATOR_FOOD: {}}],
			"action_data": [
				{Scripts.ACTION_ADD_FOOD: {}},
				{
				Scripts.ACTION_PICK_CARDS:
				{
					"min_cards_are_required_for_action": false,
					"random_selection": true,
					"card_pick_type": HandManager.DISCARD_PILE,
					"card_pick_text": "Choose {0} card to discard. {1} cards selected",
					"validator_data": [{Scripts.VALIDATOR_CARD_SUBTYPE: {"card_subtypes": [CardData.CARD_SUBTYPES.CRAFT]}}],
					"action_data": [{Scripts.ACTION_PLAY_CARDS:{}}]
				}
				}
				]
		}
		},
		{
		Scripts.ACTION_ATTACK_GENERATOR: {
			"time_delay":0.5
		}
		}]
	card_intrepidsailor.card_play_actions.append(influence_action)
	card_intrepidsailor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_intrepidsailor)
		
	var card_keeneyedbuccaneer: CardData = CardData.new("card_keeneyedbuccaneer")
	card_keeneyedbuccaneer.card_name = "Keen-Eyed Buccaneer"
	card_keeneyedbuccaneer.card_color_id = "color_{0}".format([color])
	card_keeneyedbuccaneer.card_texture_path = "external/sprites/cards/aniseed/11_keeneyedbuccaneer.png"
	card_keeneyedbuccaneer.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_keeneyedbuccaneer.card_description = "Shuffle your discard pile into your draw pile. Explore 1{0} for each Sword in your draw pile.".format([Card.EXPLORE_ICON_KEYWORD])
	card_keeneyedbuccaneer.card_type = CardData.CARD_TYPES.ATTACK
	card_keeneyedbuccaneer.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_keeneyedbuccaneer.card_requires_target = true
	card_keeneyedbuccaneer.card_energy_cost = 1
	card_keeneyedbuccaneer.card_values = {"damage": 1,"number_of_attacks":1}
	card_keeneyedbuccaneer.card_upgrade_value_improvements = {"damage":1}
	card_keeneyedbuccaneer.card_play_actions = [
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
			"validator_data":[{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_sword"]}}],
			"action_data": [
				{Scripts.ACTION_VARIABLE_CARDSET_MODIFIER: {
				"multiplied_values": ["damage"],
				"action_data": [{Scripts.ACTION_ATTACK_GENERATOR: {
				"time_delay": 0.5
				}}]
				}}]
		}
		}]
	card_keeneyedbuccaneer.card_play_actions.append(influence_action)
	card_keeneyedbuccaneer.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_keeneyedbuccaneer)
	
	
	var card_aniseedtaxcollector: CardData = CardData.new("card_aniseedtaxcollector")
	card_aniseedtaxcollector.card_name = "Aniseed Tax Collector"
	card_aniseedtaxcollector.card_color_id = "color_{0}".format([color])
	card_aniseedtaxcollector.card_texture_path = "external/sprites/cards/aniseed/12_aniseedtaxcollector.png"
	card_aniseedtaxcollector.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_aniseedtaxcollector.card_description = "Exhaust up to 1 card in hand, then Inspect [min_card_amount]."
	card_aniseedtaxcollector.card_keyword_object_ids = ["keyword_inspect"]
	card_aniseedtaxcollector.card_type = CardData.CARD_TYPES.SKILL
	card_aniseedtaxcollector.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_aniseedtaxcollector.card_requires_target = false
	card_aniseedtaxcollector.card_energy_cost = 2
	card_aniseedtaxcollector.card_values = {"min_card_amount":3,"max_card_amount":3}
	card_aniseedtaxcollector.card_upgrade_value_improvements = {"min_card_amount":1,"max_card_amount":1}
	card_aniseedtaxcollector.card_play_actions.append(inspect_action)
	card_aniseedtaxcollector.card_play_actions.append(exhaust_action)
	card_aniseedtaxcollector.card_play_actions.append(influence_action)
	card_aniseedtaxcollector.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_aniseedtaxcollector)


	var card_royalpurveyor: CardData = CardData.new("card_royalpurveyor")
	card_royalpurveyor.card_name = "Royal Purveyor"
	card_royalpurveyor.card_color_id = "color_{0}".format([color])
	#card_royalpurveyor.card_texture_path = "external/sprites/cards/aniseed/12_royalpurveyor.png"
	card_royalpurveyor.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_royalpurveyor.card_description = "Retain all cards in hand. Appease/Repair [card_influence] to Faction and Craft cards. If discarded, Fertilise [artifact_charge_increase]."
	card_royalpurveyor.card_keyword_object_ids = ["keyword_appease","keyword_repair", "keyword_fertilise"]
	card_royalpurveyor.card_type = CardData.CARD_TYPES.SKILL
	card_royalpurveyor.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_royalpurveyor.card_requires_target = false
	card_royalpurveyor.card_energy_cost = 2
	card_royalpurveyor.card_values = {"card_influence":2, "artifact_charge_increase": 3}
	card_royalpurveyor.card_upgrade_value_improvements = {"card_influence":1}
	card_royalpurveyor.card_play_actions = [		{
			Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to appease. {1} cards selected",
			"action_data": [{Scripts.ACTION_RETAIN_CARDS:{}},
			{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"time_delay": 0.1,
			"pick_played_card": false,
			"modify_parent_card": false,
		}
		}]}}]
	card_royalpurveyor.card_play_actions.append(influence_action)
	card_royalpurveyor.card_discard_actions = [{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_charge_increase":3,"artifact_id":"artifact_fertiliser"}}]
	card_royalpurveyor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_royalpurveyor)
	
	
	var card_peddlerinformant: CardData = CardData.new("card_peddlerinformant")
	card_peddlerinformant.card_name = "Peddler Informant"
	card_peddlerinformant.card_color_id = "color_{0}".format([color])
	card_peddlerinformant.card_texture_path = "external/sprites/cards/aniseed/card_peddlerinformant.png"
	card_peddlerinformant.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_peddlerinformant.card_description = "Create [number_of_cards] Scroll, Create 2 Debt. Reshuffle."
	card_peddlerinformant.card_keyword_object_ids = ["keyword_scroll","keyword_debt"]
	card_peddlerinformant.card_type = CardData.CARD_TYPES.SKILL
	card_peddlerinformant.card_rarity = CardData.CARD_RARITIES.RARE
	card_peddlerinformant.card_requires_target = false
	card_peddlerinformant.card_energy_cost = 2
	card_peddlerinformant.card_values = {"created_card_object_id":"card_scroll","number_of_cards":1}
	card_peddlerinformant.card_upgrade_value_improvements = {"number_of_cards":1}
	card_peddlerinformant.card_play_actions = [
		{
		Scripts.ACTION_RESHUFFLE: {}
		},
		{
			Scripts.ACTION_CREATE_CARDS:{
				"create_card_object_id":"card_debt",
				"number_of_cards":2,
				"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
			}
		}
		,
		{
			Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]}
		}]
	card_peddlerinformant.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_peddlerinformant)
	
	var card_taxfarmer: CardData = CardData.new("card_taxfarmer")
	card_taxfarmer.card_name = "Tax Farmer"
	card_taxfarmer.card_color_id = "color_{0}".format([color])
	card_taxfarmer.card_texture_path = "external/sprites/cards/aniseed/14_taxfarmer.png"
	card_taxfarmer.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_taxfarmer.card_description = "Gain 1{0} for every 2 cards in draw pile.".format([Card.MONEY_ICON_KEYWORD])
	card_taxfarmer.card_type = CardData.CARD_TYPES.SKILL
	card_taxfarmer.card_rarity = CardData.CARD_RARITIES.RARE
	card_taxfarmer.card_requires_target = false
	card_taxfarmer.card_energy_cost = 3
	card_taxfarmer.card_influence = 5
	card_taxfarmer.card_first_upgrade_property_changes = {"card_energy_cost":-1}
	#card_taxfarmer.card_upgrade_value_improvements = {"damage":1}
	card_taxfarmer.card_play_actions = [
		{
			Scripts.ACTION_ADD_MONEY:{"money_amount": HandManager.player_draw.size()/2}
		}]
	card_taxfarmer.card_play_actions.append(influence_action)
	card_taxfarmer.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_taxfarmer)
	
	var card_swashbucklingchamp: CardData = CardData.new("card_swashbucklingchamp")
	card_swashbucklingchamp.card_name = "Exalted Champ"
	card_swashbucklingchamp.card_color_id = "color_{0}".format([color])
	card_swashbucklingchamp.card_texture_path = "external/sprites/cards/aniseed/15_swashbucklingchamp.png"
	card_swashbucklingchamp.texture_bg_path = "external/sprites/cards/frames/anisframe.png"
	card_swashbucklingchamp.card_description = "Explore [damage]{0}, then improve and wield [min_card_amount].".format([Card.EXPLORE_ICON_KEYWORD])
	card_swashbucklingchamp.card_keyword_object_ids = ["keyword_wield"]
	card_swashbucklingchamp.card_type = CardData.CARD_TYPES.ATTACK
	card_swashbucklingchamp.card_rarity = CardData.CARD_RARITIES.RARE
	card_swashbucklingchamp.card_requires_target = true
	card_swashbucklingchamp.card_energy_cost = 2
	card_swashbucklingchamp.card_values = {"damage":4,"draw_count":2, "min_card_amount":2,"max_card_amount":2}
	card_swashbucklingchamp.card_upgrade_value_improvements = {"damage":1,"draw_count":1, "min_card_amount":1,"max_card_amount":1}
	card_swashbucklingchamp.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to wield. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_sword"]}}],
			"action_data": [{
			Scripts.ACTION_PLAY_CARDS: {}},
			{
			Scripts.ACTION_IMPROVE_CARD_VALUES: {
				"card_value_improvements":{"damage":1},
				"time_delay": 0.1,
				"modify_parent_card": false,
			}}]
		}},
		{
			Scripts.ACTION_ATTACK_GENERATOR:{}
		}]
	card_swashbucklingchamp.card_play_actions.append(influence_action)
	card_swashbucklingchamp.card_end_of_turn_actions = end_action_data

	Global.register_rod(card_swashbucklingchamp)
#endregion
func add_cards_green() -> void:
	var color: String = "green"

	var card_cofferskeeper: CardData = CardData.new("card_cofferskeeper")
	card_cofferskeeper.card_name = "Coffers Keeper"
	card_cofferskeeper.card_color_id = "color_{0}".format([color])
	card_cofferskeeper.card_texture_path = "external/sprites/cards/jade/01_cofferskeeper.png"
	card_cofferskeeper.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_cofferskeeper.card_description = "Gain [food_amount]{0}, [ore_amount]{1}, [money_amount]{2}. Create [number_of_cards] Debt.".format([Card.FOOD_ICON_KEYWORD,Card.ORE_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_cofferskeeper.card_keyword_object_ids = ["keyword_debt"]
	card_cofferskeeper.card_type = CardData.CARD_TYPES.SKILL
	card_cofferskeeper.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cofferskeeper.card_requires_target = false
	card_cofferskeeper.card_energy_cost = 1
	card_cofferskeeper.card_values = {"ore_amount":1,"money_amount":1,"food_amount":1,"created_card_object_id":"card_debt", "number_of_cards": 1}
	card_cofferskeeper.card_upgrade_value_improvements = {"ore_amount":1, "money_amount":1, "food_amount":1, "number_of_cards": 1}
	card_cofferskeeper.card_play_actions = [
		{
		Scripts.ACTION_CREATE_CARDS:{
			"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
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
	card_cofferskeeper.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cofferskeeper)
	
	var card_youngmentor: CardData = CardData.new("card_youngmentor")
	card_youngmentor.card_name = "Young Mentor"
	card_youngmentor.card_color_id = "color_{0}".format([color])
	card_youngmentor.card_texture_path = "external/sprites/cards/jade/02_youngmentor.png"
	card_youngmentor.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_youngmentor.card_description = "Create [number_of_cards] Fish, discard up to 2 cards."
	card_youngmentor.card_type = CardData.CARD_TYPES.SKILL
	card_youngmentor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_youngmentor.card_requires_target = false
	card_youngmentor.card_energy_cost = 1
	card_youngmentor.card_values = {"created_card_object_id":"card_fish","number_of_cards":1}
	card_youngmentor.card_upgrade_value_improvements = {"number_of_cards":1}
	card_youngmentor.card_play_actions = [{
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
	card_youngmentor.card_play_actions.append(influence_action)
	card_youngmentor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_youngmentor)
	
	var card_luckfinder: CardData = CardData.new("card_luckfinder")
	card_luckfinder.card_name = "Luck Finder"
	card_luckfinder.card_color_id = "color_{0}".format([color])
	card_luckfinder.card_texture_path = "external/sprites/cards/jade/03_luckfinder.png"
	card_luckfinder.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_luckfinder.card_description = "Explore [damage]{0}. Exhaust up to 1 card.".format([Card.EXPLORE_ICON_KEYWORD])
	card_luckfinder.card_type = CardData.CARD_TYPES.ATTACK
	card_luckfinder.card_rarity = CardData.CARD_RARITIES.COMMON
	card_luckfinder.card_requires_target = true
	card_luckfinder.card_energy_cost = 1
	card_luckfinder.card_values = {"damage":2,"number_of_attacks":1}
	card_luckfinder.card_upgrade_value_improvements = {"damage":1}
	card_luckfinder.card_play_actions.append(exhaust_action)
	card_luckfinder.card_play_actions.append({
		Scripts.ACTION_ATTACK_GENERATOR:{}
	})
	card_luckfinder.card_play_actions.append(influence_action)
	card_luckfinder.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_luckfinder)
	
		
	var card_commercialcropper: CardData = CardData.new("card_commercialcropper")
	card_commercialcropper.card_name = "Commercial Cropper"
	card_commercialcropper.card_color_id = "color_{0}".format([color])
	#card_commercialcropper.card_texture_path = "external/sprites/cards/jade/03_commercialcropper.png"
	card_commercialcropper.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_commercialcropper.card_description = "Fertilise [artifact_charge_increase]. Tick down Shop Refresh by [refresh_amount]".format([Card.EXPLORE_ICON_KEYWORD])
	card_commercialcropper.card_keyword_object_ids = ["keyword_fertilise"]
	card_commercialcropper.card_type = CardData.CARD_TYPES.SKILL
	card_commercialcropper.card_rarity = CardData.CARD_RARITIES.COMMON
	card_commercialcropper.card_requires_target = false
	card_commercialcropper.card_energy_cost = 1
	card_commercialcropper.card_values = {"artifact_charge_increase":3,"refresh_amount":2}
	card_commercialcropper.card_upgrade_value_improvements = {"artifact_charge_increase":1,"refresh_amount":1}
	card_commercialcropper.card_play_actions = [
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}},
		{Scripts.ACTION_ADD_REFRESH:{}}
	]
	card_commercialcropper.card_play_actions.append(influence_action)
	card_commercialcropper.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_commercialcropper)
	
	var card_avidsower: CardData = CardData.new("card_avidsower")
	card_avidsower.card_name = "Avid Sower"
	card_avidsower.card_color_id = "color_{0}".format([color])
	#card_avidsower.card_texture_path = "external/sprites/cards/jade/03_avidsower.png"
	card_avidsower.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_avidsower.card_description = "Return up to [max_card_amount] cards in your discard pile to the bottom of your draw pile. Fertilise [artifact_charge_increase].".format([Card.EXPLORE_ICON_KEYWORD])
	card_avidsower.card_keyword_object_ids = ["keyword_fertilise"]
	card_avidsower.card_type = CardData.CARD_TYPES.SKILL
	card_avidsower.card_rarity = CardData.CARD_RARITIES.COMMON
	card_avidsower.card_requires_target = false
	card_avidsower.card_influence = 3
	card_avidsower.card_energy_cost = 1
	card_avidsower.card_values = {"artifact_charge_increase":3,"max_card_amount":2}
	card_avidsower.card_upgrade_value_improvements = {"artifact_charge_increase":1,"max_card_amount":1}
	card_avidsower.card_play_actions = [
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}},
		{Scripts.ACTION_PICK_CARDS:{
			"min_card_amount": 0,
			"max_card_amount": 2,
			"card_pick_type": HandManager.DISCARD_PILE,
			"min_cards_are_required_for_action": false,
			"random_selection": false,
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DRAW: {"card_destination_strategy":HandManager.PILE_INSERTION_STRATEGIES.BOTTOM}
			}]
		}}]
	card_avidsower.card_play_actions.append(influence_action)
	card_avidsower.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_avidsower)
	
	var card_greeninformant: CardData = CardData.new("card_greeninformant")
	card_greeninformant.card_name = "Green Informant"
	card_greeninformant.card_color_id = "color_{0}".format([color])
	card_greeninformant.card_texture_path = "external/sprites/cards/jade/04_greeninformant.png"
	card_greeninformant.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_greeninformant.card_description = "Draw [draw_count], then Weave [number_of_cards]."
	card_greeninformant.card_keyword_object_ids = ["keyword_weave"]
	card_greeninformant.card_type = CardData.CARD_TYPES.SKILL
	card_greeninformant.card_rarity = CardData.CARD_RARITIES.COMMON
	card_greeninformant.card_requires_target = false
	card_greeninformant.card_energy_cost = 1
	card_greeninformant.card_values = {"number_of_cards":1,"draw_count": 1,"insight_required":1,"insight_amount":-1}
	card_greeninformant.card_upgrade_value_improvements = {"draw_count": 1}
	card_greeninformant.card_play_actions.append(weave_action)
	card_greeninformant.card_play_actions.append(influence_action)
	card_greeninformant.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_greeninformant)
	
	var card_goldenconscript: CardData = CardData.new("card_goldenconscript")
	card_goldenconscript.card_name = "Golden Conscript"
	card_goldenconscript.card_color_id = "color_{0}".format([color])
	card_goldenconscript.card_texture_path = "external/sprites/cards/jade/05_goldenconscript.png"
	card_goldenconscript.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_goldenconscript.card_description = "Explore [damage]{0}, then draw [draw_count].".format([Card.EXPLORE_ICON_KEYWORD])
	card_goldenconscript.card_type = CardData.CARD_TYPES.ATTACK
	card_goldenconscript.card_rarity = CardData.CARD_RARITIES.COMMON
	card_goldenconscript.card_requires_target = true
	card_goldenconscript.card_energy_cost = 1
	card_goldenconscript.card_values = {"card_influence":1,"draw_count": 1,"damage":2,"number_of_attacks":1}
	card_goldenconscript.card_upgrade_value_improvements = {"draw_count":1,"damage":1}
	card_goldenconscript.card_play_actions = [
		{
		Scripts.ACTION_DRAW_GENERATOR:{}
		},
		{Scripts.ACTION_ATTACK_GENERATOR:{"time_delay": 0.5}}]
	card_goldenconscript.card_play_actions.append(influence_action)
	card_goldenconscript.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_goldenconscript)
	
	var card_militantoutsourcer: CardData = CardData.new("card_militantoutsourcer")
	card_militantoutsourcer.card_name = "Militant Outsourcer"
	card_militantoutsourcer.card_color_id = "color_{0}".format([color])
	card_militantoutsourcer.card_texture_path = "external/sprites/cards/jade/06_militantoutsourcer.png"
	card_militantoutsourcer.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_militantoutsourcer.card_description = "Explore [damage]{0}. Return 1 card from your discard pile to your hand.".format([Card.EXPLORE_ICON_KEYWORD])
	card_militantoutsourcer.card_type = CardData.CARD_TYPES.ATTACK
	card_militantoutsourcer.card_rarity = CardData.CARD_RARITIES.COMMON
	card_militantoutsourcer.card_requires_target = true
	card_militantoutsourcer.card_energy_cost = 1
	card_militantoutsourcer.card_values = {"damage":2,"number_of_attacks":1}
	card_militantoutsourcer.card_upgrade_value_improvements = {"damage":2}
	card_militantoutsourcer.card_play_actions = [
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
	card_militantoutsourcer.card_play_actions.append(influence_action)
	card_militantoutsourcer.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_militantoutsourcer)
	
	var card_mysticsower: CardData = CardData.new("card_mysticsower")
	card_mysticsower.card_name = "Mystic Sower"
	card_mysticsower.card_color_id = "color_{0}".format([color])
	#card_mysticsower.card_texture_path = "external/sprites/cards/jade/07_mysticsower.png"
	card_mysticsower.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_mysticsower.card_description = "Create [number_of_cards] Grains. Put up to 2 cards from your discard pile to the bottom of your draw pile."
	card_mysticsower.card_type = CardData.CARD_TYPES.SKILL
	card_mysticsower.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_mysticsower.card_requires_target = false
	card_mysticsower.card_energy_cost = 1
	card_mysticsower.card_values = {"created_card_object_id":"card_grain","number_of_cards":2}
	card_mysticsower.card_upgrade_value_improvements = {"number_of_cards":1}
	card_mysticsower.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS:{
				"min_card_amount": 0,
				"max_card_amount": 2,
				"card_pick_type": HandManager.DISCARD_PILE,
				"min_cards_are_required_for_action": false,
				"random_selection": false,
				"action_data": [{Scripts.ACTION_ADD_CARDS_TO_DRAW: {"card_destination_strategy":HandManager.PILE_INSERTION_STRATEGIES.BOTTOM}
				}]
			}
		},
		{
		Scripts.ACTION_CREATE_CARDS:{"action_data":[{Scripts.ACTION_ADD_CARDS_TO_DRAW:{}}]
		}}]
	card_mysticsower.card_play_actions.append(influence_action)
	card_mysticsower.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_mysticsower)
	
	var card_shockrider: CardData = CardData.new("card_shockrider")
	card_shockrider.card_name = "Shock Rider"
	card_shockrider.card_color_id = "color_{0}".format([color])
	card_shockrider.card_texture_path = "external/sprites/cards/jade/08_shockrider.png"
	card_shockrider.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_shockrider.card_description = "Explore [damage]{0}. Forge [ore_required] Sword, Wield [min_card_amount].".format([Card.EXPLORE_ICON_KEYWORD])
	card_shockrider.card_type = CardData.CARD_TYPES.ATTACK
	card_shockrider.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_shockrider.card_requires_target = true
	card_shockrider.card_energy_cost = 1
	card_shockrider.card_values = {"damage":3,"number_of_attacks":1,"ore_amount":-1, "ore_required": 1,"number_of_cards":1,"created_card_object_id":"card_sword", "min_card_amount":1,"max_card_amount":1}
	card_shockrider.card_keyword_object_ids = ["keyword_forge","keyword_sword","keyword_wield"]
	card_shockrider.card_upgrade_value_improvements = {"damage":1,"ore_amount":-1, "ore_required": 1,"min_card_amount":1,"max_card_amount":1}
	card_shockrider.card_first_upgrade_property_changes = {"card_energy_cost": 1}
	card_shockrider.card_play_actions.append(wield_action)
	card_shockrider.card_play_actions.append(forge_action)
	card_shockrider.card_play_actions.append(
		{Scripts.ACTION_ATTACK_GENERATOR:{"time_delay": 0.5}})
	card_shockrider.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_shockrider)
	
	var card_everymanleader: CardData = CardData.new("card_everymanleader")
	card_everymanleader.card_name = "Everyman Leader"
	card_everymanleader.card_color_id = "color_{0}".format([color])
	card_everymanleader.card_texture_path = "external/sprites/cards/jade/09_everymanleader.png"
	card_everymanleader.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_everymanleader.card_description = "Appease twice up to [min_card_amount] cards in discard pile. Return them to your hand."
	card_everymanleader.card_keyword_object_ids = ["keyword_appease"]
	card_everymanleader.card_type = CardData.CARD_TYPES.SKILL
	card_everymanleader.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_everymanleader.card_requires_target = false
	card_everymanleader.card_energy_cost = 2
	card_everymanleader.card_values = {"max_card_amount":2}
	card_everymanleader.card_upgrade_value_improvements = {"max_card_amount":1}
	card_everymanleader.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_cards_are_required_for_action": false,
			"random_selection": false,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to appease twice and return to you hand. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}},{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":2,
			"time_delay": 0.1,
			"modify_parent_card": false,
		}}]
		}
		}]
	card_everymanleader.card_play_actions.append(influence_action)
	card_everymanleader.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_everymanleader)
	
	var card_inspiredgossipmonger: CardData = CardData.new("card_inspiredgossipmonger")
	card_inspiredgossipmonger.card_name = "Inspired Gossipmonger"
	card_inspiredgossipmonger.card_color_id = "color_{0}".format([color])
	card_inspiredgossipmonger.card_texture_path = "external/sprites/cards/jade/10_inspiredgossipmonger.png"
	card_inspiredgossipmonger.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_inspiredgossipmonger.card_description = "Rattle all cards in discard pile to gain [insight_amount]{0}.".format([Card.INSIGHT_ICON_KEYWORD])
	card_inspiredgossipmonger.card_keyword_object_ids = ["keyword_rattle"]
	card_inspiredgossipmonger.card_type = CardData.CARD_TYPES.SKILL
	card_inspiredgossipmonger.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_inspiredgossipmonger.card_requires_target = false
	card_inspiredgossipmonger.card_energy_cost = 1
	card_inspiredgossipmonger.card_values = {"insight_amount":1}
	card_inspiredgossipmonger.card_upgrade_value_improvements = {"insight_amount":1}
	card_inspiredgossipmonger.card_play_actions = [
		{
			Scripts.ACTION_ADD_INSIGHT: {}
		},
		{
			Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":-1,
			"time_delay": 0.1,
			"modify_parent_card": false,
		}}]
		}
		}]
	card_inspiredgossipmonger.card_play_actions.append(influence_action)
	card_inspiredgossipmonger.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_inspiredgossipmonger)
	
	var card_wizenedforager: CardData = CardData.new("card_wizenedforager")
	card_wizenedforager.card_name = "Wizened Forager"
	card_wizenedforager.card_color_id = "color_{0}".format([color])
	card_wizenedforager.card_texture_path = "external/sprites/cards/jade/11_wizenedforager.png"
	card_wizenedforager.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_wizenedforager.card_description = "Create 3 Grains. When discarded, create [number_of_cards] Fish instead."
	card_wizenedforager.card_type = CardData.CARD_TYPES.SKILL
	card_wizenedforager.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_wizenedforager.card_requires_target = false
	card_wizenedforager.card_energy_cost = 1
	card_wizenedforager.card_values = {"created_card_object_id":"card_fish","number_of_cards":1}
	card_wizenedforager.card_upgrade_value_improvements = {"number_of_cards":1}
	card_wizenedforager.card_play_actions = [
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
	card_wizenedforager.card_play_actions.append(influence_action)
	card_wizenedforager.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_wizenedforager)
	
	var card_gardenmystic: CardData = CardData.new("card_gardenmystic")
	card_gardenmystic.card_name = "Garden Mystic"
	card_gardenmystic.card_color_id = "color_{0}".format([color])
	#card_gardenmystic.card_texture_path = "external/sprites/cards/jade/11_gardenmystic.png"
	card_gardenmystic.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_gardenmystic.card_description = "Cook [number_of_cards] Delicacy. When discarded, Fertilise [artifact_charge_increase] instead."
	card_gardenmystic.card_keyword_object_ids = ["keyword_cook", "keyword_delicacy", "keyword_fertiliser"]
	card_gardenmystic.card_type = CardData.CARD_TYPES.SKILL
	card_gardenmystic.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_gardenmystic.card_requires_target = false
	card_gardenmystic.card_energy_cost = 1
	card_gardenmystic.card_influence = 3
	card_gardenmystic.card_values = {"created_card_object_id":"card_delicacy","number_of_cards":1,"artifact_charge_increase":3}
	card_gardenmystic.card_upgrade_value_improvements = {"artifact_charge_increase":2}
	card_gardenmystic.card_play_actions.append(cook_action)
	card_gardenmystic.card_discard_actions = [
		{
			Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:
				{
					"artifact_id":"artifact_fertiliser"
				}
		}
	]
	card_gardenmystic.card_play_actions.append(influence_action)
	card_gardenmystic.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_gardenmystic)
	
	
	var card_hoardingstowaway: CardData = CardData.new("card_hoardingstowaway")
	card_hoardingstowaway.card_name = "Hoarding Stowaway"
	card_hoardingstowaway.card_color_id = "color_{0}".format([color])
	card_hoardingstowaway.card_texture_path = "external/sprites/cards/jade/12_hoardingstowaway.png"
	card_hoardingstowaway.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_hoardingstowaway.card_description = "Weave [number_of_cards], then return all Scroll cards to your hand."
	card_hoardingstowaway.card_keyword_object_ids = ["keyword_weave","keyword_scroll"]
	card_hoardingstowaway.card_type = CardData.CARD_TYPES.SKILL
	card_hoardingstowaway.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_hoardingstowaway.card_requires_target = false
	card_hoardingstowaway.card_influence = 4
	card_hoardingstowaway.card_energy_cost = 2
	card_hoardingstowaway.card_first_upgrade_property_changes = {"card_energy_cost":-1}
	card_hoardingstowaway.card_values = {"number_of_cards":1,"insight_required":1,"insight_amount":-1}
	card_hoardingstowaway.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to return. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_ID: {"card_object_ids": ["card_scroll"]}}],
			"action_data": [{Scripts.ACTION_ADD_CARDS_TO_HAND:{}}]
		}
		}]
	card_hoardingstowaway.card_play_actions.append(weave_action)
	card_hoardingstowaway.card_play_actions.append(influence_action)
	card_hoardingstowaway.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_hoardingstowaway)
	
	var card_supremerecaster: CardData = CardData.new("card_supremerecaster")
	card_supremerecaster.card_name = "Supreme Recaster"
	card_supremerecaster.card_color_id = "color_{0}".format([color])
	card_supremerecaster.card_texture_path = "external/sprites/cards/jade/13_supremerecaster.png"
	card_supremerecaster.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_supremerecaster.card_description = "Weave a Scroll, Cook a Delicacy, then Draw [draw_count]."
	card_supremerecaster.card_keyword_object_ids = ["keyword_weave","keyword_cook"]
	card_supremerecaster.card_type = CardData.CARD_TYPES.SKILL
	card_supremerecaster.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_supremerecaster.card_requires_target = false
	card_supremerecaster.card_energy_cost = 2
	card_supremerecaster.card_values = {"draw_count":2,"insight_required":1,"insight_amount":-1,"number_of_cards":1}
	card_supremerecaster.card_upgrade_value_improvements = {"draw_count":2}
	card_supremerecaster.card_play_actions = [{Scripts.ACTION_DRAW_GENERATOR:{}}]
	card_supremerecaster.card_play_actions.append(cook_action)
	card_supremerecaster.card_play_actions.append(weave_action)
	card_supremerecaster.card_play_actions.append(influence_action)
	card_supremerecaster.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_supremerecaster)
	
		
	var card_villagehero: CardData = CardData.new("card_villagehero")
	card_villagehero.card_name = "Village Hero"
	card_villagehero.card_color_id = "color_{0}".format([color])
	card_villagehero.card_texture_path = "external/sprites/cards/jade/villagehero.png"
	card_villagehero.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_villagehero.card_description = "Explore 1{0} for each Faction card in discard pile.".format([Card.EXPLORE_ICON_KEYWORD])
	card_villagehero.card_type = CardData.CARD_TYPES.ATTACK
	card_villagehero.card_rarity = CardData.CARD_RARITIES.RARE
	card_villagehero.card_requires_target = true
	card_villagehero.card_energy_cost = 2
	card_villagehero.card_values = {"damage":1, "number_of_attacks":1}
	card_villagehero.card_upgrade_value_improvements = {"damage":1}
	card_villagehero.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":99,
			"max_card_amount":99,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to add. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_VARIABLE_CARDSET_MODIFIER: {
			"multiplied_values": ["damage"],
			"action_data": [{Scripts.ACTION_ATTACK_GENERATOR: {
				"time_delay": 0.5
					}}]}
			}]
		}
		}]
	card_villagehero.card_play_actions.append(influence_action)
	card_villagehero.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_villagehero)
	
	var card_solverofriddles: CardData = CardData.new("card_solverofriddles")
	card_solverofriddles.card_name = "Solver of Riddles"
	card_solverofriddles.card_color_id = "color_{0}".format([color])
	card_solverofriddles.card_texture_path = "external/sprites/cards/cengkih/15_solverofriddles.png"
	card_solverofriddles.texture_bg_path = "external/sprites/cards/frames/jadeframe.png"
	card_solverofriddles.card_description = "Exhaust 1 Scroll in hand to gain 2{0}, 2{1}, 2{2}, 2{3}".format([Card.FOOD_ICON_KEYWORD,Card.ORE_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD,Card.INSIGHT_ICON_KEYWORD])
	card_solverofriddles.card_type = CardData.CARD_TYPES.SKILL
	card_solverofriddles.card_rarity = CardData.CARD_RARITIES.RARE
	card_solverofriddles.card_requires_target = false
	card_solverofriddles.card_energy_cost = 2
	card_solverofriddles.card_values = {"food_amount":2,"ore_amount":2,"money_amount":2,"insight_amount":2}
	card_solverofriddles.card_upgrade_value_improvements = {"damage":1}
	card_solverofriddles.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":1,
			"max_card_amount":1,
			"min_cards_are_required_for_action": true,
			"random_selection": true,
			"card_pick_type": HandManager.HAND_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_ID:{"card_object_ids":["card_scroll"]}}],
			"action_data": [{Scripts.ACTION_ADD_INSIGHT:{}},{Scripts.ACTION_ADD_MONEY:{}},{Scripts.ACTION_ADD_ORE:{}},{Scripts.ACTION_ADD_FOOD:{}}]
		}
		}]
	card_solverofriddles.card_play_actions.append(influence_action)
	card_solverofriddles.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_solverofriddles)
	
func add_cards_gold() -> void:
	var color: String = "gold"
	
	var card_spiceguard: CardData = CardData.new("card_spiceguard")
	card_spiceguard.card_name = "Spice Guard"
	card_spiceguard.card_color_id = "color_{0}".format([color])
	card_spiceguard.card_texture_path = "external/sprites/cards/cengkih/01_spiceguard.png"
	card_spiceguard.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_spiceguard.card_description = "Explore [damage]{0}. Rattle 2 random cards in discard pile.".format([Card.EXPLORE_ICON_KEYWORD])
	card_spiceguard.card_keyword_object_ids = ["keyword_rattle"]
	card_spiceguard.card_type = CardData.CARD_TYPES.ATTACK
	card_spiceguard.card_rarity = CardData.CARD_RARITIES.COMMON
	card_spiceguard.card_requires_target = true
	card_spiceguard.card_energy_cost = 1
	card_spiceguard.card_influence = 3
	card_spiceguard.card_values = {"damage": 4}
	card_spiceguard.card_upgrade_value_improvements = {"damage": 2}
	card_spiceguard.card_play_actions = [
		{
			Scripts.ACTION_ADD_FOOD: {
			}
		},
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_card_amount":2,
			"max_card_amount":2,
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":-1,
			"time_delay": 0.1,
			"modify_parent_card": false,
		}}]
		}
		}
	]
	card_spiceguard.card_play_actions.append(influence_action)
	card_spiceguard.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_spiceguard)

	var card_cengkihemissary: CardData = CardData.new("card_cengkihemissary")
	card_cengkihemissary.card_name = "Cengkih Emissary"
	card_cengkihemissary.card_color_id = "color_{0}".format([color])
	card_cengkihemissary.card_texture_path = "external/sprites/cards/cengkih/02_cengkihemissary.png"
	card_cengkihemissary.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_cengkihemissary.card_description = "Appease [min_card_amount] random cards in discard pile."
	card_cengkihemissary.card_keyword_object_ids = ["keyword_appease"]
	card_cengkihemissary.card_type = CardData.CARD_TYPES.SKILL
	card_cengkihemissary.card_rarity = CardData.CARD_RARITIES.COMMON
	card_cengkihemissary.card_requires_target = false
	card_cengkihemissary.card_energy_cost = 1
	card_cengkihemissary.card_influence = 3
	card_cengkihemissary.card_values = {"min_card_amount":3, "max_card_amount":3}
	card_cengkihemissary.card_upgrade_value_improvements = {"min_card_amount":1,"max_card_amount":1}
	card_cengkihemissary.card_play_actions = [
		{
		Scripts.ACTION_PICK_CARDS:
		{
			"min_cards_are_required_for_action": false,
			"random_selection": true,
			"card_pick_type": HandManager.DISCARD_PILE,
			"card_pick_text": "Choose {0} card to rattle. {1} cards selected",
			"validator_data": [{Scripts.VALIDATOR_CARD_RARITY: {"card_rarities_exclude": [CardData.CARD_RARITIES.GENERATED]}}],
			"action_data": [{Scripts.ACTION_CHANGE_CARD_INFLUENCE: {
			"card_influence":1,
			"time_delay": 0.1,
			"modify_parent_card": false,
		}}]
		}
		}
	]
	card_cengkihemissary.card_play_actions.append(influence_action)
	card_cengkihemissary.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cengkihemissary)
	
	var card_happysailor: CardData = CardData.new("card_happysailor")
	card_happysailor.card_name = "Happy Sailor"
	card_happysailor.card_color_id = "color_{0}".format([color])
	card_happysailor.card_texture_path = "external/sprites/cards/cengkih/03_happysailor.png"
	card_happysailor.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_happysailor.card_description = "Explore [damage]{0}. Draw [draw_count].".format([Card.EXPLORE_ICON_KEYWORD])
	card_happysailor.card_type = CardData.CARD_TYPES.ATTACK
	card_happysailor.card_rarity = CardData.CARD_RARITIES.COMMON
	card_happysailor.card_requires_target = true
	card_happysailor.card_energy_cost = 3
	card_happysailor.card_influence = 5
	card_happysailor.card_values = {"damage": 4, "number_of_attacks": 1, "draw_count":2}
	card_happysailor.card_upgrade_value_improvements = {"damage": 2,"draw_count": 1}
	card_happysailor.card_play_actions = [
		{
			Scripts.ACTION_DRAW_GENERATOR:{}},
		{
			Scripts.ACTION_ATTACK_GENERATOR: {"time_delay": 0.5},
		},
	]
	card_happysailor.card_play_actions.append(influence_action)
	card_happysailor.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_happysailor)
	
	var card_shucker: CardData = CardData.new("card_shucker")
	card_shucker.card_name = "Shucker"
	card_shucker.card_color_id = "color_{0}".format([color])
	card_shucker.card_texture_path = "external/sprites/cards/cengkih/04_shucker.png"
	card_shucker.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_shucker.card_description = "Create [number_of_cards] Fish. Gain [money_amount]{0}.".format([Card.MONEY_ICON_KEYWORD])
	card_shucker.card_type = CardData.CARD_TYPES.SKILL
	card_shucker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_shucker.card_requires_target = false
	card_shucker.card_energy_cost = 1
	card_shucker.card_influence = 3
	card_shucker.card_values = {"money_amount":1,"created_card_object_id":"card_fish","number_of_cards":1}
	card_shucker.card_upgrade_value_improvements = {"money_amount": 1}
	card_shucker.card_play_actions = [
		{Scripts.ACTION_ADD_MONEY:{}},
		{Scripts.ACTION_CREATE_CARDS: {
			"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
		}}
		]
	card_shucker.card_play_actions.append(influence_action)
	card_shucker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_shucker)
	
	var card_foresttracker: CardData = CardData.new("card_foresttracker")
	card_foresttracker.card_name = "Forest Tracker"
	card_foresttracker.card_color_id = "color_{0}".format([color])
	card_foresttracker.card_texture_path = "external/sprites/cards/cengkih/05_foresttracker.png"
	card_foresttracker.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_foresttracker.card_description = "Create 1 Grain. Fertilise [artifact_charge_increase].".format([Card.INSIGHT_ICON_KEYWORD,Card.FOOD_ICON_KEYWORD])
	card_foresttracker.card_type = CardData.CARD_TYPES.SKILL
	card_foresttracker.card_rarity = CardData.CARD_RARITIES.COMMON
	card_foresttracker.card_requires_target = false
	card_foresttracker.card_energy_cost = 1
	card_foresttracker.card_values = {"card_influence":1,"created_card_object_id":"card_grain","number_of_cards":1,"artifact_charge_increase":2}
	card_foresttracker.card_upgrade_value_improvements = {"number_of_cards": 1}
	card_foresttracker.card_play_actions = [
		{Scripts.ACTION_INCREASE_ARTIFACT_CHARGE:{"artifact_id":"artifact_fertiliser"}},
		{Scripts.ACTION_CREATE_CARDS: {
			"action_data":[{Scripts.ACTION_DISCARD_CARDS:{}}]
		}}
		]
	card_foresttracker.card_play_actions.append(influence_action)
	card_foresttracker.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_foresttracker)
	
	var card_flintlockschooner: CardData = CardData.new("card_flintlockschooner")
	card_flintlockschooner.card_name = "Flintlock Schooner"
	card_flintlockschooner.card_color_id = "color_{0}".format([color])
	card_flintlockschooner.card_texture_path = "external/sprites/cards/cengkih/06_flintlockschooner.png"
	card_flintlockschooner.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_flintlockschooner.card_description = "Repair all Swords in discard pile by [card_influence]. Wield [min_card_amount]."
	card_flintlockschooner.card_keyword_object_ids = ["keyword_repair", "keyword_wield"]
	card_flintlockschooner.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockschooner.card_rarity = CardData.CARD_RARITIES.COMMON
	card_flintlockschooner.card_requires_target = false
	card_flintlockschooner.card_energy_cost = 3
	card_flintlockschooner.card_influence = 5
	card_flintlockschooner.card_values = {"min_card_amount":2,"max_card_amount":2,"card_influence":1}
	card_flintlockschooner.card_upgrade_value_improvements = {"min_card_amount":2,"max_card_amount":2, "card_influence":1}
	card_flintlockschooner.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose up to {0} card(s) to wield. {1} cards selected",
				"validator_data":[{Scripts.VALIDATOR_CARD_ID:[{"card_object_ids":["card_sword"]}]}],
				"action_data": [
				{Scripts.ACTION_PLAY_CARDS:{}}]
				}
			},
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose up to {0} card(s) to wield. {1} cards selected",
				"validator_data":[{Scripts.VALIDATOR_CARD_ID:[{"card_object_ids":["card_sword"]}]}],
				"action_data": [
				{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{}}]
				}
			},
	]
	card_flintlockschooner.card_play_actions.append(influence_action)
	card_flintlockschooner.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_flintlockschooner)
	
	var card_reveredsmithy: CardData = CardData.new("card_reveredsmithy")
	card_reveredsmithy.card_name = "Revered Smithy"
	card_reveredsmithy.card_color_id = "color_{0}".format([color])
	card_reveredsmithy.card_texture_path = "external/sprites/cards/cengkih/07_reveredsmithy.png"
	card_reveredsmithy.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_reveredsmithy.card_description = "Forge [ore_required] Treasures."
	card_reveredsmithy.card_keyword_object_ids = ["keyword_forge","keyword_treasure"]
	card_reveredsmithy.card_type = CardData.CARD_TYPES.SKILL
	card_reveredsmithy.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_reveredsmithy.card_requires_target = false
	card_reveredsmithy.card_energy_cost = 2
	card_reveredsmithy.card_influence = 4
	card_reveredsmithy.card_values = {"ore_required": 2,"ore_amount": -2, "number_of_cards":2, "created_card_object_id":"card_treasure"}
	card_reveredsmithy.card_upgrade_value_improvements = {"ore_required": 1,"ore_amount": -1, "number_of_cards":1}
	card_reveredsmithy.card_play_actions.append(forge_action)
	card_reveredsmithy.card_play_actions.append(influence_action)
	card_reveredsmithy.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_reveredsmithy)
	
	var card_ravineexplorer: CardData = CardData.new("card_ravineexplorer")
	card_ravineexplorer.card_name = "Ravine Explorer"
	card_ravineexplorer.card_color_id = "color_{0}".format([color])
	card_ravineexplorer.card_texture_path = "external/sprites/cards/cengkih/08_ravineexplorer.png"
	card_ravineexplorer.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_ravineexplorer.card_description = "Explore [damage]{0}. If you've completed an expedition, create 1 Grain and 1 Fish.".format([Card.EXPLORE_ICON_KEYWORD])
	card_ravineexplorer.card_type = CardData.CARD_TYPES.ATTACK
	card_ravineexplorer.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_ravineexplorer.card_requires_target = true
	card_ravineexplorer.card_energy_cost = 1
	card_ravineexplorer.card_influence = 3
	card_ravineexplorer.card_values = {"damage":4,"number_of_attacks":1}
	card_ravineexplorer.card_upgrade_value_improvements = {"damage":2}
	card_ravineexplorer.card_play_actions = [
		{
			Scripts.ACTION_ATTACK_GENERATOR:
				{
					"actions_on_lethal":[{Scripts.ACTION_CREATE_CARDS:{
						"created_card_object_id":"card_fish",
						"number_of_cards": 1,
						"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
					}},
					{
						Scripts.ACTION_CREATE_CARDS:{
							"created_card_object_id":"card_grain",
							"number_of_cards": 1,
							"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]
						}
					}]
				}
		}
	]
	card_ravineexplorer.card_play_actions.append(influence_action)
	card_ravineexplorer.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_ravineexplorer)
	
	var card_flintlockcrier: CardData = CardData.new("card_flintlockcrier")
	card_flintlockcrier.card_name = "Flintlock Crier"
	card_flintlockcrier.card_color_id = "color_{0}".format([color])
	card_flintlockcrier.card_texture_path = "external/sprites/cards/cengkih/09_flintlockcrier.png"
	card_flintlockcrier.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_flintlockcrier.card_description = "Return up to [max_card_amount] cards from your discard pile to your hand. Rattle them. You gain [energy_amount]{0}.".format([Card.ENERGY_ICON_KEYWORD])
	card_flintlockcrier.card_keyword_object_ids = ["keyword_rattle"]
	card_flintlockcrier.card_type = CardData.CARD_TYPES.SKILL
	card_flintlockcrier.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_flintlockcrier.card_requires_target = false
	card_flintlockcrier.card_energy_cost = 3
	card_flintlockcrier.card_influence = 4
	card_flintlockcrier.card_values = {"min_card_amount":0,"max_card_amount":3,"energy_amount":2}
	card_flintlockcrier.card_upgrade_value_improvements = {"max_card_amount":1}
	card_flintlockcrier.card_play_actions = [
		{
			Scripts.ACTION_ADD_ENERGY:{}
		},
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose up to {0} card(s) to return to hand. {1} cards selected",
				"action_data": [
				{
					Scripts.ACTION_CHANGE_CARD_INFLUENCE: {"card_influence":-1}
				},
				{
					Scripts.ACTION_ADD_CARDS_TO_HAND: {}
				}]
			}
		}
	]
	card_flintlockcrier.card_play_actions.append(influence_action)
	card_flintlockcrier.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_flintlockcrier)
	
	var card_cunningeyedguard: CardData = CardData.new("card_cunningeyedguard")
	card_cunningeyedguard.card_name = "Cunning-Eyed Guard"
	card_cunningeyedguard.card_color_id = "color_{0}".format([color])
	card_cunningeyedguard.card_texture_path = "external/sprites/cards/cengkih/10_cunningeyedguard.png"
	card_cunningeyedguard.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_cunningeyedguard.card_description = "Discard [min_card_amount] cards, then Explore [damage]{0}.".format([Card.EXPLORE_ICON_KEYWORD])
	card_cunningeyedguard.card_type = CardData.CARD_TYPES.ATTACK
	card_cunningeyedguard.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_cunningeyedguard.card_requires_target = true
	card_cunningeyedguard.card_energy_cost = 2
	card_cunningeyedguard.card_influence = 4
	card_cunningeyedguard.card_values = {"min_card_amount":2,"max_card_amount":2, "damage":7}
	card_cunningeyedguard.card_upgrade_value_improvements = {"damage":3}
	card_cunningeyedguard.card_play_actions = [
		{
			Scripts.ACTION_ATTACK_GENERATOR:{}
		},
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_cards_are_required_for_action": true,
				"random_selection": false,
				"card_pick_type": HandManager.HAND_PILE,
				"card_pick_text": "Choose {0} card(s) to discard. {1} cards selected",
				"action_data": [
				{
					Scripts.ACTION_DISCARD_CARDS:{
						
					}}]
			}
		}
	]
	card_cunningeyedguard.card_play_actions.append(influence_action)
	card_cunningeyedguard.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cunningeyedguard)
	
	var card_cengkihscribe: CardData = CardData.new("card_cengkihscribe")
	card_cengkihscribe.card_name = "Cunning-Eyed Guard"
	card_cengkihscribe.card_color_id = "color_{0}".format([color])
	card_cengkihscribe.card_texture_path = "external/sprites/cards/cengkih/11_cengkihscribe.png"
	card_cengkihscribe.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_cengkihscribe.card_description = "Return [min_card_amount] Scrolls from your discard pile to your hand."
	card_cengkihscribe.card_type = CardData.CARD_TYPES.SKILL
	card_cengkihscribe.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_cengkihscribe.card_requires_target = false
	card_cengkihscribe.card_energy_cost = 2
	card_cengkihscribe.card_influence = 4
	card_cengkihscribe.card_values = {"min_card_amount":3,"max_card_amount":3}
	card_cengkihscribe.card_upgrade_value_improvements = {"min_card_amount":1,"max_card_amount":1}
	card_cengkihscribe.card_play_actions = [
		{
			Scripts.ACTION_ATTACK_GENERATOR:{}
		},
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose {0} card(s) to discard. {1} cards selected",
				"action_data": [
				{
					Scripts.ACTION_ADD_CARDS_TO_HAND:{
						
					}}]
			}
		}
	]
	card_cengkihscribe.card_play_actions.append(influence_action)
	card_cengkihscribe.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cengkihscribe)
	
	var card_intrepidcollector: CardData = CardData.new("card_intrepidcollector")
	card_intrepidcollector.card_name = "Intrepid Collector"
	card_intrepidcollector.card_color_id = "color_{0}".format([color])
	card_intrepidcollector.card_texture_path = "external/sprites/cards/cengkih/12_intrepidcollector.png"
	card_intrepidcollector.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_intrepidcollector.card_description = "Explore [damage]{0}. If you completed an expedition, gain [money_amount]{1}. Tick down Shop Refresh by 2.".format([Card.EXPLORE_ICON_KEYWORD,Card.MONEY_ICON_KEYWORD])
	card_intrepidcollector.card_type = CardData.CARD_TYPES.ATTACK
	card_intrepidcollector.card_rarity = CardData.CARD_RARITIES.UNCOMMON
	card_intrepidcollector.card_requires_target = true
	card_intrepidcollector.card_energy_cost = 1
	card_intrepidcollector.card_influence = 3
	card_intrepidcollector.card_values = {"damage":3,"number_of_attacks":1, "money_amount":2}
	card_intrepidcollector.card_upgrade_value_improvements = {"money_amount":1,"damage":1}
	card_intrepidcollector.card_play_actions = [
		{
			Scripts.ACTION_ADD_REFRESH:{"refresh_amount":-2}
		},
		{
			Scripts.ACTION_ATTACK_GENERATOR:{
				"actions_on_lethal": [{Scripts.ACTION_ADD_MONEY:{}}]
			}
		}
	]
	card_intrepidcollector.card_play_actions.append(influence_action)
	card_intrepidcollector.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_intrepidcollector)
	
	var card_cengkihnoble: CardData = CardData.new("card_cengkihnoble")
	card_cengkihnoble.card_name = "Cengkih Noble"
	card_cengkihnoble.card_color_id = "color_{0}".format([color])
	card_cengkihnoble.card_texture_path = "external/sprites/cards/cengkih/13_cengkihnoble.png"
	card_cengkihnoble.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_cengkihnoble.card_description = "Draw 2 cards. Gain 2{0}. Create 1 Debt.".format([Card.ENERGY_ICON_KEYWORD])
	card_cengkihnoble.card_keyword_object_ids = ["keyword_debt"]
	card_cengkihnoble.card_type = CardData.CARD_TYPES.SKILL
	card_cengkihnoble.card_rarity = CardData.CARD_RARITIES.RARE
	card_cengkihnoble.card_requires_target = false
	card_cengkihnoble.card_energy_cost = 1
	card_cengkihnoble.card_influence = 3
	card_cengkihnoble.card_values = {"draw_count":2,"energy_amount":2,"number_of_cards":1,"card_object_id":"card_debt"}
	card_cengkihnoble.card_upgrade_value_improvements = {"draw_count":1,"energy_amount":1}
	card_cengkihnoble.card_play_actions = [
		{
			Scripts.ACTION_CREATE_CARDS:{
				"action_data": [{Scripts.ACTION_DISCARD_CARDS:{}}]

			},
			Scripts.ACTION_ADD_ENERGY:{},
			Scripts.ACTION_DRAW_GENERATOR:{}
		}
	]
	card_cengkihnoble.card_play_actions.append(influence_action)
	card_cengkihnoble.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_cengkihnoble)
	
	var card_tradingenvoy: CardData = CardData.new("card_tradingenvoy")
	card_tradingenvoy.card_name = "Trading Envoy"
	card_tradingenvoy.card_color_id = "color_{0}".format([color])
	card_tradingenvoy.card_texture_path = "external/sprites/cards/cengkih/14_tradingenvoy.png"
	card_tradingenvoy.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_tradingenvoy.card_description = "Exhaust up to 2 cards in hand to gain [money_amount]{0} each.".format([Card.MONEY_ICON_KEYWORD])
	card_tradingenvoy.card_type = CardData.CARD_TYPES.SKILL
	card_tradingenvoy.card_rarity = CardData.CARD_RARITIES.RARE
	card_tradingenvoy.card_requires_target = false
	card_tradingenvoy.card_energy_cost = 1
	card_tradingenvoy.card_influence = 3
	card_tradingenvoy.card_values = {"max_card_amount": 2, "money_amount": 4}
	card_tradingenvoy.card_upgrade_value_improvements = {"money_amount": 2}
	card_tradingenvoy.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_cards_are_required_for_action": false,
				"random_selection": false,
				"card_pick_type": HandManager.HAND_PILE,
				"card_pick_text": "Choose {0} card(s) to exhaust. {1} cards selected",
				"action_data": [
				{
					Scripts.ACTION_ADD_MONEY:{},
					Scripts.ACTION_EXHAUST_CARDS:{}
				}]
			}
		}
	]
	card_tradingenvoy.card_play_actions.append(influence_action)
	card_tradingenvoy.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_tradingenvoy)
		
	var card_provisionalcaptain: CardData = CardData.new("card_provisionalcaptain")
	card_provisionalcaptain.card_name = "Provisional Captain"
	card_provisionalcaptain.card_color_id = "color_{0}".format([color])
	card_provisionalcaptain.card_texture_path = "external/sprites/cards/cengkih/15_provisionalcaptain.png"
	card_provisionalcaptain.texture_bg_path = "external/sprites/cards/frames/cengkihframe.png"
	card_provisionalcaptain.card_description = "Rattle all cards in discard pile. Wield all Swords in discard pile."
	card_provisionalcaptain.card_keyword_object_ids = ["keyword_rattle","keyword_wield"]
	card_provisionalcaptain.card_type = CardData.CARD_TYPES.SKILL
	card_provisionalcaptain.card_rarity = CardData.CARD_RARITIES.RARE
	card_provisionalcaptain.card_requires_target = false
	card_provisionalcaptain.card_energy_cost = 1
	card_provisionalcaptain.card_influence = 3
	card_provisionalcaptain.card_values = {}
	card_provisionalcaptain.card_upgrade_value_improvements = {}
	card_provisionalcaptain.card_play_actions = [
		{
			Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose up to {0} card(s) to wield. {1} cards selected",
				"validator_data":[{Scripts.VALIDATOR_CARD_ID:[{"card_object_ids":["card_sword"]}]}],
				"action_data": [
				{Scripts.ACTION_PLAY_CARDS:{}}]
				}
			},
			{
			Scripts.ACTION_PICK_CARDS: {
				"min_card_amount": 99,
				"max_card_amount": 99,
				"min_cards_are_required_for_action": false,
				"random_selection": true,
				"card_pick_type": HandManager.DISCARD_PILE,
				"card_pick_text": "Choose up to {0} card(s) to wield. {1} cards selected",
				"validator_data":[{Scripts.VALIDATOR_CARD_RARITY:[{"card_rarities_exclude":[CardData.CARD_RARITIES.GENERATED]}]}],
				"action_data": [
				{Scripts.ACTION_CHANGE_CARD_INFLUENCE:{"card_influence":-1}}]
				}
			},
	]
	card_provisionalcaptain.card_play_actions.append(influence_action)
	card_provisionalcaptain.card_end_of_turn_actions = end_action_data
	Global.register_rod(card_provisionalcaptain)
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
