# maintains combat UI
extends Control

const FONT_SIZE: int = 24	
const EMBEDDED_IMAGE_SIZE: int = 36

@onready var money_label: RichTextLabel = %MoneyLabel
@onready var food_label: RichTextLabel = %FoodLabel
@onready var ore_label: RichTextLabel = %OreLabel
@onready var insight_label: RichTextLabel = %InsightLabel
@onready var sprawl_label: RichTextLabel = %SprawlLabel
@onready var room_label: RichTextLabel = %RoomLabel
@onready var objectives_label: RichTextLabel = %ObjectivesLabel

@onready var shop_refresh_label: RichTextLabel = %ShopRefreshLabel
@onready var rot_label: RichTextLabel = %RotLabel
@onready var food_fade_container: Node2D = %FoodFadeContainer
@onready var money_fade_container: Node2D = %MoneyFadeContainer
@onready var ore_fade_container: Node2D = %OreFadeContainer
@onready var insight_fade_container: Node2D = %InsightFadeContainer
@onready var sprawl_fade_container: Node2D = %SprawlFadeContainer
@onready var room_fade_container: Node2D = %RoomFadeContainer
@onready var refresh_fade_container: Node2D = %RefreshFadeContainer
@onready var rot_fade_container: Node2D = %RotFadeContainer
const money_texture_path = "sprites/rupee.svg"
const food_texture_path = "sprites/oat.svg"
const ore_texture_path = "sprites/ore.svg"
const insight_texture_path = "sprites/scroll.svg"
const sprawl_texture_path = "sprites/village.svg"
const room_texture_path = "sprites/tower.svg"
const refresh_texture_path = "sprites/refresh.svg"
const rot_texture_path = "sprites/rot.svg"

@onready var energy_count: Label = $Energy/EnergyCount
@onready var energy: TextureButton = $Energy
@onready var draw_count: Label = $DrawPile/DrawCount
@onready var discard_count: Label = $DiscardPile/DiscardCount
@onready var exhaust_count: Label = $ExhaustPile/ExhaustCount
@onready var shop_overlay: Control = %ShopOverlay

@onready var deck_button: TextureButton = %DeckButton
@onready var draw_pile_button: TextureButton = %DrawPile
@onready var discard_pile_button: TextureButton = %DiscardPile
@onready var exhaust_pile_button: TextureButton = %ExhaustPile

@onready var card_selection_overlay = $%CardSelectionOverlay

@onready var combat_animation_player: AnimationPlayer = $CombatAnimation
@onready var enemy_container = $EnemyContainer

@onready var player = $Player
@onready var hand = $Hand
@onready var chest = $Chest
@onready var shop = $Shop



@onready var background_button: TextureButton = %BackgroundButton

@onready var end_turn_button: Button = $EndTurnButton
@onready var combat_end_button: TextureButton = $CombatEndButton

var end_turn_object: CombatEndTurn = null

# condition so it doesn't count as turn start on load
@onready var no_need_generate: bool = false
var game_start: bool = true
var elite_is_present: bool = false

func _ready():
	FileLoader.load_texture(money_texture_path)
	FileLoader.load_texture(room_texture_path)
	FileLoader.load_texture(food_texture_path)
	FileLoader.load_texture(ore_texture_path)
	FileLoader.load_texture(insight_texture_path)
	FileLoader.load_texture(sprawl_texture_path)
	FileLoader.load_texture(refresh_texture_path)					
						
	Signals.player_money_changed.connect(_on_player_money_changed)
	Signals.player_food_changed.connect(_on_player_food_changed)
	Signals.player_ore_changed.connect(_on_player_ore_changed)
	Signals.player_sprawl_changed.connect(_on_player_sprawl_changed)
	Signals.player_room_changed.connect(_on_player_room_changed)
	Signals.player_insight_changed.connect(_on_player_insight_changed)
	Signals.player_refresh_changed.connect(_on_player_refresh_changed)
	Signals.enemy_killed.connect(_on_enemy_killed)
	Signals.enemy_death_animation_finished.connect(_on_enemy_death_animation_finished)

	Signals.combat_started.connect(_on_combat_started)
