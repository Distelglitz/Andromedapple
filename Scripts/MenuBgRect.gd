extends ColorRect

@export var top : MenuColorSprite
@export var bottom : MenuColorSprite
var mat : ShaderMaterial

var modOld : Color

func _ready():
    mat = material
    updateShader()

func _process(delta):
    if modOld == top.modulate:
        pass
    updateShader()
    modOld = top.modulate

func updateShader():
    mat.set_shader_parameter("top", top.modulate)
    mat.set_shader_parameter("bottom", bottom.modulate)