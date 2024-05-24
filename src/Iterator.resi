type t<'value>
type getNext<'state, 'value> = 'state => option<'value>
let make: (~state: 'state, ~getNext: getNext<'state, 'value>) => t<'value>
let forOf: (t<'a>, 'a => unit) => unit
let break: exn
let continue: exn