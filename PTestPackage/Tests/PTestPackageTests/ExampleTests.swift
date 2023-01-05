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
  func testStringOfSum() {
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
  
  func testParameterizedTestWithEmptyList() {
    let empty: [EG<Int,String>] = []
    check(empty) { _ in XCTFail("any test fails") }
  }
  
  
  func testCheckCommutativeSucceeds() {
    checkProperty(.commutative, +, 3,4)
  }
  
  func testCheckCommutativeFails() {
    XCTExpectFailure("commutative -")
    checkProperty(.commutative, -, 3,4)
  }
  
  let ints = [-4, -1, 0, 1, 99]
  
  func testCombinatorialCommutativeSucceeds() {
    checkProperty(ints, +, .commutative)
  }
  
  func testCombinatorialCommutativeDetectsFailure() {
    XCTExpectFailure("commutative -: two bad values")
    let commutativeFailure = { 
      if $0 == 0 && $1 == 99 { return 100 }
      if $0 == 99 && $1 == 0 { return -1}
      return $0 + $1
    }
    
    checkProperty(ints, commutativeFailure, .commutative)
  }
  
  func testReflexiveSucceeds() {
    checkProperty(3, ==, .reflexive)
  }
  
  func testReflexiveFails() {
    XCTExpectFailure("reflexive > should fail")
    checkProperty(3, >, .reflexive)
  }
  
  func testSymmetricSucceeds() {
    checkProperty(3,4,==,.symmetric)
  }
  
  func testSymmetricFails() {
    XCTExpectFailure("symmetric <= should fail")
    checkProperty(3,4,<=,.symmetric)
  }
    
  func testTransitiveSucceeds() {
    checkProperty(3,4,5,<, .transitive)
  }
  
  func testTransitiveFails() {
    XCTExpectFailure("transitive != should fail")
    checkProperty(3, 4, 3, !=, .transitive)
  }
  
  func checkEquivalenceRelation<T>(_ a: T, _ b: T, _ c: T, _ op: @escaping (T,T) -> Bool) {
    checkProperty(a, op, .reflexive)
    checkProperty(b, op, .reflexive)
    checkProperty(c, op, .reflexive)
    
    checkProperty(a, b, op, .symmetric)
    checkProperty(b, c, op, .symmetric)
    checkProperty(a, c, op, .symmetric)
    
    checkProperty(a, b, c, op, .transitive)
    checkProperty(c, b, a, op, .transitive)
  }
  
  func testEquivalenceRelation() {
    let op = { a, b in (a % 3) == (b % 3)}
    checkEquivalenceRelation(3, 6, 9, op)
  }
}
