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

module Iterator = {
  type res<'a> = {
    value: 'a,
    done: bool,
  }
  type iter<'value> = {next: unit => res<'value>}
  type next<'state, 'value> = 'state => 'value
  type isDone<'state> = 'state => bool
  type t<'a>
  type symbolIterator
  external symbolIterator: symbolIterator = "Symbol.iterator"

  let make = (~state: 'state, ~next: next<'state, 'value>, ~isDone: isDone<'state>): t<'value> => {
    let innerDict = Js.Dict.empty()

    innerDict->Js.Dict.set(Obj.magic(symbolIterator), () => {
      next: () => {
        let done = isDone(state)
        {value: next(state), done}
      },
    })

    innerDict->Obj.magic
  }
}

let counter = Iterator.make(
  ~state=ref(0),
  ~next=count => {
    let value = count.contents
    count := count.contents + 1
    value
  },
  ~isDone={
    count => {
      // Js.log(count.contents)
      count.contents > 10
    }
  },
)

%%raw(`
// console.log(counter[Symbol.iterator])


for (let count of counter) {
  console.log(count)
}
`)
