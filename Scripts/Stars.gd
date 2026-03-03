class_name Stars
extends CPUParticles2D

@export var densityPer10000 : float
@export var parallax : float

@export var tex : Texture2D
@export var opacity : float
@export var colorIdxA : int
@export var colorIdxB : int
@export var sizeMod : float = 1
#var parallaxBounds : Vector2
var maxZoomBounds : Vector2

func setup(_maxZoomBounds : Vector2, clampBounds : Vector2, layoutZoomBounds : Vector2):
	maxZoomBounds=_maxZoomBounds
	var boundsA = _maxZoomBounds+maxZoomBounds*parallax+Cam.padding
	var boundsB = layoutZoomBounds+Cam.padding
	emission_rect_extents=boundsA if boundsA.x>boundsB.x else boundsB
	amount=int(((emission_rect_extents.x*emission_rect_extents.y)*densityPer10000)/10000)
	color_initial_ramp.set_color(0,Persistent.c.bgLayers(colorIdxA))
	color_initial_ramp.set_color(1,Persistent.c.bgLayers(colorIdxB))
	modulate.a=opacity
	texture=tex
	scale_amount_max*=sizeMod
	scale_amount_min*=sizeMod
	restart()
func parallaxUpdate(values : Vector2):
	position=-maxZoomBounds*parallax*values
