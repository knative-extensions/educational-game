extends Node

# Audio players for different sound effects
var click_start_player: AudioStreamPlayer
var click_end_player: AudioStreamPlayer
var construction_player: AudioStreamPlayer  # Loops continuously!
var poof_player: AudioStreamPlayer
var level_clear_player: AudioStreamPlayer
var level_fail_player: AudioStreamPlayer

# Sound enabled flag
var sound_enabled = true

# Volume settings
var construction_normal_volume = -10
var construction_ducked_volume = -20
var is_construction_playing = false

func _ready():
	# Create audio players
	click_start_player = AudioStreamPlayer.new()
	click_end_player = AudioStreamPlayer.new()
	construction_player = AudioStreamPlayer.new()
	poof_player = AudioStreamPlayer.new()
	level_clear_player = AudioStreamPlayer.new()
	level_fail_player = AudioStreamPlayer.new()
	
	# Add them as children
	add_child(click_start_player)
	add_child(click_end_player)
	add_child(construction_player)
	add_child(poof_player)
	add_child(level_clear_player)
	add_child(level_fail_player)
	
	# Load sound files
	click_start_player.stream = load("res://SoundEffects/sfx_click_start.wav")
	click_end_player.stream = load("res://SoundEffects/sfx_click_end.wav")
	construction_player.stream = load("res://SoundEffects/sfx_construction.wav")
	poof_player.stream = load("res://SoundEffects/sfx_poof.wav")
	level_clear_player.stream = load("res://SoundEffects/sfx_level_clear.wav")
	level_fail_player.stream = load("res://SoundEffects/sfx_level_fail.wav")
	
	# Set volume levels
	click_start_player.volume_db = -5
	click_end_player.volume_db = -5
	construction_player.volume_db = construction_normal_volume
	poof_player.volume_db = 0
	level_clear_player.volume_db = 5
	level_fail_player.volume_db = 5
	
	print("AudioManager initialized successfully")

# Start construction sound loop
func start_construction_loop():
	if sound_enabled and not is_construction_playing and construction_player.stream:
		print("Starting construction loop...")
		is_construction_playing = true
		
		# Connect to finished signal to loop manually
		if not construction_player.finished.is_connected(_on_construction_finished):
			construction_player.finished.connect(_on_construction_finished)
		
		construction_player.volume_db = construction_normal_volume
		construction_player.play()
		print("Construction sound should be playing now")

# Manual loop replay when finished
func _on_construction_finished():
	if is_construction_playing:
		construction_player.play()

# Stop construction sound
func stop_construction_loop():
	if is_construction_playing:
		print("Stopping construction loop...")
		is_construction_playing = false
		
		# Fade out
		var tween = create_tween()
		tween.tween_property(construction_player, "volume_db", -80, 0.5)
		await tween.finished
		
		construction_player.stop()
		construction_player.volume_db = construction_normal_volume

# Duck construction sound (make quieter)
func duck_construction():
	if is_construction_playing:
		var tween = create_tween()
		tween.tween_property(construction_player, "volume_db", construction_ducked_volume, 0.2)

# Restore construction sound
func restore_construction():
	if is_construction_playing:
		var tween = create_tween()
		tween.tween_property(construction_player, "volume_db", construction_normal_volume, 0.3)

# Play sound functions
func play_click_start():
	if sound_enabled and click_start_player.stream:
		duck_construction()
		click_start_player.play()
		await get_tree().create_timer(0.3).timeout
		restore_construction()

func play_click_end():
	if sound_enabled and click_end_player.stream:
		duck_construction()
		click_end_player.play()
		await get_tree().create_timer(0.3).timeout
		restore_construction()

func play_construction():
	print("play_construction() called")
	start_construction_loop()

func play_poof():
	if sound_enabled and poof_player.stream:
		duck_construction()
		poof_player.play()
		await get_tree().create_timer(0.5).timeout
		restore_construction()

func play_level_clear():
	if sound_enabled and level_clear_player.stream:
		stop_construction_loop()
		level_clear_player.play()

func play_level_fail():
	if sound_enabled and level_fail_player.stream:
		stop_construction_loop()
		level_fail_player.play()

func toggle_sound():
	sound_enabled = !sound_enabled
	if not sound_enabled:
		stop_construction_loop()
	print("Sound enabled: ", sound_enabled)

func set_volume(db: float):
	click_start_player.volume_db = db - 5
	click_end_player.volume_db = db - 5
	construction_normal_volume = db - 10
	construction_ducked_volume = db - 20
	poof_player.volume_db = db
	level_clear_player.volume_db = db + 5
	level_fail_player.volume_db = db + 5
