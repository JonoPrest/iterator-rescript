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
  value: 'a,
  done: bool,
}
type iter<'value> = {next: unit => res<'value>}
type getNext<'state, 'value> = 'state => 'value
type isDone<'state> = 'state => bool
type symbolIterator
external symbolIterator: symbolIterator = "Symbol.iterator"

type t<'a>

let make = (~state: 'state, ~getNext: getNext<'state, 'value>, ~isDone: isDone<'state>): t<
  'value,
> => {
  let innerDict = Js.Dict.empty()

  innerDict->Js.Dict.set(Obj.magic(symbolIterator), () => {
    next: () => {
      let done = isDone(state)
      {value: getNext(state), done}
    },
  })

  innerDict->Obj.magic
}

exception Break
exception Continue
let break = () => raise(Break)
let continue = () => raise(Continue)

@module("./InjectedForOf.js") external forOf: (t<'a>, 'a => unit) => unit = "forOf"
