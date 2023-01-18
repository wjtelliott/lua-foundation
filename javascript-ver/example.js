const {
  pipe,
  log,
  wait,
  ifThe,
  sanity,
  ifTheElse,
  forLoop,
  startLoopAt,
  stopLoopAt,
  iterateCounter,
  endAction,
} = require("./foundation.js");

const testData = {
  test: "thing",
};

const customs = {
  printCounter: endAction(
    async (arg) => await log(`Counter: ${arg?.loopData?.counter}`)(arg)
  ),
};

pipe(
  //
  log("asd"),
  wait(1000),
  ifThe(sanity(true))(
    //
    log("in if"),
    ifTheElse(sanity(true))({
      actions: [log("actions"), log("cool it works!")],
      elseActions: [log("else actions")],
    })
  ),
  forLoop(startLoopAt(0))(stopLoopAt(5))(iterateCounter(1))(
    //
    customs.printCounter(),
    log("iteration!")
  )
)(testData);
