## Retreat Note: Iterators and for-of loops

We (@cometkim, @JonoPrest, @cristianoc) discussed the roadmap and detailed design of the iterator support in the ReScript Retreat 2024.

We started our discussion by agreeing that there are many use cases for JavaScript iterators. e.g. FFIs, Streams, User-defined data structures, etc.

We categorized the problem into two major topics which are:

1. How to use iterators in ReScript?
2. How to build iterators in ReScript?

### How to use iterators in ReScript?

#### Bind to ES iterator helpers

There are functional utilities called "[iterator helpers](https://github.com/tc39/proposal-iterator-helpers/)" which is already reached stage 3 (it means it's semi-standard and already has started to be implemented & shipped)

Its interfaces are matched with idiomatic ReScript (a function-style) so pretty easy to bind

#### Add intrinsics for iterators

Add the `Interator.t` and `AsyncIterator.t` type corresponding to JS intrinsic.

```
module Iterator = {
  type t<'a>
}

module AsyncIterator = {
  type t<'a>
}
```

Those types should be the base types for runtime libraries, type checking, and backend specializations to be added later.

We can add it to the `Js` module, but the switching to `Core` library is currently in progress so we can coordinate the work to avoid conflicts.

#### Add pseudo for-of & break/continue

`break` and `continue`, those are keywords and semantics that OCaml doesn't have. Any remaining checks in the loop should be passed when they are used.

So we explored two options with may similar semantics in OCaml:

1. raise exn
2. perform effect

The effects is a lower level generalization, but due to lack of compatibility (it requires OCaml 5.1+) and `exn` being sufficient to implement `break`/`continue`, we did not explore it deeper.

```
module Syntax = {
  @module("rescript/internal/forOf")
  @val external break: exn = "kBreak"

  @module("rescript/internal/forOf")
  @val external continue: exn = "kContinue"
  
  @module("rescript/internal/forOf")
  external forOf: (t<'a>, 'a => unit) = "forOf"
  
  // OCaml-side mapper
  // let (let*) = forOf
}
```

So using `exn` we can simulate `break` and `continue` as this:

```
// using `raise` internally makes OCaml type system analyse the control-flow correctly
switch n {
  | 10 => raise(break)
  | n => Console.log(n)
}
```

It can be implemented as a valid runtime even before specialization in the backend. e.g.

```js
export const kBreak = Symbol();
export const kContinue = Symbol();

export const forOf = (iterator, fn) => {
  for (let body of iterator) {
    try {
      fn(body);
    } catch (exn) {
      if (exn === kBreak) break;
      if (exn === kContinue) continue;
      throw exn;
    }
  }
};
```



#### Add real for-of syntax

As with any new syntax, we have to compromise on mapping it to the OCaml parsetree.

There is almost no similarity between OCaml's for...in loop syntax and for JS' for-of. So we will extend this to let binding.

```
let _ = for (let item of t->iter) {
  if (item === 100) {
    %break
  } else {
    %continue
  }
}
```

Will become into:

```ocaml
let _ = {
  let open Iterator.Syntax in
  let* item = t->iter in
  if (item === 100) {
    raise (break)
  } else {
    raise (continue)
  }
}
```

in OCaml representation, and this has a fully valid runtime implementation as described in the previous section.

```javascript
{
  let iter = t
  loop: for (let item of iter) {
    if (item === 100) {
      break loop;
    } else {
      continue loop;
    }
  }
}
```

The output is eventually adjusted to be specialized as a regular for-of loop.



### How to build iterators in ReScript?

If iteration is needed, users can write it using JavaScript and bind it through FFI.

But can't they create an Iterator in pure ReScript? We explored several methods which could make it possible.

#### Add helper to build iterator over iteration protocol

There are two patterns for creating iterators in JS. The first is to use an object with the iteration protocol, and the second is to use a generator. What both have in common is both are stateful somehow.

We explored ways to abstract the iteration protocol at the module level, but found nothing suitable.

Instead, @JonoPrest suggested a library code to build iterable objects in ReScript. From https://github.com/JonoPrest/iterator-rescript/

This could be a good intermediate solution until syntax support is added.

#### Add generator syntax

Ultimately, the generator syntax will be introduced as the most convincing way to handle stateful iteration in the language. It makes iterations customizable with an easy-to-understand old-good direct syntax, and the JavaScript stacktrace is fully traceable.

ReScript generator functions may annotated as `gen` just like `async` ones.

```
let genFn = gen (params) => {
  let k = yield 1;
  Console.log(k);
  k * k;
}
```

Generator is not simple. There are at least three type arguments

```
module Generator = {
  type t<'value, 'next, 'return>
}
```

and the type system must capture and infer all of them. Therefore, generator functions have this internal representation differently from regular functions.

```
let genFn = Generator.make((gen) => (params) => {
  let k = gen.yield(1)
//    ^ next        ^ value

  Console.log(k)

  gen.return(k * k)
//           ^ return

  gen
// ^ Generator.t<value, next, return>
})
```

// TBD

```
let genFn = (() => function*() {
  let k = yield 1;
  
  console.log(k);
  
  return k * k;
})();
```





### Implementation plan

TBD
