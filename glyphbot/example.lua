require 'foundation'
require 'glyphbot.gActions'
require 'glyphbot.gConditionals'

-- this program pretends to be the glyph bot

local botCommands = {
  add = endAction(
    function(arg)
      local quantity = 1
      if #arg.commandConfig.args > 1 then
        quantity = arg.commandConfig.args[2]
      end
      print('adding ' .. arg.commandConfig.args[1] .. ' x' .. tostring(quantity) .. ' to the database')
    end
  ),

  remove = endAction(
    function(arg)
      local quantity = 1
      if #arg.commandConfig.args > 1 then
        quantity = arg.commandConfig.args[2]
      end
      print('removing ' .. arg.commandConfig.args[1] .. ' x' .. tostring(quantity) .. ' from the database')
    end
  )
}

local validGlyphs = {
  ivor = 1,
  glen = 2
}

local admins = {
  kenny = 1,
  kyle = 2,
  jerry = 3
}

function runBotWithMessage(name, str) 
  local discordMessage = {
    username = name,
    messageContent = str
  }
  pipe(
    ifNotThe(messageIsPrefixed())(breakPipe()),

    configCommand(),
    appendData('botCommands', botCommands),
    appendData('glyphs', validGlyphs),
    appendData('admins', admins),

    ifNotThe(userIsAdmin())(
      replyWithError(),
      breakPipe()
    ),

    ifThe(botCommandExists())(
      ifThe(glyphIsValid())(runBotCommand())
    ),

    ifThe(botHadAnError())(replyWithError())

  
  )(discordMessage)
end

runBotWithMessage('sanity', 'hello world')
runBotWithMessage('justin', '!add ivor')
runBotWithMessage('jerry', '!remove glen')
runBotWithMessage('kenny', '!add ivor 7')
runBotWithMessage('kyle', '!kill the bot 9999')
runBotWithMessage('kyle', '!add everything haha')