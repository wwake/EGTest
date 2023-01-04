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
  
  func testStringOfSum2() {
    Examples {
      eg(input: (-1, 1), output: "0", "zero")
      eg(input: (3, 0), output: "3", "one-digit")
      eg(input: (-2, 1), output: "-1", "negative")
    }.check { p in
      let my = Demo()
      let actual = my.stringOfSum(p.input.0, p.input.1)
      XCTAssertEqual(p.output, actual, p.msg())
    }
  }
  
  func testAAA_original() {
    let subject = Arrange2 {
      Demo()
    }
    
    let actual = Act2(subject) {
      $0.stringOfSum(3, 4)
    }
    
    Assert2(actual) {
      eq($0, "7") 
      && $0 > "1"
    }
  }
  
//  func testAAA() {
//    Testing {
//      Arrange { Demo() }
//      
//      Act<Demo,String>{ $0.stringOfSum(3, 4) }
//      
//      Assert { $0 == "7" }
//    }
//  }
}
