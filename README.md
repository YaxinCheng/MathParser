# MathParser
A swift library parsing string typed math expressions to its evaluated result

## Install
- Manually
    - git clone this repo, and compile. Then add the compiled `MathParser.framework` to your project
- Carthage
    - Add `github "YaxinCheng/MathParser"` to your *cartfile*
    - Run `carthage update`
    - After compiling, add the built `MathParser.framework` to your poejct

## Feature
Calculate string typed math expressions

## User Manual

```swift
import MathParser

let parser = MathParser()
try! parser.parse("3 * (4 + 2) / 2") // 9
```
