local runBasicIfTest = endAction(
  function(arg)
    pipe(
      debugLog('\n\n-- BASIC IF TEST --'),
      wait(),
      ifThe(userLikesToCode())(
        debugLog('User likes to code'),
        addField('favoritelanguage', 'Perl')
      )
    )(arg)
  end
)

local runIfElseTest = endAction(
  function(arg)
    pipe(
      debugLog('\n\n-- IF THE ELSE TEST --'),
      wait(),
      ifTheElse(sanity(true))({
        actions = {
          debugLog('shown true'),
          debugLog('we can chain these'),
          ifThe(sanity(true))(
            debugLog('even these...')
          )
        },
        elseActions = { debugLog('shown false') }
      })
    )(arg)
  end
)

foundationAdd({ 'runBasicIfTest runIfElseTest', runBasicIfTest, runIfElseTest })