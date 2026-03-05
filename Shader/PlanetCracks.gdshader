shader_type canvas_item;

uniform sampler2D cracks;
uniform vec2 crackUvOffset;
void fragment() {
	COLOR.a=texture(TEXTURE,UV).a*texture(cracks,UV*0.25+crackUvOffset).a;
}
