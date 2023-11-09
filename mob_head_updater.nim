import json, os, strutils

let jsonTemplate = %*
  {
    "type": "minecraft:entity",
    "pools": []
  }

func createEntJson(datapack, entityPath: string): JsonNode = %*
  {
    "rolls": 1,
    "entries": [
      {
        "type": "minecraft:loot_table",
        "name": "$1:$2" % [datapack, entityPath]
      }
    ]
  }

proc addForFolder(folder: string) =
  var b4bEnts: seq[string]
  var mobheadEnts: seq[string]

  for filePath in walkFiles "./data/block4block/loot_tables/$1/*.json" % folder:
      var (_, name, _) = splitFile(filePath)
      b4bEnts.add name


  for filePath in walkFiles "./data/mobheads/loot_tables/$1/*.json" % folder:
      var (_, name, _) = splitFile(filePath)
      mobheadEnts.add name

  for ent in b4bEnts:
    var j = jsonTemplate.copy()
    # Add block4block
    j["pools"].add(createEntJson("block4block", folder & "/" & ent))
    # If mobheads has same entity, add it
    if ent in mobheadEnts:
      j["pools"].add(createEntJson("mobheads", folder & "/" & ent))
    writeFile "./data/minecraft/loot_tables/$1/$2.json" % [folder, ent], j.pretty

  for ent in mobheadEnts:
    # If only mobheads has entity, add it
    if not (ent in b4bEnts):
      var j = jsonTemplate.copy()
      j["pools"].add(createEntJson("mobheads", folder & "/" & ent))
      writeFile "./data/minecraft/loot_tables/$1/$2.json" % [folder, ent], j.pretty

addForFolder("entities")
addForFolder("entities/sheep")
