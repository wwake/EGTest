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
      EG(input: (-1, 1), output: "0", "zero"),
      EG(input: (3, 0), output: "3", "one-digit"),
      EG(input: (-2, 1), output: "-1", "negative")
    ]) { p in
      let my = Demo()
      let actual = my.stringOfSum(p.input.0, p.input.1)
      XCTAssertEqual(p.output, actual, p.msg())
    }
  }
}