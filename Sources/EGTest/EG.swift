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

public func EGAssertThrowsError<Ignored, Input, Expected: Equatable>(
  _ expression: @escaping @autoclosure () throws -> Ignored,
  _ example: EG<Input, Expected>
) {
  XCTAssertThrowsError(try expression(), example.message, file: example.file, line: example.line)
}

public func EGAssertThrowsError<Ignored, Input, Expected: Equatable>(
  _ expression: @escaping @autoclosure () throws -> Ignored,
  _ example: EG<Input, Expected>,
  _ errorHandler: (EG<Input, Expected>, Error) -> Void
) {
  XCTAssertThrowsError(
    try expression(),
    example.message,
    file: example.file,
    line: example.line,
    { err in errorHandler(example, err) }
  )
}
