## The tooltip UI component used to display helpful information to the player on hovering over things.
## Displays over everything else.
## NOTE: Modify component_tooltip_data to provide more tooltips and how they display
## Uses ReferenceRects for positioning
extends Control
class_name Tooltip

@onready var pause_button: TextureButton = %PauseButton
@onready var map_button: TextureButton = %MapButton

@onready var money_label: RichTextLabel = %MoneyLabel
@onready var food_label: RichTextLabel = %FoodLabel
@onready var ore_label: RichTextLabel = %OreLabel
@onready var insight_label: RichTextLabel = %InsightLabel
@onready var sprawl_label: RichTextLabel = %SprawlLabel
@onready var room_label: RichTextLabel = %RoomLabel

@onready var energy: TextureButton = %Energy
@onready var deck_button: TextureButton = %DeckButton
@onready var draw_pile_button: TextureButton = %DrawPile
@onready var discard_pile_button: TextureButton = %DiscardPile
@onready var exhaust_pile_button: TextureButton = %ExhaustPile
@onready var end_turn_button: Button = %EndTurnButton
@onready var card_container = $"../RunScreen/Combat/ShopOverlay/CardContainer"
@onready var trade_container = $"../RunScreen/Combat/ShopOverlay/TradeContainer"
@onready var artifact_container = $"../RunScreen/Combat/ShopOverlay/ArtifactContainer"
@onready var shop_refresh = %ShopRefreshLabel
@onready var objectives_label = %ObjectivesLabel 
@onready var panel_container: PanelContainer = $PanelContainer
@onready var tooltip_label: RichTextLabel = $PanelContainer/TooltipLabel
@onready var keyword_container: KeywordContainer = $KeywordContainer
@onready var end_combat_button = %CombatEndButton

var follow_mouse: bool = false # if the tooltip should constantly update its position over the mouse when proc'ed
var lock_x: bool = false # when following mouse, lock x coord to a given offset
var lock_y: bool = false # when following mouse, lock y coord to a given offset
var offset_x: float = 0.0 # offset when following mouse
var offset_y: float = 0.0 # offset when following mouse

const CARD_KEYWORD_PANEL_MARGIN_X: float = 6.0 # how far the tooltip should display away from Card
const CARD_KEYWORD_RIGHT_SCREEN_SIZE_MARGIN: float = 200 # how much screen space must be left on the right side of a card to display the tooltips on the right side

