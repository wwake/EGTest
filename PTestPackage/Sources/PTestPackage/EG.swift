//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation
import XCTest

struct eg<Input, Output> {
  var input: Input
  var output : Output
  var message: String
  var line: Int
  
  init(input: Input, output: Output,
       _ message: String = "", _ line: Int = #line) {
    self.input = input
    self.output = output
    self.message = message
    self.line = line
  }
  
  func msg() -> String {
    return "Line \(line): \(message)"
  }
}

struct Check {
  static func examples<Input, Output>(
    _ tests: [eg<Input, Output>],
    _ parameterizedAssert: (eg<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
}

struct Test<Input, Output> {
  let assert: ((eg<Input, Output>) -> ())
  let examples: [eg<Input, Output>]
}

@resultBuilder struct ExampleBuilder<Input, Output> {
  
  static public func buildBlock( 
    _ components: eg<Input, Output>... 
  ) -> [eg<Input,Output>] {
    Array(components)
  }
  
  //  static public func buildExpression(_ expression: EG<Input, Output>) -> 
  //  EG<Input, Output> {
  //    expression
  //  }
}

@resultBuilder struct Check3<Input, Output> {
  
  static public func buildBlock( 
    _ component: @escaping AssertMethod<Input,Output>) 
  -> AssertMethod<Input,Output> {
    return component
  }
}

typealias AssertMethod<Input,Output> = (eg<Input,Output>) -> ()


public struct Examples<Input, Output> {
  let examples: [eg<Input, Output>]
  
  init(@ExampleBuilder<Input, Output> _ content: () -> [eg<Input, Output>]) {
    examples = content()
  }
  
  func check(_ assert: AssertMethod<Input,Output>) {
    Check.examples(examples, assert)
  }
}



public struct Predicate {
  let predicate: Bool
  let line: Int
  
  init(_ predicate: Bool, _ line: Int = 0) {
    self.predicate = predicate
    self.line = line
  }
}




public struct Arrange2<Subject> {
  let subject: Subject
  
  init (_ setup: () -> Subject ) {
    subject = setup()
  }
}

public func Act2<Subject, Actual> (
  _ arrange: Arrange2<Subject>, 
  _ act: @escaping (Subject) -> Actual) -> Actual {
    act(arrange.subject)
  }


public func Assert2<Actual>(
  _ actual: Actual, 
  _ assertClosure: (Actual) -> (Bool),
  _ file : StaticString = #file,
  _ line : UInt = #line) {
    XCTAssertTrue( 
      assertClosure(actual), 
      "", 
      file: file, 
      line: line
    )
  }

func eq<T: Equatable>(_ a: T, _ b: T, _ file : StaticString = #file, _ line: UInt = #line) -> Bool {
  if a == b { return true }
  XCTAssertEqual(a, b, "", file: file, line: line)
  return false
}

func Checking<Input,Output>(@Check3<Input,Output> content: @escaping AssertMethod<Input,Output>) -> (AssertMethod<Input, Output>) {
  return content
}

protocol Marker {}

public struct Arrange<Subject> : Marker {
  let subject: Subject
  
  init (_ setup: () -> Subject ) {
    subject = setup()
  }
}

public struct Act<Subject, Actual> : Marker {
  let act: (Subject) -> Actual
  
  init(
    _ act: @escaping (Subject) -> Actual) {
      self.act = act
    }
}

public struct Assert<Actual> : Marker {
  let file: StaticString
  let line: UInt
  let assert: (Actual) -> Bool
  
  init(_ file: StaticString = #file, _ line: UInt = #line, _ assert: @escaping (Actual) -> Bool) {
    self.file = file
    self.line = line
    self.assert = assert
  }
  
}

public protocol AAA {  
  func Testing<Subject, Actual>(@TestBuilder<Subject, Actual> _ content: () -> (Arrange<Subject>, Act<Subject, Actual>, Assert<Actual>)) 
}

extension XCTestCase : AAA {
  public func Testing<Subject, Actual>(_ content: () -> (Arrange<Subject>, Act<Subject, Actual>, Assert<Actual>)) {
    
  }
}

public struct Testing<Subject, Actual> {
  init(@TestBuilder<Subject, Actual> _ component: () -> () ) {
    component()
  }
}

@resultBuilder struct TestBuilder<Subject, Actual> {
  
  static public func buildBlock( 
    _ arrange: Arrange<Subject>,
    _ act: Act<Subject, Actual>,
    _ assert: Assert<Actual>
  ) -> () {
    
    let subject = arrange.subject
    let actual = act.act(subject)
    XCTAssertTrue(
      assert.assert(actual),
      "Assert failed",
      file: assert.file,
      line: assert.line
    )
  }
  
  static public func buildFinalResult(_ component: ()) -> () {
    }
}

