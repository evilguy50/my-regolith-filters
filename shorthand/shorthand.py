import configparser
import os
import glob

config = configparser.ConfigParser()
if not os.path.isdir("data/shorthand"):
    os.mkdir("data/shorthand")
if not os.path.isfile("data/shorthand/config.ini"):
    with open('data/shorthand/config.ini', 'x') as f:
        f.write("[define]\nshorts = admin armors\n[as]\nadmin_long = @a[tag=admin]\narmors_long = @e[type=armor_stand]")
config.read('data/shorthand/config.ini')
shorts = config["define"]["shorts"]
pshort = shorts.split()
for filename in glob.iglob("./BP/functions/" + '**/*.mcfunction', recursive=True):
    print(filename)
    ropen = open(filename, "r")
    rFile = ropen.read()
    ropen.close()
    for i in pshort:
        short = i
        long = config["as"]["{}_long".format(i)]
        print("short = {arg1}, long = {arg2}".format(arg1 = short, arg2 = long))
        rFile = rFile.replace(short, long)
    os.remove(filename)
    newopen = open(filename, "x")
    newopen.write(rFile)
    newopen.close()
