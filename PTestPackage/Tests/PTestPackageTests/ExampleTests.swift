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
    checkProperty(.commutative, +, ints)
  }
  
  func testCombinatorialCommutativeDetectsFailure() {
    XCTExpectFailure("commutative -: two bad values")
    let commutativeFailure = { 
      if $0 == 0 && $1 == 99 { return 100 }
      if $0 == 99 && $1 == 0 { return -1}
      return $0 + $1
    }
    
    checkProperty(.commutative, commutativeFailure, ints)
  }
  
  func testReflexiveSucceeds() {
    checkProperty(.reflexive, ==, 3)
  }
  
  func testReflexiveFails() {
    XCTExpectFailure("reflexive > should fail")
    checkProperty(.reflexive, >, 3)
  }
  
  func testSymmetricSucceeds() {
    checkProperty(.symmetric,==,3,4)
  }
  
  func testSymmetricFails() {
    XCTExpectFailure("symmetric <= should fail")
    checkProperty(.symmetric, <=, 3, 4)
  }
    
  func testTransitiveSucceeds() {
    checkProperty(.transitive, <, 3, 4, 5)
  }
  
  func testTransitiveFails() {
    XCTExpectFailure("transitive != should fail")
    checkProperty(.transitive, !=, 3, 4, 3)
  }
  
  func checkEquivalenceRelation<T>(_ a: T, _ b: T, _ c: T, _ op: @escaping (T,T) -> Bool) {
    checkProperty(.reflexive, op, a)
    checkProperty(.reflexive, op, b)
    checkProperty(.reflexive, op, c)
    
    checkProperty(.symmetric, op, a, b)
    checkProperty(.symmetric, op, b, c)
    checkProperty(.symmetric, op, a, c)
    
    checkProperty(.transitive, op, a, b, c)
    checkProperty(.transitive, op, c, b, a)
  }
  
  func testEquivalenceRelation() {
    let op = { a, b in (a % 3) == (b % 3)}
    checkEquivalenceRelation(3, 6, 9, op)
  }
  
  func testAssociativeSucceeds() {
    checkProperty(.associative, +, 2, 1, 3)
  }
  
  func testAssociativeFails() {
    XCTExpectFailure("associative - should fail")
    checkProperty(.associative, -, 1, 3, 4)
  }

}
