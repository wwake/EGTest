//
//  ExampleTests.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import XCTest
@testable import PTestPackage

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
  
  func testStringOfSumAllFailing() {
    XCTExpectFailure("wrong output")
    
    check(
      [
        eg(input: (-1, 1), output: "11", "will be zero")
      ]) { p in
        let my = Demo()
        let actual = my.stringOfSum(p.input.0, p.input.1)
        XCTAssertEqual(p.output, actual, p.msg())
      }
  }
  
  func testParameterizedTestWithEmptyList() {
    let empty: [EG<Int,String>] = []
    check(empty) { _ in XCTFail("any test fails") }
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

