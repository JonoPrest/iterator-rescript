export const kBreak = Symbol();
export const kContinue = Symbol();

export const forOf = (iterator, fn) => {
  for (let body of iterator) {
    try {
      fn(body);
    } catch (exn) {
      if (exn === kBreak) {
        break;
      }
      if (exn === kContinue) {
        continue;
      }
      throw exn;
    }
  }
};

export const forOfAsync = async (iterator, fn) => {
  for (let body of iterator) {
    try {
      await fn(body);
    } catch (exn) {
      if (exn === kBreak) {
        break;
      }
      if (exn === kContinue) {
        continue;
      }
      throw exn;
    }
  }
};

export const forAwaitOf = async (iterator, fn) => {
  for await (let body of iterator) {
    try {
      fn(body);
    } catch (exn) {
      if (exn === kBreak) {
        break;
      }
      if (exn === kContinue) {
        continue;
      }
      throw exn;
    }
  }
};

export const forAwaitOfAsync = async (iterator, fn) => {
  for await (let body of iterator) {
    try {
      await fn(body);
    } catch (exn) {
      if (exn === kBreak) {
        break;
      }
      if (exn === kContinue) {
        continue;
      }
      throw exn;
    }
  }
};

