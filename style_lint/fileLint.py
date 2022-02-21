from distutils.file_util import move_file
from genericpath import isfile
from pathlib import Path
import string

dotList = [
    ".entity.bp.json",
    ".entity.rp.json",
    ".b.json",
    ".biome.json",
    ".feature.json",
    ".item.bp.json",
    ".item.rp.json",
    ".lt.json",
    ".recipe.json",
    ".spawn.json",
    ".trade.json",
    ".bpac.json",
    ".rpac.json",
    ".rpa.json",
    ".attach.json",
    ".fog.json",
    ".geo.json",
    ".p.json",
    ".render.json"
]

pathList = [
    "./BP/entities/",
    "./RP/entity/",
    "./BP/blocks/",
    "./BP/biomes/",
    "./BP/features/",
    "./BP/items/",
    "./RP/items/",
    "./BP/loot_tables/",
    "./BP/recipes/",
    "./BP/spawn_rules/",
    "./BP/trading/",
    ".BP/animation_controllers/",
    ".RP/animation_controllers/",
    "./RP/animations/",
    "./RP/attachables/",
    "./RP/fogs/",
    "./RP/models/",
    "./RP/particles/",
    "./RP/render_controllers/"
]

def reName(p: string, suffix: string):
    for file in Path(p).rglob('*.json'):
        newFile = Path(file).__str__().split(".")[0] + suffix
        if not isfile(newFile):
            move_file(Path(file).__str__(), newFile)
            print("[Files dotname]: renamed " + Path(file).__str__() + " to " + newFile)