func _ready() -> void:
	HandManager.tooltip = self # store a reference globally for this tooltip. Godot freaks out about it otherwise
	
	# pre-set tooltips
	# [component, bbcode, if it follows mouse, lock x position, lock y position, offset component used for placement]
	var component_tooltip_data: Array[Array] = [
		[pause_button, "[color=orange]Pause[/color]\nStops Game", true, false, true, $TooltipPositions/TopLeftTooltipPos],
		[map_button, "[color=orange]Map[/color]\nOpens map for this act", true, false, true, $TooltipPositions/TopLeftTooltipPos],
		[deck_button, "[color=orange]Deck[/color]\nList of all cards currently owned. Saved between combats", true, false, true, $TooltipPositions/TopLeftTooltipPos],
		
		[food_label, "[color=orange]Food[/color]\nWhen this reaches zero, you lose. /Overhead: Each turn, you lose Food equal to total cards/10", true, false, true, $TooltipPositions/FoodTooltipPos],
		[money_label, "[color=orange]Money[/color]\nHow much money you have. Money is used to purchase cards and fulfil trade orders.", true, false, true, $TooltipPositions/MoneyTooltipPos],
		[ore_label, "[color=orange]Ore[/color]\nHow much Ore you have. Ore is used to forge things and build Artifacts.", true, false, true, $TooltipPositions/OreTooltipPos],
		[insight_label, "[color=orange]Insight[/color]\nHow much Insight you have. Insight is used to weave and cook things. Scrolls are woven things that are used to draft Books.", true, false, true, $TooltipPositions/InsightTooltipPos],
		[sprawl_label, "[color=orange]Size[/color]\nYour kingdom's Size is the amount of cards you can support before it becomes unstable. For every 3 cards that exceed Size, you rattle a card in discard pile at the end of turn.", true, false, true, $TooltipPositions/SprawlTooltipPos],
		[room_label, "[color=orange]Room[/color]\nHow much Room you have. Room is needed to build Artifacts.", true, false, true, $TooltipPositions/RoomTooltipPos],
		[card_container, "[color=orange]Purchase cards[/color]\nPurchase cards. Cards cost Money. You can only purchase one card for each Shop Refresh.", true, false, true, $TooltipPositions/RoomTooltipPos],
		[artifact_container, "[color=orange]Artifacts[/color]\nPurchase an artifact blueprint. To acquire the artifact, play the Blueprint card and pay 8 Ore. You can only purhcase one blueprint per Shop Refresh", true, false, true, $TooltipPositions/ArtifactTooltipPos],
		[trade_container, "[color=orange]Trade orders[/color]\nGain a Trade order card. Play the card to trade resources. Each order can only be used once. You can only gain one Trade order card per Shop Refresh.", true, false, true, $TooltipPositions/TradeTooltipPos],
		[shop_refresh, "[color=orange]Shop Refresh[/color]\nWhen this counter is at zero, the shop is refreshed.", true, false, true, $TooltipPositions/RefreshTooltipPos],
		[objectives_label, "[color=orange]Objectives[/color]\nTo win the game, complete these objectives\nThe total number of cards you have can be seen at the Size counter\nArtifacts are built by purchasing blueprint cards and playing them\n.Books are drafted every three times Scrolls are played.", true, false, true, $TooltipPositions/ObjectivesTooltipPos],
				
		[energy, "[color=orange]Energy[/color]\nUsed to play cards", false, false, false, $TooltipPositions/EnergyTooltipPos],
		[draw_pile_button, "[color=orange]Draw Pile[/color]\nThese cards will be drawn", false, false, false, $TooltipPositions/DrawTooltipPos],
		[exhaust_pile_button, "[color=orange]Exhaust Pile[/color]\nThese cards have been removed from play", false, false, false, $TooltipPositions/ExhaustTooltipPos],	
		[discard_pile_button, "[color=orange]Discard Pile[/color]\nThese cards will be reshuffled back", false, false, false, $TooltipPositions/DiscardTooltipPos],
		[end_turn_button, "[color=orange]End Turn[/color]\nEnds your turn", false, false, false, $TooltipPositions/EndCombatTooltipPos],
		[end_combat_button, "[color=orange]End Combat[/color]\nEnds this combat to visit a new location. You gain this button after completing an expedition.\n If a dangerous expedition is present (represented by the red skull), you need to complete that expedition first before this appears.", false, false, false, $TooltipPositions/EndCombatTooltipPos],
		]
	
	for component_tooltip: Array in component_tooltip_data:
		var component: Control = component_tooltip[0]
		var component_tooltip_bbcode: String = component_tooltip[1]
		var component_tooltip_follow_mouse: bool = component_tooltip[2]
		var component_tooltip_lock_x: bool = component_tooltip[3]
		var component_tooltip_lock_y: bool = component_tooltip[4]
		var component_tooltip_offset: ReferenceRect = component_tooltip[5]
	
		component.mouse_entered.connect(display_tooltip.bind(
			component_tooltip_bbcode,
			component_tooltip_follow_mouse, component_tooltip_lock_x, component_tooltip_lock_y,
			0.0, 0.0,
			component_tooltip_offset)
			)
		component.mouse_exited.connect(hide_tooltip)

