const PIPE_END = "$PIPE_END";
const PIPE_NEST = "$PIPE_NEST";

const endAction =
  (callback) =>
  (...actions) =>
  async (arg) => {
    await callback(arg, ...actions);
  };

const endActionResult =
  (callback) =>
  (...actions) =>
  async (arg) =>
    await callback(arg, ...actions);

const log = endAction((arg, str) => console.log(str));
const error = endAction((arg, str) => console.error(str));

const pipe =
  (...actions) =>
  async (arg) => {
    if (arg?.fVerbose) {
      await log("Entering new pipe...")(arg);
    }
    for (let i = 0; i < actions.length; i++) {
      if (typeof actions[i] !== "function") continue;
      const actionResult = await actions[i](arg);
      if (actionResult === PIPE_END) return PIPE_END;
      if (actionResult === PIPE_NEST) return;
      if (Array.isArray(actionResult)) {
        const recurResult = await pipe(...actionResult)(arg);
        if (recurResult === PIPE_END) return PIPE_END;
      }

      if (arg?.fVerbose) await error("Error processing pipe result")(arg);
    }
  };

const checkConditional =
  (callback) =>
  (condition) =>
  (...actions) =>
  async (arg) => {
    if (actions?.[0]?.elseActions) {
      const { actions: _actions, elseActions: _elseActions } = actions[0];
      return await callback(condition, _actions, _elseActions, arg);
    }
    return await callback(condition, actions, arg);
  };

const conditional =
  (callback) =>
  (...extraArgs) =>
  async (arg) => {
    const condResult = await callback(arg, ...extraArgs);
    if (typeof condResult !== "boolean") {
      if (arg?.fVerbose) await error("Conditional gave non-bool value")(arg);
      return false;
    }
    return condResult;
  };

const ifThe = checkConditional(async (condition, actions, arg) => {
  if (await condition(arg)) return actions;
});

const ifNotThe = checkConditional(async (condition, actions, arg) => {
  if (!(await condition(arg))) return actions;
});

const ifTheElse = checkConditional(
  async (condition, actions, elseActions, arg) =>
    (await condition(arg)) ? actions : elseActions
);

const some =
  (...actions) =>
  async (arg) => {
    for (let i = 0; i < actions.length; i++) {
      const actionResult = await actions[i](arg);
      if (Array.isArray(actionResult)) {
        if ((await pipe(...actionResult)(arg)) === PIPE_END) return PIPE_END;
      }
    }
  };

const loopWhile =
  (condition) =>
  (...actions) =>
  async (arg) => {
    while (await condition(arg)) {
      if ((await pipe(...actions)(arg)) === PIPE_END) return PIPE_END;
    }
  };

// switch here

const wait = endAction(async (arg, time) => {
  await log(`Waiting for ${time}ms...`)(arg);
  await new Promise((resolve) => setTimeout(resolve, time));
});
const sanity = conditional((arg, b) => b);

const forLoop =
  (initial, safelyEndAt = 200) =>
  (condition) =>
  (iteration) =>
  (...actions) =>
  async (arg) => {
    let failsafe = 0;
    await initial(arg);
    while (await condition(arg)) {
      for (let i = 0; i < actions.length; i++) {
        if (typeof actions[i] !== "function") continue;
        const actionResult = await actions[i](arg);
        if (Array.isArray(actionResult)) {
          if ((await pipe(...actionResult)(arg)) === PIPE_END) return PIPE_END;
        }
        if (arg?.loopData?.finished) break;
      }
      failsafe++;
      if (arg?.loopData?.finished) break;
      if (failsafe > safelyEndAt) {
        await log("loop iterated too many times, failsafe break")(arg);
        break;
      }
      await iteration(arg);
    }
    delete arg?.loopData;
  };

const startLoopAt = endAction(async (arg, index) => {
  arg.loopData = {
    finished: false,
    counter: 0,
  };

  if (typeof index === "function") return await index(arg);
  arg.loopData.counter = index;
});

const stopLoopAt = conditional(async (arg, callback) => {
  if (arg?.loopData == null) return false;
  if (arg.loopData.finished === true) return false;
  if (callback == null) return arg.loopData.finished;
  if (typeof callback === "function") return await callback(arg);

  // callback is num
  return arg?.loopData?.counter < callback;
});

const iterateCounter = endAction(async (arg, callbackOrIndex) => {
  if (arg?.loopData == null) {
    if (arg) arg.loopData = { finished: true };
    return;
  }
  if (typeof callbackOrIndex === "function") {
    await callbackOrIndex(arg);
    return;
  }
  arg.loopData.counter += callbackOrIndex;
});

const breakLoop = endAction(async (arg) => {
  if (arg?.loopData == null) {
    if (arg) arg.loopData = { finished: true };
    return;
  }
  arg.loopData.finished = true;
});

const breakPipe = () => async (arg) => PIPE_END;
const breakNest = () => async (arg) => PIPE_NEST;

module.exports = {
  pipe,
  endAction,
  endActionResult,
  conditional,
  ifThe,
  ifNotThe,
  ifTheElse,
  log,
  wait,
  sanity,
  forLoop,
  startLoopAt,
  stopLoopAt,
  iterateCounter,
  breakPipe,
  breakNest,
  error,
  some,
  loopWhile,
  breakLoop,
};
