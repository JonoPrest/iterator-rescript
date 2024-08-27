type res<'a> = {
  value: option<'a>,
  done: bool,
}
type iter<'value> = {next: unit => promise<res<'value>>}
type getNext<'state, 'value> = 'state => promise<option<'value>>
type symbolAsyncIterator
external symbolAsyncIterator: symbolAsyncIterator = "Symbol.asyncIterator"

type t<'a>

let make = (~state: 'state, ~getNext: getNext<'state, 'value>): t<'value> => {
  let innerDict = Js.Dict.empty()

  innerDict->Js.Dict.set(Obj.magic(symbolAsyncIterator), () => {
    next: async () => {
      let value = await getNext(state)
      {value, done: value->Belt.Option.isNone}
    },
  })

  innerDict->Obj.magic
}

@module("./InjectedForLoop.js") external forAwaitOf: (t<'a>, 'a => unit) => unit = "forAwaitOf"
@module("./InjectedForLoop.js") external forAwaitOfAsync: (t<'a>, 'a => promise<unit>) => promise<unit> = "forAwaitOfAsync"
@module("./InjectedForLoop.js") @val external break: exn = "kBreak"
@module("./InjectedForLoop.js") @val external continue: exn = "kContinue"
