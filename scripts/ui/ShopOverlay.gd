# Overlay for a shop
extends Control

@onready var card_container: HBoxContainer = $CardContainer
@onready var artifact_container: VBoxContainer = $ArtifactContainer
@onready var trade_container: HBoxContainer = $TradeContainer

@onready var continue_button: Button = $ContinueButton

@onready var map = $%Map

func _ready():
	#Signals.combat_started.connect(_on_combat_started)
	
	Signals.map_location_selected.connect(_on_map_location_selected)
	Signals.shop_opened.connect(_on_shop_opened)
	
	Signals.player_killed.connect(_on_player_killed)
	
	Signals.card_purchased.connect(_on_card_purchased)
	Signals.trade_purchased.connect(_on_trade_purchased)
	Signals.artifact_purchased.connect(_on_artifact_purchased)
	Signals.consumable_purchased.connect(_on_consumable_purchased)
	
	continue_button.button_up.connect(_on_continue_button_up)

func populate_shop() -> void:
	clear_shop()
	
	var shop_data: ShopData = Global.get_shop_at_player_location()
	if shop_data == null:
		shop_data = Global.generate_shop_at_player_location()

	if shop_data != null:
		shop_data.visit_shop()	# ensure the shop is populated
		
		### populate shop cards
		var shop_cards: Array[CardData] = shop_data.shop_cards
		for card_data in shop_cards:
			# create card button asset
			var card_shop_button: BaseShopButton = Scenes.CARD_SHOP_BUTTON.instantiate()
			card_container.add_child(card_shop_button)
			
			# generate action payload
			var card_price: int = shop_data.get_shop_card_price(card_data)
			
			var purchase_card_action_data: Array[Dictionary] = [
				{
				Scripts.ACTION_SHOP_PURCHASE_ITEMS: {
					"card_data": card_data,
					"money_amount": card_price,
					}
				}
			]
			
			var purchase_card_action: BaseAction = ActionGenerator.create_actions(null, null, [], purchase_card_action_data, null)[0]
			
			# initialize button with payload
			card_shop_button.init(purchase_card_action)

		### populate shop trade
		var shop_trade: Array[CardData] = shop_data.shop_trade
		for trade_data in shop_trade:
			# create card button asset
			var card_shop_button: BaseShopButton = Scenes.CARD_SHOP_BUTTON.instantiate()
			trade_container.add_child(card_shop_button)
			
			# generate action payload
			var card_price: int = shop_data.get_shop_card_price(trade_data)
			
			var purchase_card_action_data: Array[Dictionary] = [
				{
				Scripts.ACTION_SHOP_PURCHASE_ITEMS: {
					"card_data": trade_data,
					"money_amount": card_price,
					}
				}
			]
			
			var purchase_card_action: BaseAction = ActionGenerator.create_actions(null, null, [], purchase_card_action_data, null)[0]
			
			# initialize button with payload
			card_shop_button.init(purchase_card_action)
			
		### populate shop artifacts
		var shop_artifacts: Array[ArtifactData] = shop_data.get_shop_artifact_options()
		for artifact_data in shop_artifacts:
			# create artifact button asset
			var artifact_shop_button: BaseShopButton = Scenes.ARTIFACT_SHOP_BUTTON.instantiate()
			artifact_container.add_child(artifact_shop_button)
			
			# generate action payload
			var artifact_id: String = artifact_data.object_id
			var artifact_price: int = shop_data.get_shop_artifact_price(artifact_id)
			
			var purchase_artifact_action_data: Array[Dictionary] = [
				{
				Scripts.ACTION_SHOP_PURCHASE_ITEMS: {
					"artifact_id": artifact_id,
					"money_amount": artifact_price,
					}
				}
			]
			
			var purchase_artifact_action: BaseAction = ActionGenerator.create_actions(null, null, [], purchase_artifact_action_data, null)[0]
			
			# initialize button with payload
			artifact_shop_button.init(purchase_artifact_action)
		
		### populate shop consumables
		for consumable_slot_index in shop_data.shop_consumable_slot_to_consumable_object_id.keys():
			# create consumable button asset
			var trade_shop_button: BaseShopButton = Scenes.TRADE_SHOP_BUTTON.instantiate()
			trade_container.add_child(trade_shop_button)
			
			# generate action payload
			var consumable_object_id: String = shop_data.shop_consumable_slot_to_consumable_object_id[consumable_slot_index]
			var consumable_price: int = shop_data.get_shop_consumable_price(consumable_slot_index)
			
			var purchase_consumable_action_data: Array[Dictionary] = [
				{
				Scripts.ACTION_SHOP_PURCHASE_ITEMS: {
					"consumable_object_id": consumable_object_id,
					"consumable_slot_index": consumable_slot_index,
					"money_amount": consumable_price,
					}
				}
			]
			
			var purchase_consumable_action: BaseAction = ActionGenerator.create_actions(null, null, [], purchase_consumable_action_data, null)[0]
			
			# initialize button with payload
			trade_shop_button.init(purchase_consumable_action)
		

func clear_shop():
	for child in card_container.get_children():
		child.queue_free()
	for child in artifact_container.get_children():
		child.queue_free()
	for child in trade_container.get_children():
		child.queue_free()
	var shop_data: ShopData = Global.get_shop_at_player_location()
	if shop_data != null and shop_data.refresh_shop == true:
		#for i in shop_data.shop_cards:
		#	i.queue_free()
		shop_data.shop_cards.clear()
		#for j in shop_data.shop_trade:
		#	j.queue_free()
		shop_data.shop_trade.clear()
		shop_data.refresh_shop = false
			# ensure the shop is populated
#func _on_combat_started(_event_id: String):
#	visible = false
#	clear_shop()

func _on_shop_opened():
	visible = true
	populate_shop()

func _on_card_purchased(_card_data: CardData):
	_repopulate_shop_after_actions_ended()

func _on_trade_purchased(_card_data: CardData):
	_repopulate_shop_after_actions_ended()
	
func _on_artifact_purchased(_artifact_data: ArtifactData):
	_repopulate_shop_after_actions_ended()

func _on_consumable_purchased(_consumable_object_id: String):
	_repopulate_shop_after_actions_ended()

func _repopulate_shop_after_actions_ended() -> void:
	if ActionHandler.actions_being_performed:
		await ActionHandler.actions_ended
	populate_shop()

func _on_continue_button_up():
	# increment the act and potentially generate a new one
	if Global.is_end_of_act():
		if not Global.is_end_of_run():
			ActionGenerator.generate_next_act()
	
	if not Global.is_end_of_run():
		map.show_map()
	else:
		visible = false
		Signals.run_victory.emit()

func _on_map_location_selected(_location_data: LocationData):
	visible = false

func _on_player_killed(_player: Player):
	clear_shop()
	visible = false