#	Signals.combat_ended.connect(_on_combat_ended)

	Signals.player_turn_started.connect(_on_player_turn_started)
	Signals.player_turn_ended.connect(_on_player_turn_ended)
	Signals.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Signals.enemy_turn_started.connect(_on_enemy_turn_started)
	Signals.player_artifacts_changed.connect(_on_player_artifacts_changed)
	Signals.player_books_changed.connect(_on_player_books_changed)
	Signals.end_turn_requested.connect(_on_end_turn_requested)
	Signals.tween_discard.connect(_on_tween_discard)
	
	end_turn_button.button_up.connect(_on_end_turn_button_up)
	combat_end_button.button_up.connect(_on_combat_end_button_up)
	update_combat_display()
	player.update_player_display(Global.player_data)

	#end_turn_button.gui_input.connect(_on_button_gui_input)
	money_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, money_texture_path, "Money"]) % Global.player_data.player_money
	ore_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, ore_texture_path, "Ore"]) % Global.player_data.player_ore
	insight_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, insight_texture_path, "Insight"]) % Global.player_data.player_insight
	food_label.text = "[img width={0}]{1}[/img] {2}: %s / overhead: %s".format([EMBEDDED_IMAGE_SIZE, food_texture_path, "Food"])  % [Global.player_data.player_food, (HandManager.player_draw.size()+HandManager.player_hand.size()+HandManager.player_discard.size())/10]

	# pile buttons
	deck_button.button_up.connect(_on_deck_button_up)
	draw_pile_button.button_up.connect(_on_draw_pile_button_up)
	discard_pile_button.button_up.connect(_on_discard_pile_button_up)
	exhaust_pile_button.button_up.connect(_on_exhaust_pile_button_up)
	
	# updating pile counts when cards do things
	Signals.card_played.connect(_on_card_played)	# player is playing card
	Signals.card_drawn.connect(_on_card_drawn)
	Signals.card_deck_shuffled.connect(_on_card_deck_shuffled)
	Signals.card_discarded.connect(_on_card_discarded)
	Signals.card_exhausted.connect(_on_card_exhausted)
	
	Signals.energy_changed.connect(_on_energy_changed)
	Signals.card_queue_refunded.connect(_on_card_queue_refunded)
	
	Signals.run_started.connect(_on_run_started)
	Signals.run_ended.connect(_on_run_ended)
	
	Signals.map_location_selected.connect(_on_map_location_selected)
	
	# map back references
	HandManager.card_destination_to_ui_elements[HandManager.DECK] = deck_button
	HandManager.card_destination_to_ui_elements[HandManager.DRAW_PILE] = draw_pile_button
	HandManager.card_destination_to_ui_elements[HandManager.DISCARD_PILE] = discard_pile_button
	HandManager.card_destination_to_ui_elements[HandManager.EXHAUST_PILE] = exhaust_pile_button

func _process(delta:float) -> void:
	if Input.is_action_just_released("end_turn"):
		_on_end_turn_button_up()
	for i in range(1,10):
		if Input.is_action_just_released("card_{0}".format([i])):
			if (HandManager.player_hand.size() >= i):
				HandManager.hand.card_data_to_hand_card[HandManager.player_hand[i-1]].keyboard_attempt()
	if (Input.is_action_just_released("card_10")):
		if (HandManager.player_hand.size() >= 10):
			HandManager.hand.card_data_to_hand_card[HandManager.player_hand[9]].keyboard_attempt()
					
