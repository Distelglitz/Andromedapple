class_name BgDetail
extends Sprite2D

var startPos : Vector2
var parallaxBounds : Vector2

func setup(bounds : Vector2, _parallaxBounds : Vector2, tex : Texture2D):
    parallaxBounds=_parallaxBounds
    startPos.x=lerp(-bounds.x,bounds.x,randf())
    startPos.y=lerp(-bounds.y,bounds.y,randf())
    position=startPos
    texture=tex

func parallaxUpdate(values : Vector2):
    position=startPos-values*parallaxBounds
