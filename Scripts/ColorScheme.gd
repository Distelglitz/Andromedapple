class_name ColorScheme
extends Resource

@export var main : Array[Color]
@export var secondary : Array[Color]

func foliage():
    return main[0]

func bgGradient(top : bool):
    return secondary[0] if top else secondary[1]
func bgLayers(idx : int):
    match idx:
        0:
            return main[0]
        1:
            return main[1]
        2:
            return secondary[3]
        3:
            return secondary[4]
func bgDetailColor(idx : int):
    return secondary[3]
    match idx:
        0:
            return main[0]
        1:
            return secondary[3]
func fruit():
    return secondary[5]

func fruitDetail():
    return secondary[6]

func flower():
    return fruit()

func flowerDetail():
    return fruitDetail()

func wood():
    return secondary[3]