func _on_map_location_selected(location_data: LocationData):
	# determine what to do when the player visits a new location
	var location_type: int = location_data.location_type
	
	#chest.visible = false
	#shop.visible = false
	
	#set_combat_display_visibility(false)
	
	#match location_type:
	#	LocationData.LOCATION_TYPES.COMBAT, LocationData.LOCATION_TYPES.MINIBOSS, LocationData.LOCATION_TYPES.BOSS:
	#		ActionGenerator.generate_combat_start("") # emit empty event to get location's combat event
	#	LocationData.LOCATION_TYPES.TREASURE:
	#		chest.visible = true
	#	LocationData.LOCATION_TYPES.SHOP:
	#		shop.visible = true
	if (location_type != LocationData.LOCATION_TYPES.STARTING):
		ActionGenerator.generate_combat_start("")
	_update_background()
	
	ActionGenerator.generate_location_music_action()

func update_combat_display():
	energy_count.text = str(Global.player_data.player_energy) + "/" + str(Global.player_data.player_energy_max)
	draw_count.text = str(len(HandManager.player_draw))
	discard_count.text = str(len(HandManager.player_discard))
	exhaust_count.text = str(len(HandManager.player_exhaust))
	_on_player_food_changed()
	_on_player_ore_changed()
	_on_player_insight_changed()
	_on_player_money_changed()
	_on_player_sprawl_changed()
	_on_player_room_changed()
	_on_player_refresh_changed()
	_on_player_rot_changed()
		
func _update_background() -> void:
	# set the background if possible
	var background_texture_path: String = ""
	
	var act_id: String = Global.player_data.player_act_id
	var act_data: ActData = Global.get_act_data(act_id)
	var location_data: LocationData = Global.get_player_location_data()
	
	# act background
	if act_data.act_background_texture_path != "":
		background_texture_path = act_data.act_background_texture_path
	# location background
	if location_data.location_background_texture_path != "":
		background_texture_path = location_data.location_background_texture_path
	# event background
	var location_event_object_id: String = location_data.get_location_event_object_id()
	if location_event_object_id != "":
		var event_data: EventData = Global.get_event_data(location_event_object_id)
		if event_data.event_background_texture_path != "":
			background_texture_path = event_data.event_background_texture_path
	
	if background_texture_path != "":
		background_button.texture_normal = FileLoader.load_texture(background_texture_path)
	

func set_combat_display_visibility(display_visibility: bool) -> void:
	energy.visible = display_visibility
	draw_pile_button.visible = display_visibility
	discard_pile_button.visible = display_visibility
	exhaust_pile_button.visible = display_visibility
	end_turn_button.visible = display_visibility

func _on_card_played(_card_play_request: CardPlayRequest):
	update_combat_display()

func _on_card_drawn(_card_data: CardData):
	update_combat_display()

func _on_card_deck_shuffled(_is_reshuffle: bool):
	update_combat_display()

func _on_card_discarded(_card_data: CardData, _is_manual_discard: bool):
	update_combat_display()

func _on_card_exhausted(_card_data: CardData):
	update_combat_display()

func _on_energy_changed():
	update_combat_display()

func _on_card_queue_refunded():
	update_combat_display()

func _on_player_money_changed(_delta: int = 0):
	money_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, money_texture_path, "Money"]) % Global.player_data.player_money
	if (_delta > 0):
		var sound_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/money.mp3"},
		}]
		var sound_actions: Array = ActionGenerator.create_actions(null, null, [], sound_action_data, null)
		ActionHandler.add_actions(sound_actions)
	if (_delta != 0):
		create_image_fade(money_fade_container, FileLoader.load_texture(money_texture_path))
		
func _on_player_ore_changed(_delta: int = 0):
	ore_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, ore_texture_path, "Ore"]) % Global.player_data.player_ore
	if (_delta > 0):
		var sound_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/ore.wav"},
		}]
		var sound_actions: Array = ActionGenerator.create_actions(null, null, [], sound_action_data, null)
		ActionHandler.add_actions(sound_actions)
	if (_delta != 0):
		create_image_fade(ore_fade_container, FileLoader.load_texture(ore_texture_path))		
		
func _on_player_insight_changed(_delta: int = 0):
	insight_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, insight_texture_path, "Insight"]) % Global.player_data.player_insight
	if (_delta>0):
		var sound_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/insight.wav"},
		}]
		var sound_actions: Array = ActionGenerator.create_actions(null, null, [], sound_action_data, null)
		ActionHandler.add_actions(sound_actions)
	if (_delta != 0):
		create_image_fade(insight_fade_container, FileLoader.load_texture(insight_texture_path))	
		
