-- make sure to run the file in lua dir
require 'foundation'
require 'xmas.xmasActions'

math.randomseed(os.time())
print('testing checkListTwice')

print('testing nil input')
checkListTwice()(nil)

print('testing no val on arg')
local noVal = {}
checkListTwice()(noVal)
if noVal.listCheckedTwice ~= true then error('failed no val') end

local counter = 0
while counter < 50 do
  counter = counter + 1

  local randomBool = math.random(0, 2) == 1 and true or false
  print('random bool input => ' .. tostring(randomBool))
  
  local testCase = {
    listCheckedTwice = randomBool
  }
  checkListTwice()(testCase)

  if testCase.listCheckedTwice ~= true then error('Failed randoms test case') end
  print('test case passed')
end
print('test suite pass')