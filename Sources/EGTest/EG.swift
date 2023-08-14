import XCTest

public struct EG<Input, Output> {
  public var input: Input
  public var expect : Output
  public var message: String
  public var file: StaticString
  public var line: UInt
  
  public init(
    _ input: Input, 
    expect: Output, 
    _ message: String = "", 
    _ file: StaticString = #file, 
    _ line: UInt = #line) 
  {
    self.input = input
    self.expect = expect
    self.message = message
    self.file = file
    self.line = line
  }
  
  public func msg() -> String {
    return "Line \(line): \(message)"
  }
}

public func EGAssertEqual<T: Equatable, Input>(_ actual: T, _ expected: EG<Input, T>) {
  XCTAssertEqual(
    actual, expected.expect, expected.message, file: expected.file, line: expected.line
  )
}
