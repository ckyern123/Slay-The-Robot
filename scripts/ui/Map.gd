extends Control

@onready var scroll_container = $ScrollContainer
@onready var location_container = $ScrollContainer/LocationContainer
@onready var back_button: Button = $BackButton

@onready var map_button = %MapButton
@onready var map_label = %MapLabel

var can_travel: bool = false	# if clicking on a location brings you to the next location

## Adds a margin to the bottom of the map display
const MAP_Y_MARGIN: float = 300
#const MAP_X_MARGIN: float = 0
func _process(delta:float) -> void:
	if Input.is_action_just_released("escape"):
		_on_back_button_up()

func _ready():
	map_button.button_up.connect(_on_map_button_up)
	back_button.button_up.connect(_on_back_button_up)
	
	Signals.combat_started.connect(_on_combat_started)
	Signals.combat_ended.connect(_on_combat_ended)
	
	Signals.player_killed.connect(_on_player_killed)
	Signals.dialogue_ended.connect(_on_dialogue_ended)
	
	Signals.chest_opened.connect(_on_chest_opened)
	Signals.shop_opened.connect(_on_shop_opened)
	
	Signals.map_location_selected.connect(_on_map_location_selected)
	#map_label.text = "Plains:Food>Ore>Room\nFeatures: Fertilise, Grain, Rock
	#\nDesert:Ore>Money>Insight\nFeatures: Rock, Shop Refresh, Treasure
	#\nCoast:Food>Money>Insight\nFeatures: Fish, Shop Refresh, Treasure
	#\nForest:Money>Food>Room\nFeatures: Draft, Fertilise, Root, Spice
	#\nSwamp:Food>Insight\nFeatures: Delicacy, Draft, Fertilise, Root"
#
	#map_label.text = modified_description_bb_code
func populate_locations(locations: Array[LocationData] = Global.get_all_act_locations()):
	clear_locations()
	
	var next_locations: Array[LocationData] = Global.get_next_locations()
	var max_y: float = 0 # the highest location position, used to determine container size

	var current_map_location: MapLocation = null
	
	for location_data in locations:
		var map_location: MapLocation = Scenes.MAP_LOCATION.instantiate()
		location_container.add_child(map_location)
		map_location.init(location_data)
		if location_data.location_type == LocationData.LOCATION_TYPES.STARTING:
			map_location.disabled = true		
		
		map_location.map_location_button_up.connect(_on_map_location_button_up)
		#map_location.position += Vector2(0,200)
		max_y = max(max_y, location_data.location_position.y)

		# flash the locations the player can travel to
		if can_travel:
			if next_locations.has(location_data):
				map_location.flash_location(false)
				current_map_location = map_location
			if location_data == Global.get_player_location_data():
				map_location.flash_location(true)
		
		if location_data == Global.get_player_location_data():
			current_map_location = map_location

	# set the size of the container to make scrolling posible
	location_container.custom_minimum_size.y = max_y + MAP_Y_MARGIN
	location_container.size.y = max_y + MAP_Y_MARGIN
	# wait a frame to ensure container is properly resized
	await Global.get_tree().process_frame
	
	# set the scroll
	if current_map_location!= null and current_map_location.location_data.location_id != "location_0":
		print("GRABBED FOCUS")
		current_map_location.grab_focus()
		scroll_container.scroll_vertical = max_y

	else:
		print("DID NOT GRAB FOCUS")
		## presumably the invisible starting location, set to bottom
		scroll_container.scroll_vertical = max_y
	if (Global.player_data.first_time):
		Global.player_data.first_time = false
		# BAND-AID FOR MISMATCHED SCROLLING CONTAINER THE FIRST TIME
		populate_locations(locations)


func clear_locations() -> void:
	for child in location_container.get_children():
		child.queue_free()

func show_map():
	populate_locations()
	visible = true

func hide_map():
	visible = false

func _on_map_button_up():
	show_map()

func _on_map_location_button_up(map_location: MapLocation):
	# map must be in travel mode
	if can_travel:
		# must be adjacent to player location
		if Global.get_next_locations().has(map_location.location_data):
			# visit the location
			ActionGenerator.generate_visition_location(map_location.location_data.location_id)
	
func _on_map_location_selected(location_data: LocationData):
	# disable travel mode
	can_travel = false
	hide_map()

func _on_combat_started(_event_id: String):
	can_travel = false

func _on_combat_ended():
	can_travel = true

func _on_player_killed(_player: Player) -> void:
	hide_map()
	clear_locations()

func _on_chest_opened():
	can_travel = true

func _on_shop_opened():
	can_travel = false

func _on_dialogue_ended():
	var player: Player = Global.get_player()
	if player.is_alive():
		can_travel = true
		show_map()
	else:
		hide_map()

func _on_back_button_up():
	hide_map()
	get_combined_minimum_size()
