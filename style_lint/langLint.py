def removeComments(f):
    ran = False
    strF = open(f.__str__(), "r").read()
    for line in open(f.__str__(), "r").read().split("\n"):
        if "##" in line:
            strF = strF.replace("##" + line.split("##")[1], "")
            ran = True
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    if ran:
        print("[Language removecomments]: removed comments from " + f.__str__())