shader_type canvas_item;

uniform float prog;
uniform bool cutoutMode;

void fragment() {
	float centerDist = length(UV.rg - vec2(0.5,0.5));
	if(cutoutMode){
		COLOR.a = 1.0 - step(centerDist, prog);
	}
	else{
		COLOR.a = step(centerDist, prog);
	}
	// Called for every pixel the material is visible on.
}
