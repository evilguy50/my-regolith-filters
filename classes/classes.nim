import os, json, strutils, strformat, compiler/sourcemap

# class type map
type
    FuncType = object
        name: string
        properties: seq[string]
    Class = object
        name: string
        types: seq[FuncType]

# class list
var classes: seq[Class]

# get classes
for j in os.walkDirRec("./BP/functions/classes"):
    if j.endsWith(".json"):
        var nCLass: Class
        var nTypes: seq[FuncType]
        let jStr = j.readFile().parseJson()["class"]
        nCLass.name = jStr["name"].to(string)
        for t in jStr["types"]:
            var nType: FuncType
            nType.name = t["name"].to(string)
            nType.properties = t["properties"].to(seq[string])
            nTypes.add(nType)
        nCLass.types = nTypes
        classes.add(nCLass)
        j.removeFile()

proc newFunction(cmds: seq[string], path: string)= writeFile(fmt"./BP/functions/{path}",cmds.join("\n"))

# index mcfunction
var index: seq[string]
index.add("scoreboard objectives add classes dummy")
for s in classes:
    var sIndex = classes.index(s)
    var sAdd = sIndex + 1
    index.add(fmt"scoreboard objectives add class_{s.name} dummy")
    index.add("execute @e[scores={classes=$sAdd},tag=run] ~ ~ ~ ".replace("$sAdd", $sAdd) & fmt"function classes/{s.name}/index")
index.newFunction("classes/index.mcfunction")

# type functions
for c in classes:
    if not os.dirExists("./data/methods/"):
        createDir("./data/methods/")
    if not os.dirExists("./data/methods/" & c.name):
        createDir("./data/methods/" & c.name)
    var cIndex: seq[string]
    if not os.dirExists(fmt"./BP/functions/classes/{c.name}"):
        createDir(fmt"./BP/functions/classes/{c.name}")
    for t in c.types:
        if not os.dirExists(fmt"./data/methods/{c.name}/{t.name}"):
            createDir(fmt"./data/methods/{c.name}/{t.name}")
        var cmds: seq[string]
        var tIndex = index(c.types, t)
        var tAdd = tIndex + 1
        cmds.add(fmt"scoreboard objectives add {c.name}_{t.name} dummy")
        for p in t.properties:
            if not os.fileExists(fmt"./data/methods/{c.name}/{t.name}/{p}.mcfunction"):
                writeFile(fmt"./data/methods/{c.name}/{t.name}/{p}.mcfunction",fmt"# {p} method")
            cmds.add("execute @e[scores={class_$cName=$tAdd}] ~ ~ ~ function methods/$cName/$tName/$p".multiReplace(
                ("$cName", c.name),
                ("$tName", t.name),
                ("$tAdd", $tAdd),
                ("$p", p)
            ))
        cIndex.add(cmds.join("\n"))
    cIndex.newFunction(fmt"classes/{c.name}/index.mcfunction")

# apply functions
for c in classes:
    var cIndex = index(classes, c)
    var cPlus = cIndex + 1
    for a in c.types:
        var applyCmds: seq[string]
        var removeCmds: seq[string]
        var aIndex = index(c.types, a)
        var aPlus = aIndex + 1
        applyCmds.add(fmt"scoreboard players set @s classes {$cPlus}")
        applyCmds.add("scoreboard players set @s class_$cName $aPlus".multiReplace(
            ("$cName", c.name),
            ("$aPlus", $aPlus)
        ))
        removeCmds.add("scoreboard players set @s class_$cName 0".replace("$cName", c.name))
        removeCmds.add("scoreboard players set @s classes 0")
        for p in a.properties:
            applyCmds.add(fmt"tag @s add {p}")
            removeCmds.add(fmt"tag @s remove {p}")
        # write apply
        if not os.dirExists(fmt"./BP/functions/classes/apply"):
            createDir(fmt"./BP/functions/classes/apply")
        if not os.dirExists(fmt"./BP/functions/classes/apply/{c.name}"):
            createDir(fmt"./BP/functions/classes/apply/{c.name}")
        applyCmds.newFunction(fmt"classes/apply/{c.name}/{a.name}.mcfunction")
        # write remove
        if not os.dirExists(fmt"./BP/functions/classes/remove"):
            createDir(fmt"./BP/functions/classes/remove")
        if not os.dirExists(fmt"./BP/functions/classes/remove/{c.name}"):
            createDir(fmt"./BP/functions/classes/remove/{c.name}")
        removeCmds.newFunction(fmt"classes/remove/{c.name}/{a.name}.mcfunction")

os.copyDir("./data/methods/", "./BP/functions/methods/")