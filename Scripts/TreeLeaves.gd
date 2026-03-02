extends Sprite2D

@export var possibleTextures : Array[Texture2D]

func _ready():
    texture=possibleTextures.pick_random()
    flip_h=randf()>0.5
    flip_v=randf()>0.5
    rotation_degrees=MathS.RandSigned()*10
    modulate=Persistent.c.foliage()