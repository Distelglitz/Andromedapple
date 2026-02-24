shader_type canvas_item;

uniform vec4 top : source_color;
uniform vec4 bottom : source_color;

void vertex() {
	COLOR = mix(top, bottom, pow(UV.y,2.0f));
}
