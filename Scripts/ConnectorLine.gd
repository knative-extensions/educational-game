extends Line2D

# Nodes to connect
var start_node: Node2D
var end_node: Node2D

# Animation properties
var packet_timer = 0.0
var spawn_interval = 0.5 # Spawn a packet every 0.5 seconds
var packet_speed = 200.0 # Pixels per second

# Array to track active packets (sprites)
var packets = []
var active = true

func setup(start: Node2D, end: Node2D):
	start_node = start
	end_node = end
	
	# Set line style
	width = 3.0
	default_color = Color(1.0, 0.2, 0.2, 0.8) # Vibrant Red
	texture_mode = Line2D.LINE_TEXTURE_TILE
	_create_dotted_texture()
	
	_update_line_positions()

func _ready():
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND

func fade_out():
	active = false
	var tween = create_tween()
	# Clear all packets immediately
	for p in packets:
		if is_instance_valid(p.node):
			p.node.queue_free()
	packets.clear()
	# Fade out the line
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(queue_free)

func _process(delta):
	if not active: return
	
	# Update connection line in case objects move
	_update_line_positions()
	
	# Spawn packets
	packet_timer += delta
	if packet_timer >= spawn_interval:
		packet_timer = 0.0
		_spawn_packet()
		
	# Move packets
	_move_packets(delta)

func _update_line_positions():
	if is_instance_valid(start_node) and is_instance_valid(end_node):
		clear_points()
		# Start at bottom of box, End at top of sink
		# Small adjustment to Vector2(0, 0) logic might be needed for "middle corner"
		var start_p = start_node.global_position + Vector2(0, 70)
		var end_p = end_node.global_position - Vector2(0, 110)
		add_point(start_p)
		add_point(end_p)
	else:
		queue_free()

func _spawn_packet():
	if not is_instance_valid(start_node) or not is_instance_valid(end_node): return
	
	# Create a visual arrow using a Label
	var pkt = Label.new()
	pkt.text = "v" # Arrow pointing down
	pkt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# High-contrast Red Theme
	pkt.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3)) # Bright Red
	pkt.add_theme_color_override("font_shadow_color", Color(0.5, 0, 0, 1.0))
	pkt.add_theme_constant_override("shadow_offset_x", 0)
	pkt.add_theme_constant_override("shadow_offset_y", 0)
	pkt.add_theme_constant_override("shadow_outline_size", 14)
	pkt.add_theme_font_size_override("font_size", 30)
	
	# Use the same points as the line
	var start_pos = start_node.global_position + Vector2(0, 70)
	var end_pos = end_node.global_position - Vector2(0, 110)
	
	pkt.global_position = start_pos - Vector2(10, 15) # Offset to center
	add_child(pkt)
	
	packets.append({
		"node": pkt,
		"progress": 0.0,
		"start": start_pos,
		"end": end_pos
	})

func _move_packets(delta):
	# Iterate backwards to allow removing items
	for i in range(packets.size() - 1, -1, -1):
		var p = packets[i]
		
		var total_dist = p.start.distance_to(p.end)
		if total_dist == 0: continue
		
		p.progress += (packet_speed * delta) / total_dist
		
		if p.progress >= 1.0:
			p.node.queue_free()
			packets.remove_at(i)
		else:
			var current_pos = p.start.lerp(p.end, p.progress)
			p.node.global_position = current_pos - Vector2(10, 15)

func _create_dotted_texture():
	var img = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	img.fill(Color(0,0,0,0)) # Transparent
	
	# Draw a small 4x4 dot in the middle
	for x in range(6, 10):
		for y in range(6, 10):
			img.set_pixel(x, y, Color(1, 1, 1, 1))
			
	var tex = ImageTexture.create_from_image(img)
	texture = tex
