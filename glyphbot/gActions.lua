local runBotCommand = endAction(
  function(arg)
    -- make sure errors is nil before executing
    if arg.errors ~= nil then return end
    arg.botCommands[arg.commandConfig.command]()(arg)
  end
)

local configCommand = endAction(
  function(arg)
    arg.commandConfig = {
      command = '',
      args = {}
    }
    for word in arg.messageContent:gmatch('%w+') do
      if arg.commandConfig.command == ''
      then arg.commandConfig.command = word
      else table.insert(arg.commandConfig.args, word)
      end
    end
  end
)

local botActionError = endAction(
  function(arg)
    -- 'reply' to user that the command doesn't exist
    debugLog('Error: ' .. arg.commandConfig.command .. ' is not a valid bot command.')({})
  end
)

local validGlyphError = endAction(
  function(arg)
    -- 'reply' to user that the glyph doesn't exist
    debugLog('Error: ' .. arg.commandConfig.args[1] .. ' is not a valid glyph.')({})
  end
)

local adminError = endAction(
  function(arg)
    -- 'reply' to user they can't access this
    debugLog('Error: ' .. arg.username .. ' is not allowed to use commands.')({})
  end
)

local replyWithError = endAction(
  function(arg)
    if arg.errors.validCommandError ~= nil then
      botActionError()(arg)
    elseif arg.errors.validGlyphError ~= nil then
      validGlyphError()(arg)
    else
      adminError()(arg)
    end
  end
)

local appendData = endAction(
  function(arg, key, value)
    arg[key] = value
  end
)

-- todo: move to conditionals
local userIsAdmin = conditional(
  function(arg)
    if arg.admins[arg.username] == nil then
      arg.errors = { adminError = true }
      return false
    end
    return true
  end
)

foundationAdd({
  'runBotCommand configCommand botActionError validGlyphError replyWithError appendData adminError userIsAdmin',
  runBotCommand, configCommand, botActionError, validGlyphError, replyWithError, appendData, adminError, userIsAdmin
})