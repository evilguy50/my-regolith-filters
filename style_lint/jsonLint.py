from time import sleep
import jsonc
import json
import ujson
import re

def format(f, comments: bool):
    readF = open(f, "r+")
    try:
        print("[Json Format]: formatted " + f)
        data = jsonc.load(readF)
        readF.truncate(0)
        readF.seek(0)
        jsonc.dump(data, readF, indent=4, comments=comments)
    except Exception as e:
        print("[Json Format]: exception for " + f + " (exception: " + e.__str__() + ")")
    readF.close()

def remove(f):
    ran = False
    strF = open(f.__str__(), "r").read()
    for line in strF.split("\n"):
        if "//" in line:
            ran = True
            strF = strF.replace("//" + line.split("//")[1], "")
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    if ran:
        print("[Json removeComments]: removed comments from " + f.__str__())

def minify(f):
    strF = open(f.__str__(), "r").read()
    strF = ujson.dumps(strF)
    strF =  re.sub("([ ]{2,20})", "", strF)
    strF = strF.replace("\\\"", "\"")
    strF = strF.replace("\"{", "{")
    strF = strF.replace("}\"", "}")
    strF = strF.replace("\\n", "")
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    print("[Json Minify]: minified " + f.__str__())

def unicode(f):
    strF = open(f.__str__(), "r").read()
    strF = ''.join(r'\u{:04X}'.format(ord(chr)) for chr in strF)
    newF = open(f.__str__(), "r+")
    newF.truncate(0)
    newF.seek(0)
    newF.write(strF)
    newF.close()
    print("[Json Unicode]: encoded " + f.__str__())