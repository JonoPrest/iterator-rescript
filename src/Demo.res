let counter = Iterator.make(~state=ref(0), ~getNext=count => {
  let value = count.contents
  if value > 10 {
    None
  } else {
    count := count.contents + 1
    Some(value)
  }
})

counter->Iterator.forOf(item => {
  let str = switch item {
  | 3 => "three"
  | _ => raise(Iterator.continue)
  }
  Js.log(str)
})

//Demonstrate fibonacci generator as per example here: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators#advanced_generators
/*
function* fibonacci() {
  let current = 0;
  let next = 1;
  while (true) {
    const reset = yield current;
    [current, next] = [next, next + current];
    if (reset) {
      current = 0;
      next = 1;
    }
  }
}

const sequence = fibonacci();
console.log(sequence.next().value); // 0
console.log(sequence.next().value); // 1
console.log(sequence.next().value); // 1
console.log(sequence.next().value); // 2
console.log(sequence.next().value); // 3
console.log(sequence.next().value); // 5
console.log(sequence.next().value); // 8
console.log(sequence.next(true).value); // 0
console.log(sequence.next().value); // 1
console.log(sequence.next().value); // 1
console.log(sequence.next().value); // 2
*/
type fibIter = {mutable currentN: int, mutable nextN: int}
let fibIter = Iter.makeWithNextInput(~state={currentN: 0, nextN: 1}, ~next=(state, ~input=?) => {
  let shouldReset = input->Belt.Option.getWithDefault(false)
  if shouldReset {
    state.currentN = 0
    state.nextN = 1
  }
  let {currentN, nextN} = state
  state.currentN = nextN
  state.nextN = currentN + nextN
  Some(currentN)
})

let sequence = fibIter->Iter.getSequence

Js.log("Fib sequence")
Js.log(sequence.next().value) // 0
Js.log(sequence.next().value) // 1
Js.log(sequence.next().value) // 1
Js.log(sequence.next().value) // 2
Js.log(sequence.next().value) // 3
Js.log(sequence.next().value) // 5
Js.log(sequence.next().value) // 8
Js.log(sequence.next(~input=true).value) // 0
Js.log(sequence.next().value) // 1
Js.log(sequence.next().value) // 1
Js.log(sequence.next().value) // 2
