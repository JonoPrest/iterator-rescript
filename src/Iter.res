@@uncurried
type iterRes<'a> = {
  value: option<'a>,
  done: bool,
}
type sequence<'value, 'nextInput> = {next: (~input: 'nextInput=?) => iterRes<'value>}
type symbolIterator
external symbolIterator: symbolIterator = "Symbol.iterator"

type iterWithNextInput<'a, 'nextInput> = Js.Dict.t<unit => sequence<'a, 'nextInput>>

let makeWithNextInput: (
  ~state: 'state,
  ~next: ('state, ~input: 'nextInput=?) => option<'value>,
) => iterWithNextInput<'a, 'nextInput> = (~state, ~next) => {
  let innerDict = Js.Dict.empty()
  innerDict->Js.Dict.set(Obj.magic(symbolIterator), () => {
    next: (~input=?) => {
      let value = next(state, ~input?)
      {value, done: value->Belt.Option.isNone}
    },
  })
  innerDict
}

let getSequence = (iter: iterWithNextInput<'a, 'nextInput>): sequence<'a, 'nextInput> => {
  (iter->Js.Dict.get(Obj.magic(symbolIterator))->Belt.Option.getUnsafe)()
}

type t<'a> = iterWithNextInput<'a, unit>
let make = (~state: 'state, ~next: 'state => option<'value>) =>
  makeWithNextInput(~state, ~next=(state, ~input as _=?) => {next(state)})

let forOf: (iterWithNextInput<'a, 'nextInput>, 'a => unit) = %raw(`
 (iterator, fn) => {
  for (let body of iterator) {
      fn(body);
  }
}
`)