func _on_player_food_changed(_delta: int = 0):
	food_label.text = "[img width={0}]{1}[/img] {2}: %s / overhead %s".format([EMBEDDED_IMAGE_SIZE, food_texture_path, "Food"])  % [Global.player_data.player_food, (HandManager.player_draw.size()+HandManager.player_hand.size()+HandManager.player_discard.size())/10]
	if (_delta > 0):
		var sound_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/food.wav"},
		}]
		var sound_actions: Array = ActionGenerator.create_actions(null, null, [], sound_action_data, null)
		ActionHandler.add_actions(sound_actions)
	if (_delta != 0):
		create_image_fade(food_fade_container, FileLoader.load_texture(food_texture_path))
		
func _on_player_sprawl_changed(_delta: int = 0):
	var calc: int = (HandManager.player_draw.size()+HandManager.player_hand.size()+HandManager.player_discard.size())
	var sprawl: int = Global.player_data.player_size
	if (calc > sprawl):
		sprawl_label.text = "[img width={0}]{1}[/img] {2}: [color=#FF9233]%s / %s[/color]".format([EMBEDDED_IMAGE_SIZE, sprawl_texture_path, "Size"])  % [calc,Global.player_data.player_size]
	else:
		sprawl_label.text = "[img width={0}]{1}[/img] {2}: %s / %s".format([EMBEDDED_IMAGE_SIZE, sprawl_texture_path, "Size"])  % [calc,Global.player_data.player_size]
	if (_delta != 0):
		create_image_fade(sprawl_fade_container, FileLoader.load_texture(sprawl_texture_path))
	update_objectives_label()
	
func _on_player_room_changed(_delta: int = 0):
	room_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, room_texture_path, "Room"])  % Global.player_data.player_room
	if (_delta != 0):
		create_image_fade(room_fade_container, FileLoader.load_texture(room_texture_path))
		
func _on_player_refresh_changed(_delta: int = 0):
	shop_refresh_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, refresh_texture_path, "Shop Refresh"]) % Global.player_data.player_refresh
	if (Global.player_data.player_refresh <= 0):
		var shop_data: ShopData = Global.get_shop_at_player_location()
		if (shop_data == null):
			shop_data = Global.generate_shop_at_player_location()
		shop_data.shop_is_visited = false
		shop_data.refresh_shop = true
		shop_overlay.populate_shop()
		Global.player_data.player_refresh = 4
		shop_refresh_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, refresh_texture_path, "Shop Refresh"]) % Global.player_data.player_refresh
		create_image_fade(refresh_fade_container, FileLoader.load_texture(refresh_texture_path))
		#var current_event = Global.get_player_event_data()
		#enemy_container.populate_enemies_from_event(current_event)

func _on_player_rot_changed(_delta: int = 0):
	rot_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, rot_texture_path, "ROT WARNING"]) % Global.player_data.player_rot
	if (Global.player_data.player_rot <= 0):
		var reduced_value: int = Global.player_data.player_food/randi_range(2,4)
		Global.player_data.add_food(-reduced_value)
		var sound_action_data: Array[Dictionary] = [{
		Scripts.ACTION_PLAY_SOUND: {"audio_path": "external/audio/sounds/rot.wav"},
		}]
		var sound_actions: Array = ActionGenerator.create_actions(null, null, [], sound_action_data, null)
		ActionHandler.add_actions(sound_actions)
		Global.player_data.player_rot = 10
		rot_label.text = "[img width={0}]{1}[/img] {2}: %s".format([EMBEDDED_IMAGE_SIZE, rot_texture_path, "ROT WARNING"]) % Global.player_data.player_rot
		create_image_fade(rot_fade_container, FileLoader.load_texture(rot_texture_path))
		#var current_event = Global.get_player_event_data()
		#enemy_container.populate_enemies_from_event(current_event)
