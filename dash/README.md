# regolith dash-compiler

filter for installing / running the bridge dash compiler.


## Before running
1. make sure you have nim and deno installed
2. make sure your config.json file has a compiler key and that the behaviour and resource pack keys are both set to ./BP and ./RP respectively

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
