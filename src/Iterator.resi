type t<'value>
type getNext<'state, 'value> = 'state => option<'value>
let make: (~state: 'state, ~getNext: getNext<'state, 'value>) => t<'value>
let break: unit => unit
let continue: unit => unit
let forOf: (t<'a>, 'a => unit) => unit
exception Break
exception Continue