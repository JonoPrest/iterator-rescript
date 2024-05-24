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
    | _ => raise(Iterator.Continue)
  }
  Js.log(str)
})

// type rec fileTree = File({name: string}) | Dir({name: string, child: fileTree})
//
// for i in 0 to 100 {
//   ()
// }
