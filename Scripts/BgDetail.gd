class_name BgDetail
extends Sprite2D

var startPos : Vector2
var parallaxBounds : Vector2

@export var baseZIndex : int
@export var baseScale : float
@export var tiltRange : float
@export var backFrontParallax : Vector2
@export var backFrontOpacity : Vector2
@export var backFrontZAdd : int
@export var backFrontScale : Vector2
var backFront : float



func setup(bounds : Vector2, _parallaxBounds : Vector2, tex : Texture2D, colIdx : int):
    backFront=randf()
    parallaxBounds=_parallaxBounds
    parallaxBounds*=lerp(backFrontParallax.x,backFrontParallax.y,backFront)

    startPos.x=lerp(-bounds.x,bounds.x,randf())
    startPos.y=lerp(-bounds.y,bounds.y,randf())
    position=startPos

    scale=Vector2.ONE*baseScale
    scale*=lerp(backFrontScale.x,backFrontScale.y,backFront)

    modulate=Persistent.c.bgDetailColor(colIdx)
    modulate.a=lerp(backFrontOpacity.x,backFrontOpacity.y,backFront)
    z_index=baseZIndex+int(backFront*backFrontZAdd)
    rotation_degrees=MathS.RandSigned()*tiltRange
    texture=tex
    flip_h=randf()>0.5

func parallaxUpdate(values : Vector2):
    position=startPos-values*parallaxBounds
