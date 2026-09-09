extends TextureButton
class_name MapLocation

const margin: int = 20
var location_data: LocationData = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var map_label: Label = $MapLabel

signal map_location_button_up(map_location: MapLocation)

func _ready():
	button_up.connect(_on_button_up)

func init(_location_data: LocationData):
	location_data = _location_data
	position = location_data.location_position - Vector2(32,32)
	texture_normal = FileLoader.load_texture(_location_data.icon_texture_path)
	# display the type of location
	if location_data.location_obfuscated and not location_data.location_visited:
		map_label.text = "???" # unvisited obfuscated locations are marked hidden
	else:
		map_label.text = LocationData.LOCATION_TYPES.keys()[location_data.location_type]
	_draw()
func flash_location() -> void:
	animation_player.play("flash_map_location")

func _on_button_up():
	location_data.location_visited = true
	map_location_button_up.emit(self)

func _draw():
	draw_circle(Vector2.ZERO, 4, Color.WHITE)
	
	for id in location_data.location_next_location_ids:
		var child = Global.get_location_data(id)
		var line = (child.location_position) - (location_data.location_position)
		var normal = line.normalized()
		line -= margin * normal
		var color = Color.GRAY
		draw_line(normal * margin, line, color, 2, true)
