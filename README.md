# EGTest

This package is for parameterized testing.

## Top-Level Struct
**`EG`** - ("for example") - a struct to hold inputs and outputs. You typically create an array of `EG`, then pass them to the `check()` method.


Example:
```
EG(input: "abcd", output: 4, message: "length > 0")
```

The input and output types are generic; you can use tuples to work with more than one value.

The message is optional. 

There are implicit file and line arguments that tie assertions to the line where the `EG` constructor is called. 


## XCTestCase Extensions
**`eg()`** - lets you create examples with the lower-case name eg. Takes the same arguments as the `EG` struct.

**`check()`** - runs a list of test cases against an assertion. With XCT assert functions, pass in the file and line so that your test case is highlighted if the assertion fails.

```
func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ assertFunction: (EG<Input, Output>) -> ()) {...}
```

**`allPairs()`** - Creates a list of pairs of any types.
```
  func allPairs<T1, T2>(
    _ t1s: [T1],
    _ t2s: [T2])
      -> [(T1,T2)]
```

**`allTriples()`** - Creates a list of triples of any types.
```
  func allTriples<T1, T2, T3>(
    _ t1s: [T1],
    _ t2s: [T2],
    _ t3s: [T3]) 
      -> [(T1, T2, T3)]
```

# Example
Note that the `XCTAssertEqual` call passes the file and line. To see the difference in reporting, make a test case fail, run it, and compare it to what happens when file and line are omitted. 

```
class Demo {
  func stringOfSum(_ a: Int, _ b: Int) -> String {
    return "\(a + b)"
  }
}

final class ExampleTests: XCTestCase {
  func testStringOfSumAllPass() {
    check([
      eg(input: (-1, 1), output: "0", "zero"),
      eg(input: (3, 0), output: "3", "one-digit"),
      eg(input: (-2, 1), output: "-1", "negative")
    ]) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      XCTAssertEqual(example.output, actual, example.msg(), file: example.file, line: example.line)
    }
  }
}
```