### Deck Buttons

func _on_deck_button_up():
	card_selection_overlay.view_deck()
func _on_draw_pile_button_up():
	card_selection_overlay.view_draw_pile()
func _on_discard_pile_button_up():
	card_selection_overlay.view_discard()
func _on_exhaust_pile_button_up():
	card_selection_overlay.view_exhaust()

### Turn Handling

func _on_enemy_killed(enemy: Enemy):
	var generated_actions: Array[BaseAction] = ActionGenerator.create_actions(enemy, null, [], enemy.enemy_data.enemy_actions_on_death, null)
	ActionHandler.add_actions(generated_actions)
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	if (enemy.enemy_data.enemy_type == EnemyData.ENEMY_TYPES.MINIBOSS):
		elite_is_present = false
		
	if (combat_end_button.visible == false and !elite_is_present):
		combat_end_button.visible = true
	
func _on_enemy_death_animation_finished(_enemy: Enemy):
	# determine if all non minion enemies killed and end combat
	var enemies: Array[Enemy] = []
	enemies.assign(get_tree().get_nodes_in_group("enemies"))
	
	var non_minion_enemies_remain: bool = true
	for enemy in enemies:
		if not enemy.enemy_data.enemy_is_minion:
			non_minion_enemies_remain = false
	
	if non_minion_enemies_remain:
		# wait for actions to finish and end combat
		if ActionHandler.actions_being_performed:
			await ActionHandler.actions_ended
		end_combat()

func _on_combat_started(event_id: String):
	var current_event: EventData = null
	if event_id == "":
		# if no event is provided, it will be derived from the location
		var current_location: LocationData = Global.get_player_location_data()
		current_event = Global.get_player_event_data()
		current_location.location_visited = true
	else:
		current_event = Global.get_event_data(event_id)
	enemy_container.populate_enemies_from_event(current_event, no_need_generate)
	for child in enemy_container.get_children():
		for childer in child.get_children():
			if (childer.enemy_data.enemy_type == EnemyData.ENEMY_TYPES.MINIBOSS):
				elite_is_present = true
	if (game_start):
		start_turn_animation()
	
	if (game_start):
		Global.player_data.player_energy = Global.player_data.player_energy_max
	set_combat_display_visibility(true)

	update_combat_display()
	
#func _on_combat_ended():
	#set_combat_display_visibility(false)
	
## Helper method to cut down on code bloat. Used in player/enemy turn logic to short circuit
## the turn logic if either player or enemies are dead.
func _end_combat_check() -> bool:
	var combat_is_ended: bool = false
	if not Global.are_remaining_enemies():
		end_combat()
	if (HandManager.player_draw.size() + HandManager.player_hand.size() + HandManager.player_discard.size())>= 100:
		end_combat()
		combat_is_ended = true
	if Global.player_data.player_food < 0:
		player.play_death_animation()
		combat_is_ended = true
	return combat_is_ended

func update_objectives_label() -> void:
	var calc: int = (HandManager.player_draw.size()+HandManager.player_hand.size()+HandManager.player_discard.size())
	objectives_label.text = "Victory Objectives:
\nTotal number of cards: {0}/60
\nArtifacts built: {1}/15
\nBooks drafted: {2}/5".format([calc,Global.player_data.player_artifact_count,Global.player_data.player_books])	
	
func _on_player_artifacts_changed() -> void:
	update_objectives_label()

func _on_player_books_changed(delta: int) -> void:
	update_objectives_label()
	
