export const forOf = (iterator, fn) => {
  for (let body of iterator) {
    try {
      fn(body);
    } catch (exn) {
      if (exn.RE_EXN_ID.includes("Iterator.Break")) {
        break;
      }
      if (exn.RE_EXN_ID.includes("Iterator.Continue")) {
        continue;
      }
      throw exn;
    }
  }
};
