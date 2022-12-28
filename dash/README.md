# regolith dash-compiler

filter for installing / running the bridge dash compiler.


## Before running
1. make sure you have nim and deno installed
2. make sure your config.json file has a compiler key

## Example compiler key
```json
  "compiler": {
    "plugins": [
      "generatorScripts",
      "typeScript",
      "entityIdentifierAlias",
      "customEntityComponents",
      "customItemComponents",
      "customBlockComponents",
      "customCommands",
      "moLang",
      "formatVersionCorrection",
      [
        "simpleRewrite",
        {
          "packName": "example"
        }
      ]
    ]
  }
```

3. if use_bridge_config in settings.json is set to false you MUST set behaviour_pack and resource_pack to ./BP and ./RP

4. if use_bridge_config in settings.json is set to true you can leave your standard config.json alone and have those settings stored in data/dash/config.json instead