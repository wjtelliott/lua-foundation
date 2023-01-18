local userNameStartsWithS = conditional(
  function(arg)
    local firstLetter = string.sub(arg.username, 1, 1)
    return firstLetter == 's' or firstLetter == 'S'
  end
)

local userLikesToCode = conditional( function(arg) return arg.likesToCode or false end )

foundationAdd({ 'userNameStartsWithS userLikesToCode', userNameStartsWithS, userLikesToCode })
