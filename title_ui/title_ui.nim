import os, json, strutils, strformat

var config = readFile("./data/title_ui/config.json").parseJson()
var prefix = config["prefix"].to(string)
var ui = readFile("./data/title_ui/hud_screen.json").replace("$prefix-", prefix).parseJson()

proc newImage(u: JsonNode, prefix, name: string, width, height, layer: int): JsonNode=
    var newU = u
    # image
    newU.add(name & "_image", %*{})
    newU[name & "_image"].add("type", newJString("image"))
    newU[name & "_image"].add("texture", newJString("textures/ui/" & name))
    newU[name & "_image"].add("size", %*[width, height])
    newU[name & "_image"].add("layer", newJInt(layer))
    newU[name & "_image"].add("bindings", %*[])
    var baseBind = %*{"binding_name": "#hud_title_text_string"}
    var preBind = %*{ "binding_type": "view", "source_property_name": fmt"(#hud_title_text_string = '{prefix}{name}')", "target_property_name": "#visible"}
    newU[name & "_image"]["bindings"].add(baseBind)
    newU[name & "_image"]["bindings"].add(preBind)
    # factory
    newU.add(name & "_image_factory", %*{})
    newU[name & "_image_factory"].add("type", newJString("panel"))
    newU[name & "_image_factory"].add("factory", %*{})
    newU[name & "_image_factory"]["factory"].add("name", newJString("hud_title_text_factory"))
    newU[name & "_image_factory"]["factory"].add("control_ids", %*{})
    newU[name & "_image_factory"]["factory"]["control_ids"].add("hud_title_text", newJString(fmt"{name}_image@hud.{name}_image"))
    # add root mod
    var newMod = %*{"array_name": "controls", "operation": "insert_front","value": {fmt"{name}_image_factory@hud.{name}_image_factory": {}}}
    newU["root_panel"]["modifications"].add(newMod)
    return newU

var layer = 0
for im in config["images"]:
    layer.inc(1)
    ui = ui.newImage(prefix, im["name"].to(string), im["width"].to(int), im["height"].to(int), layer)

if not dirExists("./RP/ui"):
    createDir("./RP/ui")
writeFile("./RP/ui/hud_screen.json", ui.pretty())