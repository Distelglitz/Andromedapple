class_name Stars
extends CPUParticles2D

@export var densityPer10000 : float
@export var parallax : float

@export var tex : Texture2D
@export var opacity : float
@export var colorIdxA : int
@export var colorIdxB : int
@export var sizeMod : float = 1
var parallaxBounds : Vector2

func setup(maxZoomBounds : Vector2, clampBounds : Vector2, layoutZoomBounds : Vector2):
	var bounds : Vector2 = clampBounds+maxZoomBounds*parallax
	if layoutZoomBounds.x>bounds.x:
		bounds=layoutZoomBounds
		print("Star Rect based on layout zoom")
	else:
		print("Star Rect based on clamp+parallax")
	emission_rect_extents=bounds

	amount=int(((emission_rect_extents.x*emission_rect_extents.y)*densityPer10000)/10000)
	color_initial_ramp.set_color(0,Persistent.c.bgLayers(colorIdxA))
	color_initial_ramp.set_color(1,Persistent.c.bgLayers(colorIdxB))
	modulate.a=opacity
	print("Star Amount " + str(amount))
	texture=tex
	scale_amount_max*=sizeMod
	scale_amount_min*=sizeMod
	restart()
func parallaxUpdate(values : Vector2):
	position=-parallaxBounds*values
