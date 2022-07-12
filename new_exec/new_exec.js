"use strict";
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __values = (this && this.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};
exports.__esModule = true;
var cmds = require("bc-minecraft-bedrock-command");
var fs = require("fs");
var path = require("path");
var json = require("json5");
function getElemInRange(array, join, min, max) {
    var result = "";
    var num = -1;
    for (var a in array) {
        num++;
        if (num >= min && num <= max) {
            result += array[a] + join;
        }
    }
    return result;
}
function walkSync(dir) {
    var files, _i, files_1, file;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                files = fs.readdirSync(dir, { withFileTypes: true });
                _i = 0, files_1 = files;
                _a.label = 1;
            case 1:
                if (!(_i < files_1.length)) return [3 /*break*/, 6];
                file = files_1[_i];
                if (!file.isDirectory()) return [3 /*break*/, 3];
                return [5 /*yield**/, __values(walkSync(path.join(dir, file.name)))];
            case 2:
                _a.sent();
                return [3 /*break*/, 5];
            case 3: return [4 /*yield*/, path.join(dir, file.name)];
            case 4:
                _a.sent();
                _a.label = 5;
            case 5:
                _i++;
                return [3 /*break*/, 1];
            case 6: return [2 /*return*/];
        }
    });
}
var cmdTemplate = "execute as $selector positioned $posrun $cmd";
var detectTemplate = "execute as $selector positioned $posif block $2pos$block $data run $cmd";
function detectExec(args, selector) {
    var pos = getElemInRange(args, " ", 2, 4);
    var pos2 = getElemInRange(args, " ", 6, 8);
    var block = args[9];
    var data = args[10];
    var new_cmd = getElemInRange(args, " ", 11, args.length - 1);
    var newL = detectTemplate.replace("$selector", selector).replace("$pos", pos).replace("$2pos", pos2).replace("$block", block).replace("$data", data).replace("$cmd", new_cmd);
    return [newL, new_cmd];
}
for (var _i = 0, _a = walkSync("./BP/functions"); _i < _a.length; _i++) {
    var filePath = _a[_i];
    var f = fs.readFileSync(filePath, "utf8");
    var fStr = f.split("\n");
    for (var l in fStr) {
        var cmd = cmds.Command.parse(fStr[l]);
        if (cmd.getKeyword() == "execute") {
            var cmdStr = JSON.stringify(cmd);
            var cmdJson = json.parse(cmdStr);
            var args = [];
            for (var c in cmdJson["parameters"]) {
                args.push(cmdJson["parameters"][c]["text"]);
            }
            var detect = false;
            var params = ["as", "at", "run", "if", "unless", "positioned"];
            for (var d in params) {
                if (args[1].startsWith(params[d])) {
                    detect = true;
                }
            }
            if (detect) {
                console.log("command already new execute: skipping");
            }
            if (detect == false) {
                var selector = args[1];
                var pos = getElemInRange(args, " ", 2, 4);
                var new_cmd;
                var newL;
                if (args[5] != "detect") {
                    new_cmd = getElemInRange(args, " ", 5, args.length - 1);
                    newL = cmdTemplate.replace("$selector", selector).replace("$pos", pos).replace("$cmd", new_cmd);
                }
                else {
                    new_cmd = getElemInRange(args, " ", 11, args.length - 1);
                    newL = detectExec(args, selector)[0];
                }
                if (new_cmd.startsWith("execute")) {
                    while (new_cmd.startsWith("execute")) {
                        var aCmd = cmds.Command.parse(new_cmd);
                        var aCmdStr = JSON.stringify(aCmd);
                        var aCmdJson = json.parse(aCmdStr);
                        var nArgs = [];
                        var a_cmd = "";
                        for (var c in aCmdJson["parameters"]) {
                            nArgs.push(aCmdJson["parameters"][c]["text"]);
                        }
                        if (nArgs[5] != "detect") {
                            var new_selector = nArgs[1];
                            var new_pos = getElemInRange(nArgs, " ", 2, 4);
                            a_cmd = getElemInRange(nArgs, " ", 5, nArgs.length - 1);
                            newL = newL.replace(new_cmd, cmdTemplate.replace("$selector", new_selector).replace("$pos", new_pos).replace("$cmd", a_cmd));
                        }
                        else {
                            var new_selector = nArgs[1];
                            var execOut = detectExec(nArgs, new_selector);
                            newL = newL.replace(new_cmd, execOut[0]);
                            a_cmd = execOut[1];
                        }
                        new_cmd = a_cmd;
                    }
                }
                f = f.replace(fStr[l], newL);
            }
        }
    }
    fs.writeFileSync(filePath, f);
}
