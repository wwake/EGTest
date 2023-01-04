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
    Check.examples(
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
  
  
  func checkCommutative<T: Equatable>(_ a: T, _ b: T, _ op: (T, T) -> T, _ file: StaticString = #file, _ line : UInt = #line) {
    XCTAssertEqual(op(a,b), op(b,a), "operation does not commute for \(a) and \(b)", file: file, line: line)
  }
  
  func testCommutativePlus() {
    let a = 3
    let b = 4
    
    checkCommutative(a, b, +)
  }
  
}