func perform_enemy_turn():
	# generates enemy actions and performs them in order
	var enemies: Array[Enemy] = Global.get_alive_enemies()
	if _end_combat_check():
		return
	
	# Perform start of turn status logic for all enemies
	for enemy: Enemy in enemies:
		if enemy.is_alive():
			enemy.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_ENEMY_TURN)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
	if _end_combat_check():
		return
	
	### Perform intent for all enemies
	for e in enemies:
		# get enemy standard attack data
		var enemy: Enemy = e	# typecast iterator
		var enemy_intent: EnemyIntentData = enemy.enemy_data.get_current_intent()
		
		### perform enemy start of turn statuses
		if enemy.is_alive():
			enemy.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_ENEMY_INTENT)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
		
		### perform intent
		# NOTE: remember these go in reverse order on the stack
		if enemy.is_alive():
			var enemy_actions_data: Array[Dictionary] = []
			var intent_attack_damage: int = 0
			var intent_number_of_attacks: int = 0
			var intent_block: int = 0
			var intent_audio_path: String = ""
			var intent_attack_impact_animation_id: String = ""
			if enemy_intent != null:
				# add custom actions
				enemy_actions_data.assign(enemy_intent.enemy_intent_custom_actions)
				# get attack data
				intent_attack_damage = enemy_intent.enemy_intent_attack_damage
				intent_number_of_attacks = enemy_intent.enemy_intent_number_of_attacks
				intent_block = enemy_intent.enemy_intent_block
				intent_audio_path = enemy_intent.enemy_intent_audio_path
				intent_attack_impact_animation_id = enemy_intent.enemy_intent_attack_impact_animation_id
			
			# add attacks
			if intent_number_of_attacks > 0:
				enemy_actions_data.append(
				{
				Scripts.ACTION_ATTACK_GENERATOR: 
					{
					"damage": intent_attack_damage,
					"number_of_attacks": intent_number_of_attacks,
					"impact_vfx_animation_id": intent_attack_impact_animation_id,
					"time_delay": EnemyData.ENEMY_ATTACK_DELAY,
					"audio_path": intent_audio_path
					}
				})
			
			# add block
			if intent_block > 0:
				enemy_actions_data.append(
					{
					Scripts.ACTION_BLOCK: {
						"block": intent_block,
						"target_override": BaseAction.TARGET_OVERRIDES.PARENT,
						"time_delay": 0.0,
						}
					}
			)
			
			# add reset block action
			enemy_actions_data.append(
			{
			Scripts.ACTION_RESET_BLOCK:  {
				"target_override": BaseAction.TARGET_OVERRIDES.PARENT,
				"time_delay": 0.0
				}
			}
			)
			
			# play intent sound if one exists and no attacks
			if enemy_intent.enemy_intent_audio_path != "" and intent_number_of_attacks == 0:
				ActionGenerator.generate_sound_action(enemy_intent.enemy_intent_audio_path, false)
			
			# perform them and wait
			var enemy_attack_actions: Array = ActionGenerator.create_actions(enemy, null, [player], enemy_actions_data, null)
			ActionHandler.add_actions(enemy_attack_actions)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			# if player is dead stop
			if _end_combat_check():
				return
		
		### Perform enemy end of turn statuses
		if enemy.is_alive():
			enemy.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_INTENT)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
		
		if _end_combat_check():
			return
	
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	
	
	# Perform end of turn status logic for all enemies
	for enemy: Enemy in enemies:
		if enemy.is_alive():
			enemy.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_ENEMY_TURN)
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended

	# all enemies dead
	if _end_combat_check():
		return
	else:
		Signals.enemy_turn_ended.emit()

# loads turn without triggering on_player_start. Called when player reloads the game.
func load_turn():
	_reset_turn_end_queue()
	Global.player_data.player_energy = Global.player_data.player_current_energy
	#Signals.energy_changed.emit()
	shop_overlay.load_shop()
	no_need_generate = false
	update_combat_display()
	
