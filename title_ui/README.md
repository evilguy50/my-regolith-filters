# regolith-title-ui

filter for generating title ui bindings.

install url:

    {
        "url": "github.com/evilguy50/my-regolith-filters/title_ui"
    }

adding a new image:

    just add a new object to the config.json images array.

    {
        "name": "example",
        "width": 64,
        "height": 64,
        "offset": [0, 0]
    }

    the image in-game will be sourced from textures/ui/{your image name}
    if you want to change the texture path add a path key to the image object.
    don't put a trailing /

running the title command:

    in the config.json there's a prefix string.
    just run the title name after the prefix.

    /title @a title ui_example