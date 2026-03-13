shader_type canvas_item;

uniform sampler2D tex;
uniform vec2 uvOffset;
void fragment() {
	COLOR.a=texture(TEXTURE,UV).a*texture(tex,UV*0.25+uvOffset).a;
}
