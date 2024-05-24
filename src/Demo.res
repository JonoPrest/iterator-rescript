let counter = Iterator.make(
  ~state=ref(0),
  ~getNext=count => {
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

counter->Iterator.forOf(item => {
  if item == 2 {
    Iterator.continue()
  }
  if item == 7 {
    Iterator.break()
  }
  Js.log(item)
})
