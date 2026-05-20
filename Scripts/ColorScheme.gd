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
func bgDetail(idx : int):
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

# back to front
func rock(idx : int):
    match idx:
        0:
            return secondary[6]
        1:
            return secondary[7]
        _:
            return secondary[8]

func lineOrbit():
    return secondary[6]
func lineOrbitFrozen():
    return main[0]


func lineGravity(inside : bool):
    if inside:
        return secondary[7]
    else:
        return secondary[6]

func lineTrail():
    return secondary[6]

func ui():
    return main[2]

func freezing():
    return main[0]