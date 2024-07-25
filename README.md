# swift-databuilder
A simple Swift library that uses Result Builders to allow you to construct Data objects from various Swift data types cleanly.

Here is an example of using DataBuilder to build Data from a 4 byte (UInt32) value defined elsewhere, a UTF-8 string, a macOS Roman encoded string, a conditional based on an outside value that inserts a single byte (UInt8), an array of bytes (UInt8), and an existing Data object (16 zero filled bytes).

```swift
let value: UInt32 = 21
let emptyData: Data = Data(repeating: 0, count: 16)
let byteArray: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]

let data = Data {
  value
  "hello world"
  ("hello", .macOSRoman)
  if value == 21 {
    UInt8(255)
  }
  byteArray
  emptyData
}
```

You can also change the endianness of the written bytes in two ways.

Set a default for all data: 

```swift
let data = Data(endian: .big) { ... }
```

Or individually for each value:

```swift
let Data = Data {
   (UInt32(100), .big)
}
```
