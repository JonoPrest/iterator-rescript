/*
function makeCounter() {
  let count = 0;
  let done = false;

  return {
    [Symbol.iterator]: () => {
      return {
        async next() {
          if (done) {
            return { value: count, done };
          }
          if (count < 10) {
            return { value: count++, done: false };
          } else {
            done = true;
            return { value: count++, done: true };
          }
        },
        return() {
          this.done = true;
        },
      };
    },
  };
}

async function* genCounter() {
  let count = 0;
  while (count < 10) {
    yield count++;
  }
  return undefined;
}

let iter = makeCounter();
let gen = genCounter();

console.log('iter', [...iter]);
console.log('gen', [...gen]);
*/
type res<'a> = {
  value: option<'a>,
  done: bool,
}
type iter<'value> = {next: unit => res<'value>}
type getNext<'state, 'value> = 'state => option<'value>
type symbolIterator
external symbolIterator: symbolIterator = "Symbol.iterator"

type t<'a>

let make = (~state: 'state, ~getNext: getNext<'state, 'value>): t<'value> => {
  let innerDict = Js.Dict.empty()

  innerDict->Js.Dict.set(Obj.magic(symbolIterator), () => {
    next: () => {
      let value = getNext(state)
      {value, done: value->Belt.Option.isNone}
    },
  })

  innerDict->Obj.magic
}

@module("./InjectedForLoop.js") external forOf: (t<'a>, 'a => unit) => unit = "forOf"
@module("./InjectedForLoop.js") external forOfAsync: (t<'a>, 'a => promise<unit>) => promise<unit> = "forOfAsync"

@module("./InjectedForLoop.js") @val external break: exn = "kBreak"
@module("./InjectedForLoop.js") @val external continue: exn = "kContinue"
