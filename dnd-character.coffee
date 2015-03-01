# Description:
#   You've got to start a new character and you're out of ideas.  Let me help.
# Notes:
#   Put the help here

module.exports = (robot) ->

  robot.respond /character help/i, (msg) ->
    helpText = '```
Create a randomized character idea:     who is my character\n
Add or remove character adjective:      (add|remove) adjective "<adjective>"\n
Add or remove character race:           (add|remove) race "<race>"\n
Add or remove character class:          (add|remove) class "<class>"\n
Add or remove character location:       (add|remove) location "<location>"\n
Add or remove character backstory:      (add|remove) backstory "<backstory>"\n
List item types:                        list <type>\n
```'
    msg.send helpText

  robot.respond /(roll me a|create me a|who is my) character/i, (msg) ->
    msg.send rollCharacter()

  rollCharacter = ->
    adjectives = robot.brain.get('dndAdjectives') or ['tough']
    races = robot.brain.get('dndRaces') or ['elf']
    classes = robot.brain.get('dndClasses') or ['ranger']
    locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
    backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
    adj = adjectives[Math.floor(Math.random() * adjectives.length)]
    race = races[Math.floor(Math.random() * races.length)]
    dclass = classes[Math.floor(Math.random() * classes.length)]
    location = locations[Math.floor(Math.random() * locations.length)]
    backstory = backstories[Math.floor(Math.random() * backstories.length)]
    "#{adj} #{race} #{dclass} from #{location} who #{backstory}."

  robot.respond /(roll us some|create us some|who are our) characters/i, (msg) ->
    msg.send "The intrepid souls of '#{msg.message.user.room}' ...:"
    for own key, user of robot.brain.users when user.name != robot.name
      #user = "#{user.name}" if "#{user.name}" != robot.name
      char = rollCharacter()
      msg.send "  #{user.name}, the #{char}"
    msg.send "  ... have banded together to brave the odds in search of The Quest for the Meanigful MacGuffin!"

  robot.respond /add (adjective|race|class|location|backstory) "([^\"]+)"/i, (msg) ->
    adjectives = robot.brain.get('dndAdjectives') or ['tough']
    races = robot.brain.get('dndRaces') or ['elf']
    classes = robot.brain.get('dndClasses') or ['ranger']
    locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
    backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
    newtype = msg.match[1]
    newcontent = msg.match[2]
    if newtype is 'adjective' and newcontent not in adjectives
      adjectives.push(newcontent)
      robot.brain.set 'dndAdjectives', adjectives
    if newtype is 'race' and newcontent not in races
      races.push(newcontent)
      robot.brain.set 'dndRaces', races
    if newtype is 'class' and newcontent not in classes
      classes.push(newcontent)
      robot.brain.set 'dndClasses', classes
    if newtype is 'location' and newcontent not in locations
      locations.push(newcontent)
      robot.brain.set 'dndLocations', locations
    if newtype is 'backstory' and newcontent not in backstories
      backstories.push(newcontent)
      robot.brain.set 'dndBackstories', backstories
    robot.brain.save
    msg.reply "Added new #{newtype}: #{newcontent}"

  robot.respond /remove (adjective|race|class|location|backstory) "([^\"]+)"/i, (msg) ->
    adjectives = robot.brain.get('dndAdjectives') or ['tough']
    races = robot.brain.get('dndRaces') or ['elf']
    classes = robot.brain.get('dndClasses') or ['ranger']
    locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
    backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
    newtype = msg.match[1]
    newcontent = msg.match[2]
    if newtype is 'adjective'
      itemIndex = adjectives.indexOf(newcontent)
      adjectives.splice(itemIndex, 1)
      robot.brain.set 'dndAdjectives', adjectives
    if newtype is 'race'
      itemIndex = races.indexOf(newcontent)
      races.splice(itemIndex, 1)
      robot.brain.set 'dndRaces', races
    if newtype is 'class'
      itemIndex = classes.indexOf(newcontent)
      classes.splice(itemIndex, 1)
      robot.brain.set 'dndClasses', classes
    if newtype is 'location'
      itemIndex = locations.indexOf(newcontent)
      locations.splice(itemIndex, 1)
      robot.brain.set 'dndLocations', locations
    if newtype is 'backstory'
      itemIndex = backstories.indexOf(newcontent)
      backstories.splice(itemIndex, 1)
      robot.brain.set 'dndBackstories', backstories
    robot.brain.save
    msg.reply "Removed #{newtype}: #{newcontent}"

  robot.respond /list (adjective|race|class|location|backstory)/i, (msg) ->
    adjectives = robot.brain.get('dndAdjectives') or ['tough']
    races = robot.brain.get('dndRaces') or ['elf']
    classes = robot.brain.get('dndClasses') or ['ranger']
    locations = robot.brain.get('dndLocations') or ['the woodland kingdoms']
    backstories = robot.brain.get('dndBackstories') or ["doesn't take shit from anyone"]
    newtype = msg.match[1]
    if newtype is 'adjective'
      dndResponse = "Adjectives:\n```\""+adjectives.join('"\n"')+"\"```"
      msg.send dndResponse
    if newtype is 'race'
      dndResponse = "Races:\n```\""+races.join('"\n"')+"\"```"
      msg.send dndResponse
    if newtype is 'class'
      dndResponse = "Classes:\n```\""+classes.join('"\n"')+"\"```"
      msg.send dndResponse
    if newtype is 'location'
      dndResponse = "Locations:\n```\""+locations.join('"\n"')+"\"```"
      msg.send dndResponse
    if newtype is 'backstory'
      dndResponse = "Backstories:\n```\""+backstories.join('"\n"')+"\"```"
      msg.send dndResponse
