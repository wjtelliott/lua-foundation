require 'foundation'
require 'xmas.xmasConditionals'
require 'xmas.xmasActions'
require 'mainActions'

-- use some example data
local exampleData = {
  username = 'Santa123',
  listCheckedTwice = false,
  likesToCode = true
}

local oneoff = {
  printLoopCounter = endAction( function(arg) print(arg.loopData.counter) end ),
  loopNeedsToBreak = conditional(
    function(arg)
      return arg.loopData.counter > 5
    end
  ),
  five = conditional( function(arg)
    return arg.loopData.counter < 15
  end )
}

-- pipeline
pipe(

  forLoop(startLoopAt(0))
  (stopLoopAt(500))
  (iterateCounter(1))(
    oneoff.printLoopCounter(),
    wait(0.25),
    ifThe(oneoff.loopNeedsToBreak())(
      debugLog('Counter is 6 or greater, breaking loop now'),
      breakLoop()
    )
  ),

  runBasicIfTest(),
  runIfElseTest(),

  -- test if/elseif/elseif...
  debugLog('\n\n-- SOME() TEST --'),
  wait(),
  testSomeThings(),

  debugLog('\n\n-- ARGS DISPLAY --'),
  wait(),
  displayArgs(),

  -- check list, change list, check changes
  debugLog('\n\n-- CHECK XMAS LIST --'),
  wait(),
  ifThe(userNameStartsWithS())(checkListTwice()),

  debugLog('\n\n-- ARGS DISPLAY AFTER CHANGES --'),
  wait(),
  displayArgs(),

  -- test custom action with variable args
  debugLog('\n\n-- TEST CUSTOM FUNCTION WITH VARYING ARGS --'),
  wait(),
  testFuncWithArgs('first', 'last')

)(exampleData)
