extends BaseShopButton

@onready var button: Button = $Button
@onready var label: RichTextLabel = %ArtifactDescription
@onready var artifact_id: String = ""
func _ready():
	button.button_up.connect(_on_button_up)

func init(_action_on_click: BaseAction) -> void:
	super(_action_on_click)
	
	artifact_id = _action_on_click.values.get("artifact_id", "")
	var artifact_data: ArtifactData = Global.get_artifact_data(artifact_id)
	if artifact_data != null:
		button.text = artifact_data.artifact_name
		label.text = artifact_data.artifact_shop_description
		button.icon = FileLoader.load_texture(artifact_data.artifact_texture_path)
