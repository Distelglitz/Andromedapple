class_name MenuLine
extends Line2D

var from : MenuLevel
var to : MenuLevel
@export var offset : float

@export var texCleared : Texture
@export var texUncleared : Texture

func setup(_from : MenuLevel,_to : MenuLevel):
    from=_from
    to=_to
    set_point_position(0, from.getPos()+from.getPos().direction_to(to.getPos())*offset)
    set_point_position(1, to.getPos()+to.getPos().direction_to(from.getPos())*offset)

    modulate.a = 0.75
    var sp : MenuColorSprite = get_child(0)
    if to.levelState==MenuLevel.LevelState.Cleared:
        sp.main = true
        sp.idx = 0
        texture = texCleared
    else:
        sp.main = false
        sp.idx = 6
        texture = texUncleared
    sp.self_modulate = sp.targetCol
    sp.update()