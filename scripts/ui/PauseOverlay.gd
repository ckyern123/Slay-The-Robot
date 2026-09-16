extends Control

@onready var resume_button: Button = %ResumeButton
@onready var return_to_title_button: Button = %ReturnToTitleButton
@onready var forfeit_run_button: Button = %ForfeitRunButton
@onready var pause_button: TextureButton = %PauseButton
@onready var map: Control = %Map
@onready var card_selection_overlay: Control = %CardSelectionOverlay

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	return_to_title_button.pressed.connect(_on_return_to_title_button_pressed)
	forfeit_run_button.pressed.connect(_on_forfeit_run_button_pressed)
	
	Signals.run_started.connect(_on_run_started)
	Signals.run_ended.connect(_on_run_ended)
	
	Signals.game_paused.connect(_on_game_paused)
	Signals.game_unpaused.connect(_on_game_unpaused)

func _process(delta: float) -> void:
	if Input.is_action_just_released("escape") and Global.is_run:
		if pause_button._is_game_pausable():
			if !pause_button.disabled:
				pause_button._on_pause_button_pressed()
			elif Global.is_run:
				Global.unpause_game()
		elif (map.visible):
			map._on_back_button_up()
		elif (card_selection_overlay.visible and card_selection_overlay.can_back_out()):
			card_selection_overlay._on_back_button_up()
		
func _on_run_started():
	visible = false
	
func _on_run_ended():
	visible = false
	

func _on_resume_button_pressed() -> void:
	Global.unpause_game()

func _on_return_to_title_button_pressed() -> void:
	Global.unpause_game()
	Global.end_run(Global.RUN_ENDS.QUIT)

func _on_forfeit_run_button_pressed() -> void:
	Global.unpause_game()
	Global.end_run(Global.RUN_ENDS.LOSS)

func _on_game_paused() -> void:
	visible = true

func _on_game_unpaused() -> void:
	visible = false
