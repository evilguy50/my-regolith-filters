import os, json, strformat
import puppy
import zippy/ziparchives

const dashVersion = "0.4.5"
echo fmt"dash version: {dashVersion}"
let rootDir = getEnv("ROOT_DIR")
let filterDir = getCurrentDir()
var configFile = fmt"{rootDir}/config.json"
var settings = parseFile("./data/dash/settings.json")
if settings["use_bridge_config"].to(bool) == true:
    echo "set config to bridge config"
    configFile = fmt"{filterDir}/data/dash/config.json"
if not fileExists(configFile):
    echo fmt"config file: ${configFile}"
    quit("config file doesn't exist")
var config = parseFile(configFile)

if not config.hasKey("compiler"):
    echo fmt"config file: ${configFile}"
    quit("config file missing field 'compiler' needed for dash to run")

if not dirExists("./data/dash"):
    createDir("./data/dash")

if not dirExists("./data/dash/dash_compiler"):
    writeFile("./data/dash/dash.zip", fetch(fmt"https://github.com/bridge-core/deno-dash-compiler/archive/refs/tags/v{dashVersion}.zip"))
    extractAll("./data/dash/dash.zip", "./data/dash/tmp")
    moveDir(fmt"./data/dash/tmp/deno-dash-compiler-{dashVersion}", "./data/dash/dash_compiler")
    removeDir("./data/dash/tmp")
    removeFile("./data/dash/dash.zip")
    removeFile("./data/dash/tmp.txt")
    setCurrentDir("./data/dash/dash_compiler")
    discard execShellCmd("deno task install:full")

echo filterDir
setCurrentDir(filterDir)
copyFile(configFile, "./config.json")
sleep(1000)

discard execShellCmd("dash_compiler build")

let configName: string = config["name"].to(string)
for pack in @["BP", "RP"]:
    removeDir(fmt"./{pack}")
    sleep(1000)
    for d in walkDirRec("./builds/dist"):
        echo fmt"buildPath: {d}"
    moveDir(fmt"./builds/dist/{configName} {pack}", fmt"./{pack}")