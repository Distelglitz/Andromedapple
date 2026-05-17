shader_type canvas_item;

uniform float p : hint_range(0.0, 1.0, 0.01);

void fragment() {
	float f = pow(length(UV-vec2(0.5,0.5)),(1.0-p*0.7)*2.5f+0.1f)*p*0.7;
	COLOR.a = f * COLOR.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
