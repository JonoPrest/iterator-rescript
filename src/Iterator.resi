type t<'value>
type getNext<'state, 'value> = 'state => 'value
type isDone<'state> = 'state => bool
let make: (~state: 'state, ~getNext: getNext<'state, 'value>, ~isDone: isDone<'state>) => t<'value>
let break: unit => unit
let continue: unit => unit
let forOf: (t<'a>, 'a => unit) => unit
