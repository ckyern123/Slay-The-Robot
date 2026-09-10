## Generates the world map for an act. This is called at the start of a run and end of an act.
## See: ActionGenerator.generate_act() and generate_next_act()
## Changing this script and its params should be sufficient for most use cases,
## however you can supply different scripts to an ActData.act_action_script_path if you need multiple
## generation algorithms.
extends BaseAction

const plane_len = 60
const node_count = plane_len * plane_len / 15
const path_count = 15

const map_scale = 20.0

func perform_action() -> void:
	# generates all world locations from a seed and stores them in PlayerData
	var action_interceptor_processors: Array[ActionInterceptorProcessor] = _intercept_action([])
	for action_interceptor_processor in action_interceptor_processors:
		### Set rng seed
		var rng_name: String = action_interceptor_processor.get_shadowed_action_values("rng_name", "rng_world_generation") # allows using different rng
		var rng_world_generation: RandomNumberGenerator = Global.player_data.get_player_rng(rng_name)
		
		### Get the read only act data to determine additional generation
		var act_id: String = get_action_value("act_id", "")
		var act_data: ActData = Global.get_act_data(act_id)
		var act_number: int = get_action_value("act_number", Global.player_data.player_act)
		
		## Set player act to new act
		Global.player_data.player_act_id = act_id
		Global.player_data.player_act = act_number
		

		### parameters of grid
		var floors_per_act: int = action_interceptor_processor.get_shadowed_action_values("floors_per_act", 12)
		var locations_per_floor: int = action_interceptor_processor.get_shadowed_action_values("locations_per_floor", 3)
		generate(plane_len, node_count,path_count)
		var location_obfuscation_rate: float = action_interceptor_processor.get_shadowed_action_values("location_obfuscation_rate", 0) # how often locations will be obfuscated
		var location_non_combat_event_rate: float = action_interceptor_processor.get_shadowed_action_values("location_non_combat_event_rate", 0) # how often locations will be a non combat event
		
		var generate_start_node: bool = act_number == 1
		const MIDDLE: int = 400
		const GRID_SPACING: int = 100	# distance between locations
		var BOTTOM: int = (floors_per_act + 1) * GRID_SPACING
		
		var MIDDLE_INDEX: int = (locations_per_floor - 1) / 2
		var BOTTOM_LEFT: Vector2 = Vector2(MIDDLE - (GRID_SPACING * MIDDLE_INDEX), BOTTOM)
		
		### vars used for generation
		var location_position: Vector2 = BOTTOM_LEFT # current position in grid
		var floors: Array[Array] = [] # stores all generated locations in layers
		var total_locations: Dictionary[int,LocationData]= {}
		var location_id_counter: int = 0 # used to generate unique ids
		var floor_counter: int = 0

		var start: bool = true
		for k in Global.player_data.nodes.keys():
					### Generate/get starting node
			if generate_start_node and start:
				Global.clear_locations()
				# creates a new starting node, mainly useful for the first act
				start = false
				# clear existing locations; This isn't strictly necessary but clears up garbage
				#Global.clear_locations()
				var point = Global.player_data.nodes[k]
				var starting_floor: Array[LocationData] = []
				var starting_location: LocationData = LocationData.new()
				# get a unique id and assign it
				starting_location.location_id = "location_0"
				Global.player_data.location_id_to_location_data["location_0"] = starting_location	# store as mapping in Global
				Global.player_data.player_location_id = starting_location.location_id
				# positioning and act
				starting_location.location_act = 1
				starting_location.location_index = Vector2(MIDDLE_INDEX, -1)
				starting_location.location_position = point * map_scale - Vector2(0,200)
				starting_location.location_position.x = 600
				starting_location.location_floor = floor_counter
				# assign a type
				starting_location.location_type = LocationData.LOCATION_TYPES.STARTING
				# assign a random event
				starting_location.icon_texture_path = "external/sprites/locations/start.svg"
				starting_location.location_event_object_id = "event_act_1_easy_plains_1"
				# add node to layer
				starting_floor.append(starting_location)
				floors.append(starting_floor)
				total_locations[k] = starting_location
			else:
				var point = Global.player_data.nodes[k]
				var location: LocationData = LocationData.new()
				# get a unique id and assign it
				location_id_counter += 1
				var location_id: String = ""
				location_id = "location_" + str(act_number) + "_" + str(location_id_counter)
				location.location_id = location_id
				Global.player_data.location_id_to_location_data[location_id] = location	# store as mapping in PlayerData
				# positioning and act
				location.location_act = act_number
				location.icon_texture_path = "external/sprites/locations/plains.svg"
				location.location_index = Vector2(k, 0)

				location.location_position = point * map_scale #- Vector2(0,200)
				location.location_position.x = 25 * point[0]
				total_locations[k] = location

		for path in Global.player_data.paths:
			for i in range(path.size() - 1):
				var index1 = path[i]
				var index2 = path[i+1]
				total_locations[index1].add_child_event(total_locations[index2].location_id)		
		
		### generate each floor
		var location_id: String = ""
		var i: int = 0
		var floor_dict: Dictionary[int,Array] = {}
		var highest_floor: int = floor_recursive(Global.get_location_data("location_0"),act_data, floor_dict,i, 0)
		
		for key in floor_dict.keys():
			for loc in floor_dict[key]:
				loc.location_position.y = (highest_floor - loc.location_floor) * 100
				if (loc.icon_texture_path == "external/sprites/locations/holy-oak.svg"):
					loc.location_position.y = 50
		Global.get_location_data("location_0").location_position.y = highest_floor * 100
		
		
		var all_locations: Array[LocationData] = Global.get_all_act_locations()
		for loc in all_locations:
			if loc.location_next_location_ids.is_empty() and loc.location_event_pool_object_id != act_data.act_boss_event_pool_object_id:
				Global.player_data.location_id_to_location_data.erase(loc.location_id)
		# add node to layer
		#boss_floor.append(boss_location)
		#floors.append(boss_floor)