func _on_player_turn_started():
	# prevent player from playing cards manually
	HandManager.set_disable_hand(true)
	
	# first turn actions
	if StatsHandler.get_turn_count() == 1:
		# location initial actions
		var location_data: LocationData = Global.get_player_location_data()
		assert(location_data != null)
		if location_data != null:
			var card_play_request: CardPlayRequest = HandManager.create_card_play_request(null, null, false, true)
			card_play_request.card_data = null
			card_play_request.selected_target = null
			
			# perform location initial actions
			var location_initial_combat_actions: Array[BaseAction] = ActionGenerator.create_actions(player, card_play_request, [], location_data.location_initial_combat_actions, null)
			ActionHandler.add_actions(location_initial_combat_actions)
		
			# wait for first turn actions
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			# perform event initial actions
			var event_data: EventData = Global.get_player_event_data()
			var event_initial_combat_actions: Array[BaseAction] = ActionGenerator.create_actions(player, card_play_request, [], event_data.event_initial_combat_actions, null)
			ActionHandler.add_actions(event_initial_combat_actions)
			
			# wait for first turn actions
			if ActionHandler.actions_being_performed:
				await ActionHandler.actions_ended
			
			if _end_combat_check():
				return

		# combat start consumable actions
		for consumable_slot_index: int in Global.player_data.player_consumable_slot_count:
			var consumable_data: ConsumableData = Global.get_player_consumable_in_slot_index(consumable_slot_index)
			if consumable_data != null:
				if len(consumable_data.consumable_initial_combat_actions) > 0:
					var card_play_request: CardPlayRequest = HandManager.create_card_play_request(null, null, false, true) # generate fake request
					
					# perform initial actions
					var consumable_actions: Array[BaseAction] = ActionGenerator.create_actions(null, card_play_request, [], consumable_data.consumable_initial_combat_actions, null)
					ActionHandler.add_actions(consumable_actions)
	
		# wait for first turn actions
		if ActionHandler.actions_being_performed:
			await ActionHandler.actions_ended
		# if player is dead stop
		if _end_combat_check():
			return
		
		# combat start card actions
		for card_data: CardData in HandManager.player_draw:
			var card_play_request: CardPlayRequest = HandManager.create_card_play_request(card_data, null, true, true) # generate fake request
			
			# perform initial actions
			var card_play_actions: Array[BaseAction] = ActionGenerator.create_actions(player, card_play_request, [], card_data.card_initial_combat_actions, null)
			ActionHandler.add_actions(card_play_actions)
	
		# wait for first turn actions
		if ActionHandler.actions_being_performed:
			await ActionHandler.actions_ended
		# if player is dead stop
		if _end_combat_check():
			return
		Signals.shop_opened.emit()
	else:
		Global.player_data.add_refresh(-1)
		Global.player_data.add_rot(-1)

	# reset energy

	
	# perform pre draw actions
	player.update_incoming_damage_amount(true)
	player.generate_reset_block_action()
	player.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_DRAW_PLAYER_START_TURN)
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	if _end_combat_check():
		return
	
	# draw cards
	if (StatsHandler.turn_count > 1 or game_start):
		ActionGenerator.generate_start_of_turn_energy_actions()
		ActionGenerator.generate_start_of_turn_draw_actions()
		game_start = false
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	# if player is dead stop
	if _end_combat_check():
		return
	
	# perform post draw actions
	player.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DRAW_PLAYER_START_TURN)
	# if player is dead stop
	if _end_combat_check():
		return
	
	# unlock and update hand
	HandManager.set_disable_hand(false)
	hand.update_hand_card_display()
	Global.player_data.current_enemies = enemy_container.get_enemies()
	FileLoader.autosave()
	
func _on_player_turn_ended():
	# prevent player from playing cards
	HandManager.set_disable_hand(true)
	
	# perform all end of turn actions and await
	player.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.PRE_DISCARD_PLAYER_END_TURN)
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	if _end_combat_check():
		return
	
	# discard non retained cards and perform card actions
	HandManager.perform_end_of_turn_hand_actions()
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	if _end_combat_check():
		return
	
	# perform all end of turn actions and await
	player.perform_status_effect_process_actions(StatusEffectData.STATUS_EFFECT_PROCESS_TIMES.POST_DISCARD_PLAYER_END_TURN)
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	if _end_combat_check():
		return

func _on_player_start_turn_animation_finished():
	# called from animation player
	start_turn()

