import os, json, strutils

if not dirExists("./data/dash"):
    createDir("./data/dash")

if not fileExists("./data/dash/config.json"):
    quit("Must put a dash config at data/dash/config.json")

if not dirExists("./data/dash/deno_dash"):
    discard execShellCmd("git clone https://github.com/bridge-core/deno-dash-compiler.git ./data/dash/deno_dash")
    var root = getCurrentDir()
    setCurrentDir("./data/dash/deno_dash")
    discard execShellCmd("deno task install")
    setCurrentDir(root)

copyFile("./data/dash/config.json", "./config.json")

if dirExists("./data/dash/bridge"):
    echo "copying .bridge"
    copyDir("./data/dash/bridge", "./.bridge")
    if dirExists("./data/dash/bridge/extensions"):
        for e in walkDirRec("./data/dash/bridge/extensions"):
            if e.contains("manifest.json"):
                let parent = e.parentDir()
                let manifest = e.readFile().parseJson()
                echo "found extension: " & parent.splitPath()[1]
                if manifest.hasKey("contributeFiles"):
                    for k in manifest["contributeFiles"].keys:
                        echo "resource: " & k
                        let kPath = replace(parent & "/" & k, "\\", "/")
                        var packType: string
                        if manifest["contributeFiles"][k]["pack"].to(string).contains("behaviorPack"):
                            packType = "./BP/"
                        elif manifest["contributeFiles"][k]["pack"].to(string).contains("resourcePack"):
                            packType = "./RP/"
                        if kPath.fileExists():
                            kPath.copyFile(packType & manifest["contributeFiles"][k]["path"].to(string))
                        elif kPath.dirExists():
                            kPath.copyDir(packType & manifest["contributeFiles"][k]["path"].to(string))

if dirExists("./data/dash/build"):
    removeDir("./data/dash/build")

createDir("./data/dash/build")

discard execShellCmd("dash_compiler build --out ./data/dash/build")
let config = readFile("./data/dash/config.json").parseJson()

removeDir("./BP")
moveDir("./data/dash/build/builds/dist/" & config["name"].to(string) & " BP", "./BP")
removeDir("./RP")
moveDir("./data/dash/build/builds/dist/" & config["name"].to(string) & " RP", "./RP")