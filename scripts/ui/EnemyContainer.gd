## Handles containing enemies and spawning them
## Can handle both automatic placement and slot based placement for
## enemies based on EventData.event_enemy_placement_is_automatic positioning type.
extends Control

@onready var automatic_enemy_container: HBoxContainer = $AutomaticEnemyContainer
@onready var positional_enemy_container: Control = $PositionalEnemyContainer

func _ready():
	Signals.run_ended.connect(_on_run_ended)
	Signals.enemy_spawn_requested.connect(_on_enemy_spawn_requested)

func populate_enemies_from_event(event_data: EventData = Global.get_player_event_data(), from_load: bool = false):
	# populates initial enemies from an event
	clear_enemies()
	
	# determine which container to use
	var enemy_container: Control = automatic_enemy_container
	
	if not event_data.event_enemy_placement_is_automatic:
		enemy_container = positional_enemy_container
		
		# check if spawns will be out of bounds
		# spawns will still happen but not go beyond that
		if not event_data.event_enemy_placement_is_automatic:
			if len(event_data.event_enemy_placement_positions) < len(event_data.event_weighted_enemy_object_ids):
				DebugLogger.log_error("EnemyContainer: Enemy spawns \"{0}\" exceed number of positions \"{1}\" in event \"{2}\"".format([
					len(event_data.event_weighted_enemy_object_ids),
					len(event_data.event_enemy_placement_positions),
					event_data.object_id,
				]))
	
	# spawn enemies using random weights
	var enemy_counter: int = 0
	if (!from_load):
		for enemy_weights: Dictionary in event_data.event_weighted_enemy_object_ids:
			var rng_enemy_spawning: RandomNumberGenerator = Global.player_data.get_player_rng("rng_enemy_spawning")
			var weights: Dictionary[Variant, int] = {}
			weights.assign(enemy_weights)
			# get an enemy id
			var enemy_object_id: String = Random.get_weighted_selection(rng_enemy_spawning, weights)
			
			# stop spawning when positions exceeded
			if not event_data.event_enemy_placement_is_automatic:
				if len(event_data.event_enemy_placement_positions) <= enemy_counter:
					break
			
			if event_data.event_enemy_placement_is_automatic:
				var _enemy: Enemy = _spawn_enemy(enemy_object_id, enemy_container)
			else:
				var _enemy: Enemy = spawn_enemy_at_slot(enemy_object_id, enemy_counter)
			
			enemy_counter += 1
	else:
		for enemy in Global.player_data.current_enemies:
			var _enemy: Enemy = _load_enemy(enemy)

## Helper function for spawning enemies. Supplied a container for either automatic placement or
## positional placement depending on the event.
func _spawn_enemy(enemy_object_id: String, container: Control = automatic_enemy_container) -> Enemy:
	
	var enemy: Enemy = Scenes.ENEMY.instantiate()
	var enemy_data: EnemyData = Global.get_enemy_data_from_prototype(enemy_object_id)
	
	enemy_data.apply_enemy_difficulty_modifiers()
	enemy_data.randomize_health(true)
	
	container.add_child(enemy)
	enemy.init(enemy_data)
	
	return enemy
	
## Helper function for spawning enemies. Supplied a container for either automatic placement or
## positional placement depending on the event.
func _load_enemy(en_data: EnemyData, container: Control = automatic_enemy_container) -> Enemy:
	
	var enemy: Enemy = Scenes.ENEMY.instantiate()
	var enemy_data: EnemyData = en_data
	
	#enemy_data.apply_enemy_difficulty_modifiers()
	#enemy_data.randomize_health(true)
	
	container.add_child(enemy)
	enemy.init(enemy_data)
	
	return enemy

func spawn_enemy_at_slot(enemy_object_id: String, slot_id: int) -> Enemy:
	var enemy: Enemy = _spawn_enemy(enemy_object_id, positional_enemy_container)
	enemy.enemy_slot = slot_id
	
	# determine non automatic enemy position
	var event_data: EventData = Global.get_player_event_data()
	if len(event_data.event_enemy_placement_positions) > slot_id:
		var pos: Array = event_data.event_enemy_placement_positions[slot_id]
		var enemy_position: Vector2 = Vector2(pos[0], pos[1])
		enemy.position = enemy_position
	else:
		DebugLogger.log_error("EnemyContainer: Spawn slot at index \"{0}\" undefined in event \"{1}\"".format([slot_id, event_data.object_id]))
	
	return enemy

func clear_enemies():
	for child in automatic_enemy_container.get_children():
		child.queue_free()
	for child in positional_enemy_container.get_children():
		child.queue_free()

func get_enemies() -> Array[EnemyData]:
	var saved_enemy_data: Array[EnemyData] = []
	for enemy in automatic_enemy_container.get_children():
		saved_enemy_data.append(enemy.enemy_data)
		print(enemy.enemy_data.object_id)
	for enemy in positional_enemy_container.get_children():
		saved_enemy_data.append(enemy.enemy_data)
	return saved_enemy_data
	
func _on_enemy_spawn_requested(enemy_object_id: String, slot_id: int):
	spawn_enemy_at_slot(enemy_object_id, slot_id)

func _on_run_ended():
	clear_enemies()