func _on_player_end_turn_animation_finished():
	# called from animation player
	Signals.player_turn_ended.emit()
	
	# wait for all end of turn actions to process
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	
	# start enemy turn if they're alive
	if len(get_tree().get_nodes_in_group("enemies")) > 0:
		Signals.enemy_turn_started.emit()

func _on_enemy_turn_started():
	perform_enemy_turn()
	
func _on_enemy_turn_ended():
	start_turn_animation()
	
func _on_end_turn_button_up():
	queue_end_turn(CombatEndTurn.END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS)

func _on_button_gui_input(event: InputEvent):
	if event.is_action_released("end_turn"):
		_on_end_turn_button_up()
		
func _on_combat_end_button_up():
	#queue_end_turn(CombatEndTurn.END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS)
	end_combat()

func _on_end_turn_requested(immediacy: int):
	queue_end_turn(immediacy)

func queue_end_turn(immediacy: int = CombatEndTurn.END_TURN_QUEUE_IMMEDIACY.WAIT_FOR_ALL_CARD_PLAYS):
	# queues up an end turn, using async objects with priority to determine how to handle it
	if end_turn_object == null:
		end_turn_object = CombatEndTurn.new(self, immediacy)
		end_turn_object.wait()
		end_turn_button.disabled = true
	elif immediacy > end_turn_object.end_turn_queue_value:
		# higher priority end turn, replace the old with a newer one
		end_turn_object.disable()	# stop the old one working
		end_turn_object = CombatEndTurn.new(self, immediacy)
		end_turn_object.wait()

func _reset_turn_end_queue() -> void:
	if end_turn_object != null:
		end_turn_object.disable()
		end_turn_object = null

func _on_tween_discard() -> void:
	var tween = create_tween()
	tween.tween_property(discard_pile_button, "modulate", Color.RED, 0.2).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.2).timeout
	var tween2 = create_tween()
	tween2.tween_property(discard_pile_button, "modulate", Color(1, 1, 1, 1), 0.2).set_trans(Tween.TRANS_SINE)
	
func _on_run_started():
	background_button.texture_normal = FileLoader.load_texture("external/sprites/base_map.jpg")
	visible = true
	_on_player_food_changed()
	_on_player_ore_changed()
	_on_player_refresh_changed()
	_on_player_insight_changed()
	_on_player_money_changed()
	no_need_generate = !Global.player_data.new_game
	
	# load energy
	var character_data: CharacterData = Global.get_player_character_data()
	if character_data != null:
		var color_data: ColorData = Global.get_color_data(character_data.character_color_id)
		if color_data != null:
			energy.texture_normal = FileLoader.load_texture(color_data.color_energy_icon_texture_path)
	
func _on_run_ended():

	visible = false
	_reset_turn_end_queue()
	game_start = true
	combat_end_button.visible = false

#func start_combat() -> void:
	#_reset_turn_end_queue()

## Performs end of combat logic and signals end of combat
func end_combat() -> void:
	var event_data: EventData = Global.get_player_event_data()
	if event_data != null:
		# perform event initial actions
		var event_post_combat_actions: Array[BaseAction] = ActionGenerator.create_actions(player, null, [], event_data.event_post_combat_actions, null)
		ActionHandler.add_actions(event_post_combat_actions)

		if ActionHandler.actions_being_performed:
			await ActionHandler.actions_ended
	
	#_reset_turn_end_queue()
	combat_end_button.visible = false
	Signals.combat_ended.emit()

func end_turn():
	pass

func start_turn():
	# called from animation player
	_reset_turn_end_queue()
	update_combat_display()
	if (!no_need_generate):
		Signals.player_turn_started.emit()
	else:
		load_turn()

func create_image_fade(fade_container: Node2D, texture: Texture) -> void:
	var image_fade: ImageFade = Scenes.IMAGE_PROC_FADE.instantiate()
	fade_container.add_child(image_fade)
	image_fade.init(texture)

func end_turn_animation() -> void:
	_reset_turn_end_queue()
	combat_animation_player.play("end_turn")
	
func start_turn_animation() -> void:
	combat_animation_player.play("start_turn")
