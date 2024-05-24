type t<'value>
type getNext<'state, 'value> = 'state => promise<option<'value>>
let make: (~state: 'state, ~getNext: getNext<'state, 'value>) => t<'value>
let forAwaitOf: (t<'a>, 'a => unit) => unit
let break: exn
let continue: exn