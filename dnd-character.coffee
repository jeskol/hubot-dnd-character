# Description:
#   You've got to start a new character and you're out of ideas.  Let me help.
# Notes:
#   Put the help here

helpText = """```
Create a randomized character idea:     who is my character
Add or remove character adjective:      (add|remove) adjective "<adjective>"
Add or remove character race:           (add|remove) race "<race>"
Add or remove character class:          (add|remove) class "<class>"
Add or remove character location:       (add|remove) location "<location>"
Add or remove character backstory:      (add|remove) backstory "<backstory>"
List item types:                        list <type>
```"""

keyToDb =
    'adjective': 'dndAdjectives'
    'race': 'dndRaces'
    'class': 'dndClasses'
    'location': 'dndLocations'
    'backstory': 'dndBackstories'

pluralize =
    'adjective': 'Adjectives'
    'race': 'Races'
    'class': 'Classes'
    'location': 'Locations'
    'backstory': 'Backstories'

defaults =
    dndAdjectives: "tough"
    dndRaces: "elf"
    dndClasses: "ranger"
    dndLocations: "the woodland kingdoms"
    dndBackstories: "doesn't take shit from anyone"

module.exports = (robot) ->
    getDb = (dbName) ->
        robot.brain.get(dbName) or [ defaults[dbname] ]

    randItem = (list) ->
        list[Math.floor(Math.random() * list.length)]

    respondToKey = (cb) ->
        (msg) ->
            [_, key, content] = msg.match
            dbName = keyToDb[key]
            return msg.reply("Error: key not valid: '#{key}'") if not dbName

            db = getDb dbName
            cb(msg, content, key, dbName, db)

    robot.respond /character help/i, (msg) ->
        msg.send helpText

    robot.respond /(roll me a|create me a|who is my) character/i, (msg) ->
        adj = randItem getDb 'dndAdjectives'
        race = randItem getDb 'dndRaces'
        dclass = randItem getDb 'dndClasses'
        location = randItem getDb 'dndLocations'
        backstory = randItem getDb 'dndBackstories'

        msg.send "#{adj} #{race} #{dclass} from #{location} who #{backstory}."

    robot.respond /add (\w+) "([^\"]+)"/i, respondToKey (msg, content, key, dbName, db) ->
        if content not in db
            db.push content
            robot.brain.set dbName, db
            msg.reply "Added new #{key}: '#{content}'"

        else
            msg.reply "Error: '#{content}' already in #{key}"

    robot.respond /remove (\w+) "([^\"]+)"/i, respondToKey (msg, content, key, dbName, db) ->
        index = db.indexOf content
        if index > -1
            db.splice index, 1
            robot.brain.set dbName, db
            msg.reply "Removed '#{content}' from #{key}"

        else
            msg.reply "Couldn't find '#{content}' in #{key}"

    robot.respond /list (\w+)/i, respondToKey (msg, content, key, dbName, db) ->
        msg.send "#{pluralize[key]}:\n```'#{ db.join('\n') }'\n```"
