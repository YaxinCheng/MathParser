# MathParser
A swift library parsing string typed math expressions to its evaluated result

```swift
import MathParser

let parser = MathParser()
try! parser.parse("3 * (4 + 2) / 2") // 9
```

