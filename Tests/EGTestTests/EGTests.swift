import XCTest
@testable import EGTest

class Demo {
  func stringOfSum(_ a: Int, _ b: Int) -> String {
    return "\(a + b)"
  }
}

extension String: Error {}

func iAlwaysThrow() throws -> String { throw "I threw" }
func iNeverThrow() throws -> String { "a string" }

final class ExampleTests: XCTestCase {
  func testStringOfSumAllPass() {
    check(
      EG((-1, 1), expect: "0", "zero"),
      eg((3, 0), expect: "3", "one-digit"),
      eg((-2, 1), expect: "-1", "negative")
    ) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      XCTAssertEqual(actual, example.expect, example.msg(), file: example.file, line: example.line)
    }
  }
  
  func testCheckUsingAnArray_NotRecommended() {
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

  func test_EGAssertEqual() {
    check(
      EG((-1, 1), expect: "0", "zero"),
      eg((3, 0), expect: "3", "one-digit"),
      eg((-2, 1), expect: "-1", "negative")
    ) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      EGAssertEqual(actual, example)
    }
  }

  func test_EGAssertEqualWithAccuracy() {
    let eg = EG(1.0009, expect: 1.0, "with fuzz")
    EGAssertEqual(eg.input, eg, accuracy: 0.001)
  }

  func test_EGAssertEqualWithAccuracy_fails() {
    XCTExpectFailure("out of range")
    let eg = EG(1.0011, expect: 1.0, "out of range")
    EGAssertEqual(eg.input, eg, accuracy: 0.001)
  }

  func testStringOfSumWithFailingTests() {
    XCTExpectFailure("wrong output")
    
    check(
      eg((-1, 1), expect: "11", "will be zero"),
      eg((2,3), expect: "5", "should pass")
    ) { example in
      let my = Demo()
      let actual = my.stringOfSum(example.input.0, example.input.1)
      XCTAssertEqual(example.expect, actual, example.msg(), file: example.file, line: example.line)
    }
  }
  
  func testParameterizedTestWithEmptyList() {
    let empty: [EG<Int,String>] = []
    check(empty) { _ in XCTFail("no test should run") }
  }

  func testAssertThrowsFails_WhenNothingThrown() {
    XCTExpectFailure("should report an error")

    EGAssertThrowsError({ }, eg("ignored", expect: "thrown message"))
  }

  func testAssertThrowsSucceeds_WhenErrorIsThrown() throws {
    EGAssertThrowsError(try iAlwaysThrow(), eg("ignored", expect: "unused"))
  }

  func testAssertThrowsFails_WhenThrownErrorIsntRight() {
    XCTExpectFailure("should report an error")

    EGAssertThrowsError(try iAlwaysThrow(), eg("ignored", expect: "somebody threw")) { example, error in
      let actualMessage: String = error as! String
      EGAssertEqual(actualMessage, example)
    }
  }
  
  func testAssertThrowsSucceeds_WhenThrownAndErrorIsRight() {
    EGAssertThrowsError(try iAlwaysThrow(), eg("ignored", expect: "I threw")) { example, error in
      let actualMessage: String = error as! String
      EGAssertEqual(actualMessage, example)
    }
  }

  func test_checkWorksWithMethodsThatThrow() throws {
    try check(
      EG("ignored", expect: "a string")
    ) {
      EGAssertEqual(try iNeverThrow(), $0)
    }
  }

  func test_checkReportsIncorrectValuesWithMethodsThatThrow() throws {
    XCTExpectFailure("should report an error comparing strings")

    try check(
      EG("ignored", expect: "a wrong string")
    ) {
      EGAssertEqual(try iNeverThrow(), $0)
    }
  }

  func test_checkReportsErrorThrown() throws {
    XCTExpectFailure("should report a thrown error")

    try check(
      EG("ignored", expect: "a wrong string")
    ) {
      EGAssertEqual(try iAlwaysThrow(), $0)
    }
  }

  func testAllPairsEmpty() {
    let result = allPairs(["a", "b", "c"], Array<Int>())
    XCTAssertEqual(result.count, 0)
  }  
  
  func testAllPairsNotEmpty() {
    let result = allPairs([0,1,2], [3,4])
    XCTAssertEqual(result.count, 3*2)
    XCTAssertEqual(result[0].0, 0)
    XCTAssertEqual(result[0].1, 3)
    XCTAssertEqual(result[5].0, 2)
    XCTAssertEqual(result[5].1, 4)
  } 
  
  func testAllTriplesEmpty() {
    let result = allTriples(["a","b","c"], Array<Int>(), [0,2])
    XCTAssertEqual(result.count, 0)
  }
  
  func testAllTriplesNotEmpty() {
    let result = allTriples([0,1,2], ["abacus"], [3,4])
    XCTAssertEqual(result.count, 3*1*2)
    XCTAssertEqual(result[0].0, 0)
    XCTAssertEqual(result[0].1, "abacus")
    XCTAssertEqual(result[0].2, 3)
    
    XCTAssertEqual(result[5].0, 2)
    XCTAssertEqual(result[5].1, "abacus")
    XCTAssertEqual(result[5].2, 4)
  } 
}
