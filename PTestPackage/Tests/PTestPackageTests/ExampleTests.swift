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
  
  
  func testCheckPropertySucceeds() {
    checkProperty(3,4,+,.commutative)
  }
  
  func testCheckPropertyFails() {
    XCTExpectFailure("commutative -")
    checkProperty(3,4,-,.commutative)
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

  func checkReflexive<T1>(
    _ value: T1,
    _ op: (T1, T1) -> Bool) {
        XCTAssertEqual(op(value, value), true)
  }
  
  func testReflexive() {
    checkReflexive(3, ==)
  }
  
  func checkSymmetric<T>(_ a: T, _ b: T, _ op: (T,T) -> Bool, _ name: String = "") {
    let result = op(a,b) == op(b,a)
    if result { return }
    XCTAssertEqual(op(a,b), op(b,a), "Operator '\(name)' is not symmetric for \(a) and \(b)")
  }
  
  func testSymmetric() {
    checkSymmetric(3, 4, ==)
  }
  
  func checkTransitive<T>(_ a: T, _ b: T, _ c : T, _ op: (T,T) -> Bool, _ name: String = "") {
    if (op(a,b) && op(b,c) && op(a,c)) { return }
    XCTFail("Operator is not transitive for values \(a), \(b), and \(c)")
  }
  
  func testTransitive() {
    checkTransitive(3, 4, 5, <)
  }
  
  func checkEquivalenceRelation<T>(_ a: T, _ b: T, _ c: T, _ op: (T,T) -> Bool) {
    checkReflexive(a, op)
    checkReflexive(b, op)
    checkReflexive(c, op)
    
    checkSymmetric(a, b, op)
    checkSymmetric(b, c, op)
    checkSymmetric(a, c, op)
    
    checkTransitive(a, b, c, op)
    checkTransitive(c, b, a, op)
  }
  
  func testEquivalenceRelation() {
    let op = { a, b in (a % 3) == (b % 3)}
    checkEquivalenceRelation(3, 6, 9, op)
  }
}
