import os, strutils

for i in os.walkDirRec("."):
    if fileExists(i):
        if i.contains("DS_Store"):
            os.removeFile(i)