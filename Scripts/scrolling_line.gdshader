shader_type canvas_item;

uniform float speed = 2.0;

void fragment() {
	vec2 uv = UV;
	uv.x -= TIME * speed;
	vec4 color = texture(TEXTURE, uv);
	COLOR = color * MODULATE;
}
