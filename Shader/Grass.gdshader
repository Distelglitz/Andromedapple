shader_type canvas_item;

uniform float speed = 2.0;
uniform float height = 0.02;
uniform float radius = 0;
void vertex() {
	VERTEX += (((VERTEX/((radius/400.0))))*(sin(TIME*speed+VERTEX.x)+1.0)*height);
}
