# EGTest

This package is for parameterized testing.

* EG - a struct to hold inputs and outputs.
For example:
```
EG(input: "abcd", output: 4, message: "length > 0")
```

The input and output types are generic; you can use tuples to work with more than one value.

The message is optional. There are implicit file and line arguments that tie assertions to the line of the EG constructor. 


* eg() - lets you create examples with the lower-case name eg. Takes the same arguments as EG().

* check() - list of test cases against an assertion

```
func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ parameterizedAssert: (EG<Input, Output>) -> ()) {...}
```

* allPairs - Creates a list of pairs of any types (extends XCTestCase)
```
  func allPairs<T1, T2>(
    _ t1s: [T1],
    _ t2s: [T2])
      -> [(T1,T2)]
```

* allTriples - Creates a list of triples of any types (extends XCTestCase)
```
  func allTriples<T1, T2, T3>(
    _ t1s: [T1],
    _ t2s: [T2],
    _ t3s: [T3]) 
      -> [(T1, T2, T3)]
```

# Example
```
class Demo {
  func stringOfSum(_ a: Int, _ b: Int) -> String {
    return "\(a + b)"
  }
}

final class ExampleTests: XCTestCase {
  func testStringOfSumAllPass() {
    check(
      [
      eg(input: (-1, 1), output: "0", "zero"),
      eg(input: (3, 0), output: "3", "one-digit"),
      eg(input: (-2, 1), output: "-1", "negative")
      ]) { p in
        let my = Demo()
        let actual = my.stringOfSum(p.input.0, p.input.1)
        XCTAssertEqual(p.output, actual, p.msg())
      }
  }
}
```
