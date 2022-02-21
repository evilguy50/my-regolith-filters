import re

def removeComments(f):
    strF = open(f.__str__(), "r").read()
    ran = False
    for line in open(f.__str__(), "r").read().split("\n"):
        if "#" in line:
            strF = strF.replace("#" + line.split("#")[1], "")
            ran = True
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    if ran:
        print("[Functions removeComments]: removed comments from " + f.__str__())

def spaceCoords(f):
    ran = False
    def space(f):
        strF = open(f.__str__(), "r").read()
        for r in re.findall("(~)([0-9]{0,10})(~)", strF):
            ran = True
            print(r)
            oldR = r[0] + r[1] + r[2]
            rStr = r[0] + r[1] + " " + r[2]
            print(rStr)
            strF = strF.replace(oldR, rStr)
        newF = open(f.__str__(), "r+")
        newF.truncate(0)
        newF.seek(0)
        newF.write(strF)
        newF.close()
    space(f)
    space(f)
    if ran:
        print("[Functions spaceCoords]: spaced coords in " + f.__str__())

def noSpace(f):
    strF = open(f.__str__(), "r").read()
    newFull = ""
    ran = False
    for full in open(f.__str__(), "r").read().split("\n"):
        newFull = full
        starts = full.split("[")
        startCount = -1
        selects = []
        for s in starts:
            startCount += 1
            if startCount > 0:
                selects.append(s.split("]")[0])
        for s in selects:
            ran = True
            args = s.split(",")
            newS = ""
            for sp in args:
                if "name=" in sp.replace(" ", ""):
                    noSpace = sp.split("\"")[0].replace(" ", "")
                    newFull = newFull.replace(sp.split("\"")[0], noSpace)
                else:
                    noSpace = sp.replace(" ", "")
                    newFull = newFull.replace(sp, noSpace)
        strF = strF.replace(full, newFull)
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    if ran:
        print("[Functions noSelectorSpace]: removed spaces in selectors for " + f.__str__())