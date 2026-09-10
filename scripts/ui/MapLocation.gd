extends TextureButton
class_name MapLocation


var location_data: LocationData = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var map_label: Label = $MapLabel
@onready var tooltip_bbcode: String = ""
@onready var line_holder = $LineHolder
signal map_location_button_up(map_location: MapLocation)
signal map_location_hovered(map_location: MapLocation)
signal map_location_unhovered(map_location: MapLocation)
@onready var keyword_timer = $KeywordTimer

const KEYWORD_HOVER_DELAY: float = 0.2

func _ready():
	button_up.connect(_on_button_up)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	keyword_timer.timeout.connect(_on_keyword_timeout)

func init(_location_data: LocationData):
	location_data = _location_data
	tooltip_bbcode = location_data.tooltip_bbcode
	position = location_data.location_position - Vector2(32,32)
	texture_normal = FileLoader.load_texture(_location_data.icon_texture_path)
	# display the type of location
	if location_data.location_obfuscated and not location_data.location_visited:
		map_label.text = "???" # unvisited obfuscated locations are marked hidden
	else:
		map_label.text = LocationData.LOCATION_TYPES.keys()[location_data.location_type]
	line_holder.init(location_data)
	
	#_draw()
func flash_location(yes_lines: bool = false) -> void:

	if (yes_lines):
		line_holder.play_animation()
	else:
		animation_player.play("flash_map_location")
	

func _on_button_up():
	location_data.location_visited = true
	map_location_button_up.emit(self)
	
func _on_mouse_entered():
	keyword_timer.start(KEYWORD_HOVER_DELAY)
	map_location_hovered.emit(self)
	
func _on_mouse_exited():
	keyword_timer.stop()
	HandManager.tooltip.hide_tooltip()
	map_location_unhovered.emit(self)

func _on_keyword_timeout():
	HandManager.tooltip.display_map_location_tooltip(self)
	
func draw_lines():
	line_holder._draw()
