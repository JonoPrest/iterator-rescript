// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Iterator from "./Iterator.res.mjs";

var counter = Iterator.make({
      contents: 0
    }, (function (count) {
        var value = count.contents;
        if (value > 10) {
          return ;
        } else {
          count.contents = count.contents + 1 | 0;
          return value;
        }
      }));

Iterator.forOf(counter, (function (item) {
        if (item === 2) {
          Iterator.$$continue();
        }
        if (item === 7) {
          Iterator.$$break();
        }
        console.log(item);
      }));

export {
  counter ,
}
/* counter Not a pure module */
