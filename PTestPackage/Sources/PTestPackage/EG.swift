//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation
import XCTest

struct EG<Input, Output> {
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
    _ tests: [EG<Input, Output>],
    _ parameterizedAssert: (EG<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
}

struct Test<Input, Output> {
  let assert: ((EG<Input, Output>) -> ())
  let examples: [EG<Input, Output>]
}

@resultBuilder struct ExampleBuilder<Input, Output> {
  
  static public func buildBlock( 
    _ components: EG<Input, Output>... 
  ) -> [EG<Input,Output>] {
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

typealias AssertMethod<Input,Output> = (EG<Input,Output>) -> ()


public struct Examples<Input, Output> {
  let examples: [EG<Input, Output>]
  
  init(@ExampleBuilder<Input, Output> _ content: () -> [EG<Input, Output>]) {
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




public struct Arrange<Subject> {
  let subject: Subject
  
  init (_ setup: () -> Subject ) {
    subject = setup()
  }
}

public func Act<Subject, Actual> (
    _ arrange: Arrange<Subject>, 
    _ act: @escaping (Subject) -> Actual) -> Actual {
  act(arrange.subject)
}


@resultBuilder struct AssertBuilder {
  
  static public func buildBlock( 
    _ components: Predicate... 
  ) -> [Predicate] {
    Array(components)
  }
  
  static public func buildExpression(_ element: Bool) -> Predicate {
    Predicate(element, #line)
  }
  
  static public func buildFinalResult(_ component: [Predicate]) -> ()  {
    XCTAssertTrue( component.allSatisfy {$0.predicate}
    )  
  }
}

public func Assert<Actual>(
  _ actual: Actual, 
  _ assertClosure: (Actual) -> (Bool)) {
  XCTAssertTrue( 
    assertClosure(actual)
  )
}


func Checking<Input,Output>(@Check3<Input,Output>  content: @escaping AssertMethod<Input,Output>) -> (AssertMethod<Input, Output>) {
  return content
}