func floor_recursive(location_data: LocationData, act_data: ActData, floor_dict: Dictionary[int,Array], k: int, prob: int) -> int:
	var prob_later: int = prob
	var highest_floor: int = k
	#print(k)
	#location_data.location_position -= Vector2(0,20*(min(10,k)/2))
	if location_data.location_next_location_ids.is_empty():
		# make a node
		
		# get a unique id and assign it
		location_data.icon_texture_path = "external/sprites/locations/holy-oak.svg"
		location_data.location_floor = k
		# assign a type
		location_data.location_type = LocationData.LOCATION_TYPES.PLAINS
		# assign a boss pool
		location_data.location_event_pool_object_id = act_data.act_boss_event_pool_object_id
		if (!floor_dict.has(k)):
			floor_dict[k] = [location_data]
	elif location_data.location_id != "location_0":
		if (location_data.location_floor < k):
			location_data.location_floor = k
		var chance_array: Array = LocationData.LOCATION_TYPES.values()
		chance_array.pop_back()
		var prob_num: int = randi_range(0,100) + prob
		location_data.location_type = chance_array.pick_random()					
		if k <= 4 or prob_num <55:
			if k > 4:
				prob_later += (5 + k)
			location_data.difficulty = 0
			if location_data.location_type == LocationData.LOCATION_TYPES.PLAINS:
				location_data.icon_texture_path = "external/sprites/locations/plains.svg"
				location_data.tooltip_bbcode = "Plains:\nFood>Ore>Room\nFeatures: Fertilise, Grain, Rock"
				location_data.location_background_texture_path = "external/sprites/backgrounds/plains.png"
				location_data.location_event_pool_object_id = act_data.act_easy_plains_event_pool_object_id
			elif location_data.location_type == LocationData.LOCATION_TYPES.FOREST:
				location_data.location_event_pool_object_id = act_data.act_easy_forest_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/forest.svg"
				location_data.tooltip_bbcode = "Forest:\nMoney>Food>Room\nFeatures: Draft, Fertilise, Root, Spice"
				location_data.location_background_texture_path = "external/sprites/backgrounds/forest.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.COAST:
				location_data.location_event_pool_object_id = act_data.act_easy_coast_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/coast.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/coast.png"
				location_data.tooltip_bbcode = "Coast:\nFood>Money>Insight\nFeatures: Fish, Shop Refresh, Treasure"
			elif location_data.location_type == LocationData.LOCATION_TYPES.SWAMP:
				location_data.location_event_pool_object_id = act_data.act_easy_swamp_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/swamp.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/swamp.png"
				location_data.tooltip_bbcode = "Swamp:\nFood>Insight\nFeatures: Delicacy, Draft, Fertilise, Root"
			elif location_data.location_type == LocationData.LOCATION_TYPES.DESERT:
				location_data.location_event_pool_object_id = act_data.act_easy_desert_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/desert.svg"
				location_data.tooltip_bbcode = "Desert\n:Ore>Money>Insight\nFeatures: Rock, Shop Refresh, Treasure"
				location_data.location_background_texture_path = "external/sprites/backgrounds/desert.png"
		elif k > 3 and prob_num < 100:
			prob_later += 5
			location_data.difficulty = 1
			if location_data.location_type == LocationData.LOCATION_TYPES.PLAINS:
				location_data.location_event_pool_object_id = act_data.act_medium_plains_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/plains_med.svg"
				location_data.tooltip_bbcode = "Plains Medium:\nFood>Ore>Room\nFeatures: Fertilise, Grain, Rock"
				location_data.location_background_texture_path = "external/sprites/backgrounds/plains.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.FOREST:
				location_data.tooltip_bbcode = "Forest Medium:\nMoney>Food>Room\nFeatures: Draft, Fertilise, Root, Spice"
				location_data.location_event_pool_object_id = act_data.act_medium_forest_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/forest_med.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/forest.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.COAST:
				location_data.icon_texture_path = "external/sprites/locations/coast_med.svg"
				location_data.location_event_pool_object_id = act_data.act_medium_coast_event_pool_object_id
				location_data.location_background_texture_path = "external/sprites/backgrounds/coast.png"
				location_data.tooltip_bbcode = "Coast Medium:\nFood>Money>Insight\nFeatures: Fish, Shop Refresh, Treasure"
			elif location_data.location_type == LocationData.LOCATION_TYPES.SWAMP:
				location_data.location_event_pool_object_id = act_data.act_medium_swamp_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/swamp_med.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/swamp.png"
				location_data.tooltip_bbcode = "Swamp Medium:\nFood>Insight\nFeatures: Delicacy, Draft, Fertilise, Root"
			elif location_data.location_type == LocationData.LOCATION_TYPES.DESERT:
				location_data.location_event_pool_object_id = act_data.act_medium_desert_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/desert_med.svg"
				location_data.tooltip_bbcode = "Desert Medium\n:Ore>Money>Insight\nFeatures: Rock, Shop Refresh, Treasure"
				location_data.location_background_texture_path = "external/sprites/backgrounds/desert.png"
		else:
			prob_later = 0
			location_data.difficulty = 2
			if location_data.location_type == LocationData.LOCATION_TYPES.PLAINS:
				location_data.location_event_pool_object_id = act_data.act_hard_plains_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/plains_hard.svg"
				location_data.tooltip_bbcode = "Plains Hard:\nFood>Ore>Room\nFeatures: Fertilise, Grain, Rock"
				location_data.location_background_texture_path = "external/sprites/backgrounds/plains.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.FOREST:
				location_data.tooltip_bbcode = "Forest Hard:\nMoney>Food>Room\nFeatures: Draft, Fertilise, Root, Spice"
				location_data.location_event_pool_object_id = act_data.act_hard_forest_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/forest_hard.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/forest.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.COAST:
				location_data.icon_texture_path = "external/sprites/locations/coast_hard.svg"
				location_data.tooltip_bbcode = "Coast Hard:\nFood>Money>Insight\nFeatures: Fish, Shop Refresh, Treasure"		
				location_data.location_event_pool_object_id = act_data.act_hard_coast_event_pool_object_id
				location_data.location_background_texture_path = "external/sprites/backgrounds/coast.png"
			elif location_data.location_type == LocationData.LOCATION_TYPES.SWAMP:
				location_data.location_event_pool_object_id = act_data.act_hard_swamp_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/swamp_hard.svg"
				location_data.location_background_texture_path = "external/sprites/backgrounds/swamp.png"
				location_data.tooltip_bbcode = "Swamp Hard:\nFood>Insight\nFeatures: Delicacy, Draft, Fertilise, Root"
			elif location_data.location_type == LocationData.LOCATION_TYPES.DESERT:
				location_data.location_event_pool_object_id = act_data.act_hard_desert_event_pool_object_id
				location_data.icon_texture_path = "external/sprites/locations/desert_hard.svg"
				location_data.tooltip_bbcode = "Desert Hard\n:Ore>Money>Insight\nFeatures: Rock, Shop Refresh, Treasure"
				location_data.location_background_texture_path = "external/sprites/backgrounds/desert.png"
	for child in location_data.location_next_location_ids:
		var location_child = Global.get_location_data(child)
		if (!floor_dict.has(k+1)):
			floor_dict[k+1] = [location_child]
		elif (!floor_dict[k+1].has(location_child)):
			floor_dict[k+1].append(location_child)
		if (k > 50) or location_data.location_id == child:
			break
		var floor_num: int = floor_recursive(location_child,act_data,floor_dict, k+1, prob_later)
		if floor_num > highest_floor:
			highest_floor = floor_num
	return highest_floor
		
