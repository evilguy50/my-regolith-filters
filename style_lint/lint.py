import configparser
import string
import fileLint as dot
from pathlib import Path
import jsonLint
import langLint
import funcLint
import string

config = configparser.ConfigParser()
config.read('./data/style_lint/config.ini')

def configBool(cat: string, opt: string):
    if config[cat][opt].__str__().lower().__contains__("true"):
        return True
    else:
        return False

if configBool("Files","dotNaming"):
    pathCount = -1
    for p in dot.pathList:
        pathCount += 1
        dot.reName(p, dot.dotList[pathCount])

for f in Path("./BP/").rglob('*.json'):
    if configBool("Json","format"):
        if configBool("Json","removeComments"):
            jsonLint.format(f.__str__(), False)
        else:
            jsonLint.format(f.__str__(), True)
    if configBool("Json","removeComments"):
        if not configBool("Json","format"):
            jsonLint.remove(f)
        if configBool("Json","minify"):
            jsonLint.minify(f)
        if configBool("Json","obfuscate"):
            jsonLint.unicode(f)
for f in Path("./RP/").rglob('*.json'):
    if configBool("Json","format"):
        if configBool("Json","removeComments"):
            jsonLint.format(f.__str__(), False)
        else:
            jsonLint.format(f.__str__(), True)
    if configBool("Json","removeComments"):
        if not configBool("Json","format"):
            jsonLint.remove(f)
        if configBool("Json","minify"):
            jsonLint.minify(f)
        if configBool("Json","obfuscate"):
            jsonLint.unicode(f)

if configBool("Language","removeComments"):
    for f in Path(".").rglob('*.lang'):
        langLint.removeComments(f)

for f in Path(".").rglob('*.mcfunction'):
    if configBool("Functions","removeComments"):
        funcLint.removeComments(f)
    if configBool("Functions","spacedCoords"):
        funcLint.spaceCoords(f)
    if configBool("Functions","noSelectSpaces"):
        funcLint.noSpace(f)