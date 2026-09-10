extends Node2D
const margin: int = 20
@onready var animation_player: AnimationPlayer = $LineAnimation
var location_data: LocationData = null
# Called when the node enters the scene tree for the first time.
func init(loc_data: LocationData):
	location_data = loc_data
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _draw():
	#if (location_data.difficulty == 0):
		#draw_circle(Vector2.ZERO, 1, Color.WHITE)
	if (location_data.difficulty == 1):
		draw_circle(Vector2.ZERO, 5, Color.PURPLE)
	elif (location_data.difficulty == 2):
		draw_circle(Vector2.ZERO, 9, Color.RED)
	for id in location_data.location_next_location_ids:
		var child = Global.get_location_data(id)
		if (child != null):
			var line = (child.location_position) - (location_data.location_position)
			var normal = line.normalized()
			line -= margin * normal
			var color = Color.WHITE
			draw_dashed_line(normal * margin, line, color, 4, 12, true)

func play_animation():
	animation_player.play("flash_map_location")
