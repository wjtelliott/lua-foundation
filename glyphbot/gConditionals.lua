local messageIsPrefixed = conditional(
  function(arg)
    if type(arg.messageContent) ~= 'string' then return false end
    return string.sub(arg.messageContent, 1, 1) == '!'
  end
)

local botCommandExists = conditional(
  function(arg)
    if arg.botCommands[arg.commandConfig.command] == nil then
      arg.errors = { validCommandError = true }
      return false
    end
    return true
  end
)

local glyphIsValid = conditional(
  function(arg)
    if arg.glyphs[arg.commandConfig.args[1]] == nil then
      arg.errors = { validGlyphError = true }
      return false
    end
    return true
  end
)

local botHadAnError = conditional(
  function(arg)
    return arg.errors ~= nil
  end
)

foundationAdd({
  'messageIsPrefixed botCommandExists glyphIsValid botHadAnError',
  messageIsPrefixed, botCommandExists, glyphIsValid, botHadAnError
})