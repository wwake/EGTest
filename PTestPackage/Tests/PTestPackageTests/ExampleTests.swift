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
  
  func checkCommutative<T: Equatable>(_ op: (T, T) -> T, _ a: T, _ b: T, _ file: StaticString = #file, _ line : UInt = #line) {
    if (op(a,b) == op(b,a)) { return }
    
    XCTAssertEqual(op(a,b), op(b,a), "operation does not commute for \(a) and \(b)", file: file, line: line)
  }
  
  func allPairs<T: Equatable>(
    _ values: [T], 
    _ closure: (T,T) -> Void
  ) {
    for a in values {
      for b in values {
        closure(a, b)
      }
    }
  }
  
  func checkCommutative<T: Equatable>(_ op: (T, T) -> T, _ values: [T], _ file: StaticString = #file, _ line : UInt = #line) {
    
    allPairs(values) { (a,b) in
      checkCommutative(op, a, b, file, line)
    }
  }
  

  func testCommutativePlus() {
    let a = 3
    let b = 4
    
    checkCommutative(+, a, b)
  }
  
  let ints = [-4, -1, 0, 1, 99]
  
  func testParameterizedCommutative() {
    checkCommutative(+, ints)
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
