# EGTest

This package is for parameterized testing.

## Top-Level Struct
**`EG`** - ("for example") - a struct to hold inputs and outputs. You typically create an array of `EG` values, then pass them to the `check()` method.

EG's fields:

* __input__: Input (generic) - the input arguments; use a tuple (or wrap in a struct or class) for multiple values. Use it to compute the actual value for your assertions.
* __expect__: Output (generic) (label required) - the expected output. Use it to compute the expected value for your assertions. 
* __message__: String - a message you can attach to your assertions. Defaults to an empty string.
* __file__: StaticString - the file name you would typically include as an argument to your assertions. Defaults to `#file`, so you usually omit this argument. 
* __line__: UInt - the line number you would typically include as an argument to your assertions. Defaults to `#line`, so you usually omit this argument.

Example:
```
EG("abcd", expect: 4, "length > 0")
```

**`msg()`** - provides the message from the EG struct, prefixed by its line number. You can use this as the message to your assertions.

## Top-Level Functions
**`EGAssertEqual()`** - calls XCTAssertEqual, passing it the expected value, message, file, and line number from the EG instance. If the actual type is not equatable, you'll need to use XCTAssertEqual directly.

```
  func EGAssertEqual<T: Equatable, Input>(
      _ actual: T, 
      _ expected: EG<Input, T>
  )
```

**`EGAssertThrowsError()`** - calls XCTAssertThrowsError, passing it the expression, the message from the example, and an optional function that can compare the example and the error.

```
public func EGAssertThrowsError<Ignored, Input, Expected: Equatable>(
  _ expression: @escaping @autoclosure () throws -> Ignored,
  _ example: EG<Input, Expected>
)
```
and 
```
public func EGAssertThrowsError<Ignored, Input, Expected: Equatable>(
  _ expression: @escaping @autoclosure () throws -> Ignored,
  _ example: EG<Input, Expected>,
  _ errorHandler: (EG<Input, Expected>, Error) -> Void
)
```

## XCTestCase Extensions
**`eg()`** - lets you create `EG` examples with the lower-case name `eg`. Takes the same arguments as the `EG` struct.

**`check()`** - runs a list of test cases against an assertion. With XCT assert functions, pass in the file and line so that your test case is highlighted if the assertion fails.

```
func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ assertFunction: (EG<Input, Output>) -> ()) {...}
```

**`check() throws`** - like check(), but allows you to call an assertion that might fail.

```
  func check<Input, Output>(
    _ tests: EG<Input, Output>...,
    assertFunction: (EG<Input, Output>) throws -> Void
  ) throws 
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

# Examples
Note that the `XCTAssertEqual` call passes the file and line. To see the difference in reporting, make a test case fail, run it, and compare it to what happens when file and line are omitted. 
The second example shows the same test using EGAssertEqual.

```
class Demo {
  func stringOfSum(_ a: Int, _ b: Int) -> String {
    return "\(a + b)"
  }
}

final class ExampleTests: XCTestCase {
  func testStringOfSumAllPass() {
    check([
      EG((-1, 1), expect: "0", "zero"),
      eg((3, 0), expect: "3", "one-digit"),
      eg((-2, 1), expect: "-1", "negative")
    ]) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      XCTAssertEqual(actual, example.expect, example.msg(), file: example.file, line: example.line)
    }
  }
}

final class ExampleTests2: XCTestCase {
  func testStringOfSumAllPass() {
    check([
      EG((-1, 1), expect: "0", "zero"),
      eg((3, 0), expect: "3", "one-digit"),
      eg((-2, 1), expect: "-1", "negative")
    ]) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      EGAssertEqual(actual, example)
    }
  }
}

```

```
  func iAlwaysThrow() throws { throw "I threw" }

  func testAssertThrowsSucceeds_WhenThrownAndErrorIsRight() {
    EGAssertThrowsError(try self.iAlwaysThrow(), eg("ignored", expect: "I threw")) { example, error in
      let actualMessage: String = error as! String
      EGAssertEqual(actualMessage, example)
    }
  }
```