## Displays a basic tooltip at a given location with given text.
## If follow_mouse = true, it will constantly repostion the tooltip offset from the mouse, with
## flags to lock the offset for each axis.
## If offset_component is used (see component_tooltip_data in _ready()) you can use a ReferenceRect
## to determine the tooltip's location, good for multiple resolution support.
func display_tooltip(tooltip_bbcode: String,
					_follow_mouse: bool = false, _lock_x: bool = false, _lock_y: bool = false,
					_offset_x: float = 0.0, _offset_y: float = 0.0, offset_component: Control = null) -> void:
	hide_tooltip()
	visible = true
	
	tooltip_label.parse_bbcode(tooltip_bbcode)
	tooltip_label.visible = true
	panel_container.visible = true
	
	follow_mouse = _follow_mouse
	lock_x = _lock_x
	lock_y = _lock_y
	
	if offset_component != null:
		offset_x = offset_component.position.x
		offset_y = offset_component.position.y
	else:
		offset_x = _offset_x
		offset_y = _offset_y
	
	global_position = Vector2(offset_x, offset_y)

## Displays a list of keywords to the left or right of a Card, based on remaining screen size
func display_card_keywords(card: Card) -> void:
	if card.card_data == null:
		return
	hide_tooltip()
	
	visible = true
	keyword_container.visible = true
	
	# use remaining screen size to determine which side of the card should display
	var screen_size: Vector2 = DisplayServer.window_get_size()
	var card_visual_global_pos: Vector2 = card.card_visual.global_position
	var card_right_side_pos: Vector2 = card_visual_global_pos + Vector2(card.size.x + CARD_KEYWORD_PANEL_MARGIN_X, 0)
	var card_left_side_pos: Vector2 = card_visual_global_pos - Vector2(keyword_container.size.x + CARD_KEYWORD_PANEL_MARGIN_X, 0)
	
	if card_right_side_pos.x + CARD_KEYWORD_RIGHT_SCREEN_SIZE_MARGIN < screen_size.x:
		# right side of card
		keyword_container.global_position = card_right_side_pos
	else:
		# left side of card
		keyword_container.global_position = card_left_side_pos
	
	keyword_container.populate_card_keywords(card.card_data)

func display_artifact_tooltip(artifact_description: String) -> void:
	display_tooltip(artifact_description, true, false, false, 0.0, 0.0, null)

func display_codex_artifact_tooltip(artifact_data: ArtifactData) -> void:
	if artifact_data != null:
		var rarity_text: String = "\n"
		if len(artifact_data.ARTIFACT_RARITIES.keys()) > artifact_data.artifact_rarity:
			rarity_text += "[" + artifact_data.ARTIFACT_RARITIES.keys()[artifact_data.artifact_rarity] + "]"
		
		var artifact_tooltip_bbcode: String = "[color=orange]{0}[/color]{1}\n{2}".format([
			artifact_data.artifact_name, rarity_text, artifact_data.artifact_description
		])
		display_tooltip(artifact_tooltip_bbcode, true, false, false, 0.0, 0.0, null)

func display_codex_consumable_tooltip(consumable_data: ConsumableData) -> void:
	if consumable_data != null:
		var rarity_text: String = "\n"
		if len(consumable_data.CONSUMABLE_RARITIES.keys()) > consumable_data.consumable_rarity:
			rarity_text += "[" + consumable_data.CONSUMABLE_RARITIES.keys()[consumable_data.consumable_rarity] + "]"
		
		var consumable_tooltip_bbcode: String = "[color=orange]{0}[/color]{1}\n{2}".format([
			consumable_data.consumable_name, rarity_text, consumable_data.consumable_description
		])
		display_tooltip(consumable_tooltip_bbcode, true, false, false, 0.0, 0.0, null)

func hide_tooltip() -> void:
	follow_mouse = false
	lock_x = false
	lock_y = false
	offset_x = 0.0
	offset_y = 0.0
	
	keyword_container.clear_keywords()
	visible = false
	tooltip_label.visible = false
	panel_container.visible = false
	keyword_container.visible = false
	

func _process(_delta: float) -> void:
	if follow_mouse:
		if lock_x:
			global_position.x = offset_x
		else:
			global_position.x = get_global_mouse_position().x
		if lock_y:
			global_position.y = offset_y
		else:
			global_position.y = get_global_mouse_position().y
			
