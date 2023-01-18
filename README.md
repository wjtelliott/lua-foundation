
# Foundation

This is a small pet project to bring a crude
and custom pipeline for functional programming styles
to Lua, JavaScript, Python and other languages listed.

Most of the code will be rough transpiled versions of
each other, but still keeping the namings consistent.
## Core functions

`pipe, compose, ifThe, ifNotThe, ifTheElse, switch,
endAction, endActionResult, conditional, log, debugLog,
wait, sanity, forLoop, startLoopAt, stopLoopAt,
iterateCounter, breakPipe, breakNest, loopWhile, breakLoop`

Check documentation and FAQ for use. Function names and
availability vary by language version.
## Installation

Clone onto your local machine

```bash
git clone https://github.com/wjtelliott/lua-foundation.git
```

Run the lua version with command prompt:

```bash
cd lua-foundation
lua54 main.lua
```

Run the JavaScript version with node:

```bash
cd lua-foundation/javascript-ver
node example.js
```
## Documentation

*All examples will be in JavaScript.*
*The first code block will be Psuedo, followed by a
working example*

**endAction**: End Actions are the functions in which
logic is handled and changes are read and made to the
`argumentObject` passed through the pipeline.
```js
const myAction = endAction( callback function(argObj, ...) )
```
```js
const myAction = endAction((arg) => {
  console.log('Hello World!')
  console.log(JSON.stringify(arg))
})
```

**conditional**: Return a true/false value to a parent
function in the pipeline. Used to determine whether or
not to run following nested End Actions.
```js
const myConditional = conditional( callback function(argObj, ...) )
```
```js
const userIsAdult = conditional((arg) => {
  const userAge = arg?.userAge
  return userAge >= 18
})
```

**ifThe**: Basic IF statement with conditionals and
actions to execute.
```js
ifThe( conditional callback )( ...actions )[(argObject)]
```
```js
pipe(
  ifThe(userIsAdult())(
    log('User age >= 18 !')
  )
)({ userAge: 22 })
```

**Use `ifNotThe` for a 'not' version of this function**

**ifTheElse**: If/Else statement with actions and nesting
```js
ifTheElse( conditional callback )({
  actions: actions as array
  elseActions: actions as array
})
```
```js
pipe(
  ifTheElse(userIsAdult())({
    actions: [ log('User age >= 18 !') ],
    elseActions: [ log('User is 17 or younger') ]
  })
)({})
```

**pipe**: Used to create a new pipeline of `conditional`'s,
`endAction`'s, or `endActionResult`'s
```js
pipe(...actions)(argumentObject)
```
```js
pipe(
  log("Hello World")
)({})
```

***

Basic Example ( more found in codebase ):
```js
const customs = {
  userIsAdult: conditional(arg => arg?.userAge >= 18),
  displayNonAdult: endAction(async (arg) => {
    await log(`${arg?.username} is under required age!`)(arg)
  })
}

const testData = {
  userAge: 1,
  username: 'Johnny'
}

pipe(
  log('Starting...'),
  ifNotThe(customs.userIsAdult())(
    customs.displayNonAdult()
  ),

  forLoop(startLoopAt(0))
  (stopLoopAt(5))
  (iterateCounter(1))(
    log('Iteration!')
  )
)(testData)
```

Output Expectation:
```bash
Starting...
Johnny is under required age!
Iteration!
Iteration!
Iteration!
Iteration!
Iteration!
```

## Authors

- [@william-elliott](https://www.github.com/wjtelliott)

## About Me

I'm a full stack developer, currently employed as
a JavaScript programmer. I also develop games in
my free time.

Feel free to message me
questions and contributions to this project.