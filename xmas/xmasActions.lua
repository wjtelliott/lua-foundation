local checkListTwice = endAction(
  function(arg)
    print('Checking list...')
    if arg == nil or type(arg) ~= 'table' then return end
    arg.listCheckedTwice = true
  end
)

local testFuncWithArgs = endAction(
  function(arg, str1, str2)
    print(str1)
    print('and then')
    print(str2)
  end
)

-- test 'some' command. (replaces if elseif elseif elseif...)
local testSomeThings = endAction(
  function(arg)
    some({
      ifThe(sanity(false))(debugLog('will not see this log')),
      ifThe(sanity(true))(
        ifThe(sanity(true))(debugLog('Should see this log!')),
        debugLog('Also this one')
      ),
      ifThe(sanity(true))(debugLog('also dont see this log, even though its true'))
    })(arg)
  end
)

local displayArgs = endAction(
  function(arg)
    local name = tostring(arg.username)
    local checked = tostring(arg.listCheckedTwice)
    local codes = tostring(arg.likesToCode)
    local favLang = tostring(arg.favoritelanguage)
    print('Username is ' .. name)
    print('Checked list twice is ' .. checked)
    print('Likes to code: ' .. codes)
    print('fav lang: ' .. favLang)
  end
)

local addField = endAction(
  function(arg, fieldName, fieldValue)
    arg[fieldName] = fieldValue
  end
)

foundationAdd({
  'checkListTwice printSantasList testFuncWithArgs testSomeThings testPipeThings displayArgs addField',
  checkListTwice,
  printSantasList,
  testFuncWithArgs,
  testSomeThings,
  testPipeThings,
  displayArgs,
  addField
})
