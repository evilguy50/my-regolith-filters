# regolith-classes

filter for adding OOP class like structure to functions.

install url:

    {
        "url": "github.com/evilguy50/my-regolith-filters/classes"
    }

## usage:
create class json files inside of BP/functions/classes
new method functions will be placed in data/methods.
after running the filter methods will be copied to BP/functions/methods

## example class json:

    {
        "class": {
            "name": "team",
            "types": [
                {"name": "red", "properties": [
                    "red_team",
                    "strength"
                ]},
                {"name": "blue", "properties": [
                    "blue_team",
                    "speed"
                ]},
                {"name": "yellow", "properties":[
                    "yellow_team",
                    "jump_boost"
                ]},
                {"name": "green", "properties":[
                    "green_team",
                    "regen"
                ]}
            ]
        }
    }

## example output (not including methods):

### class controller function

    scoreboard objectives add classes dummy
    scoreboard objectives add class_team dummy
    execute @e[scores={classes=1},tag=run] ~ ~ ~ function classes/team/index

### class index function

    scoreboard objectives add team_red dummy
    execute @e[scores={class_team=1}] ~ ~ ~ function methods/team/red/red_team
    execute @e[scores={class_team=1}] ~ ~ ~ function methods/team/red/strength
    scoreboard objectives add team_blue dummy
    execute @e[scores={class_team=2}] ~ ~ ~ function methods/team/blue/blue_team
    execute @e[scores={class_team=2}] ~ ~ ~ function methods/team/blue/speed
    scoreboard objectives add team_yellow dummy
    execute @e[scores={class_team=3}] ~ ~ ~ function methods/team/yellow/yellow_team
    execute @e[scores={class_team=3}] ~ ~ ~ function methods/team/yellow/jump_boost
    scoreboard objectives add team_green dummy
    execute @e[scores={class_team=4}] ~ ~ ~ function methods/team/green/green_team
    execute @e[scores={class_team=4}] ~ ~ ~ function methods/team/green/regen

### apply functions

    scoreboard players set @s classes 1
    scoreboard players set @s class_team 1
    tag @s add red_team
    tag @s add strength

    scoreboard players set @s classes 1
    scoreboard players set @s class_team 2
    tag @s add blue_team
    tag @s add speed

    scoreboard players set @s classes 1
    scoreboard players set @s class_team 3
    tag @s add yellow_team
    tag @s add jump_boost

    scoreboard players set @s classes 1
    scoreboard players set @s class_team 4
    tag @s add green_team
    tag @s add regen

### remove functions
    scoreboard players set @s class_team 0
    scoreboard players set @s classes 0
    tag @s remove red_team
    tag @s remove strength

    scoreboard players set @s class_team 0
    scoreboard players set @s classes 0
    tag @s remove blue_team
    tag @s remove speed

    scoreboard players set @s class_team 0
    scoreboard players set @s classes 0
    tag @s remove yellow_team
    tag @s remove jump_boost

    scoreboard players set @s class_team 0
    scoreboard players set @s classes 0
    tag @s remove green_team
    tag @s remove regen