func generate(plane_len, node_count, path_count):
	# make sure that we are not going to generate the same map every time
	randomize()
	
	# step 1: generating points on a grid randomly
	var points = []
	points.append(Vector2(plane_len/2, plane_len))
	points.append(Vector2(plane_len/2, 0))
		
	var center = Vector2(plane_len / 2, plane_len/2)
	for i in range(node_count):
		while true:
			var point = Vector2(randi() % plane_len, randi() % plane_len)
			
			var dist_from_center = (point - center).length_squared()
			# only accept points insode of a circle
			var in_circle = dist_from_center <= plane_len * plane_len / 4
			if not points.has(point) and in_circle:
				points.append(point)
				break
	
	# step 2: connect all the points into a graph without intersecting edges
	var pool = PackedVector2Array(points)
	var triangles = Geometry2D.triangulate_delaunay(pool)
	
	# step 3: finding paths from start to finish using A*
	var astar = AStar2D.new()
	for i in range(points.size()):
		astar.add_point(i, points[i])
	
	for i in range(triangles.size() / 3):
		var p1 = triangles[i * 3]
		var p2 = triangles[i * 3 + 1]
		var p3 = triangles[i * 3 + 2]
		if not astar.are_points_connected(p1, p2):
			astar.connect_points(p1, p2)
		if not astar.are_points_connected(p2, p3):
			astar.connect_points(p2, p3)
		if not astar.are_points_connected(p1, p3):
			astar.connect_points(p1, p3)
	
	var paths = []
	
	for i in range(path_count):
		var id_path = astar.get_id_path(0, 1)
		if id_path.size() == 0:
			break
		
		paths.append(id_path)
		
		# step 4: removing nodes / generating unique path every time
		for j in range(randi() % 2 + 1):
			# index between 1 and id_path.size() - 2 (inclusive)
			var index = randi() % (id_path.size() - 2) + 1
			
			var id = id_path[index]
			astar.set_point_disabled(id)
	
	Global.player_data.set_paths(paths, points)
