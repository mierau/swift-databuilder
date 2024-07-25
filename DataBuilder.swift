import Foundation

enum DataEndianness {
  case big
  case little
}

@resultBuilder
struct DataBuilder {
  static var defaultEndian: DataEndianness = .little
  
  static func buildBlock(_ components: Data...) -> Data {
    components.reduce(Data(), +)
  }
  
  // Support for adding Data objects.
  static func buildExpression(_ expression: Data) -> Data {
    expression
  }
  
  // Support for adding UTF-8 encoded strings.
  static func buildExpression(_ expression: String) -> Data {
    Data(expression.utf8)
  }
  
  // Support for adding strings with a specified encoding. 
  static func buildExpression(_ expression: (String, String.Encoding)) -> Data {
    expression.0.data(using: expression.1) ?? Data()
  }
  
  // Support for adding arrays of byte values.
  static func buildExpression(_ expression: [UInt8]) -> Data {
    Data(expression)
  }
    
  // Support for various fixed width integers.
  static func buildExpression<T: FixedWidthInteger>(_ expression: (T, DataEndianness)) -> Data {
    let value = expression.1 == .little ? expression.0.littleEndian : expression.0.bigEndian
    return withUnsafeBytes(of: value) { Data($0) }
  }
  
  // Support for integers using default endianness.
  static func buildExpression<T: FixedWidthInteger>(_ expression: T) -> Data {
    buildExpression((expression, DataBuilder.defaultEndian))
  }
  
  // Support for if statements.
  static func buildEither(first component: Data) -> Data {
    component
  }
  
  static func buildEither(second component: Data) -> Data {
    component
  }
  
  // Support for optionals.
  static func buildOptional(_ component: Data?) -> Data {
    component ?? Data()
  }
}

extension Data {
  init(endian: DataEndianness = .little, @DataBuilder _ content: () -> Data) {
    DataBuilder.defaultEndian = endian
    self = content()
  }
}
