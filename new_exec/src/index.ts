import * as cmds from "bc-minecraft-bedrock-command"
import * as fs from "fs"
import * as path from "path"
import * as json from "json5"

function getElemInRange(array: any, join: string,  min: number, max: number): string {
    var result = ""
    var num = -1
    for (var a in array) {
        num++
        if (num >= min && num <= max) {
            result += array[a] + join
        }
    }
    return result
}

function *walkSync(dir: string): any {
  const files = fs.readdirSync(dir, { withFileTypes: true });
  for (const file of files) {
    if (file.isDirectory()) {
      yield* walkSync(path.join(dir, file.name));
    } else {
      yield path.join(dir, file.name);
    }
  }
}
const cmdTemplate = "execute as $selector positioned $posrun $cmd"
const detectTemplate = "execute as $selector positioned $posif block $2pos$block $data run $cmd"
function detectExec(args: Array<string>, selector: string) {
        var pos = getElemInRange(args, " ", 2, 4)
        var pos2 = getElemInRange(args, " ", 6, 8)
        var block = args[9]
        var data = args[10]
        var new_cmd = getElemInRange(args, " ", 11, args.length - 1)
        var newL = detectTemplate.replace("$selector", selector).replace("$pos", pos).replace("$2pos", pos2).replace("$block", block).replace("$data", data).replace("$cmd", new_cmd)
        return [newL, new_cmd]
}
for (const filePath of walkSync("./BP/functions")) {
    let f = fs.readFileSync(filePath, "utf8")
    let fStr = f.split("\n")
    for (var l in fStr) {
        var cmd = cmds.Command.parse(fStr[l])
        if (cmd.getKeyword() == "execute") {
            var cmdStr = JSON.stringify(cmd)
            var cmdJson = json.parse(cmdStr)
            var args: Array<string> = []
            for (var c in cmdJson["parameters"]) {
                args.push(cmdJson["parameters"][c]["text"])
            }
            var detect = false
            let params = ["as", "at", "run", "if", "unless", "positioned"]
            for (var d in params) {
                if (args[1].startsWith(params[d])) {
                    detect = true
                }
            }
            console.log(detect)
            if (detect == false) {
                var selector = args[1]
                var pos = getElemInRange(args, " ", 2, 4)
                var new_cmd: string
                var newL: string
                if (args[5] != "detect") {
                    new_cmd = getElemInRange(args, " ", 5, args.length - 1)
                    newL = cmdTemplate.replace("$selector", selector).replace("$pos", pos).replace("$cmd", new_cmd)
                } else {
                    new_cmd = getElemInRange(args, " ", 11, args.length - 1)
                    newL = detectExec(args, selector)[0]
                }
                if (new_cmd.startsWith("execute")) {
                    while (new_cmd.startsWith("execute")) {
                        var aCmd = cmds.Command.parse(new_cmd)
                        var aCmdStr = JSON.stringify(aCmd)
                        var aCmdJson = json.parse(aCmdStr)
                        var nArgs: Array<string> = []
                        var a_cmd = ""
                        for (var c in aCmdJson["parameters"]) {
                            nArgs.push(aCmdJson["parameters"][c]["text"])
                        }
                        if (nArgs[5] != "detect") {
                            var new_selector = nArgs[1]
                            var new_pos = getElemInRange(nArgs, " ", 2, 4)
                            a_cmd = getElemInRange(nArgs, " ", 5, nArgs.length - 1)
                            newL = newL.replace(new_cmd, cmdTemplate.replace("$selector", new_selector).replace("$pos", new_pos).replace("$cmd", a_cmd))
                        } else {
                            var new_selector = nArgs[1]
                            var execOut = detectExec(nArgs, new_selector)
                            newL = newL.replace(new_cmd, execOut[0])
                            a_cmd = execOut[1]
                        }
                        new_cmd = a_cmd
                    }
                }
                f = f.replace(fStr[l], newL)
            }
        }
    }
    fs.writeFileSync(filePath, f)
}