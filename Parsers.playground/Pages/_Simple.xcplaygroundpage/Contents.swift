import Foundation

// Simple examples

enum Tester: String, RawRepresentableParser {
    case foo, bar, baz
}

let matcher = LinearPatternMatcher(
    input: "hello there 42 true no 1234 ian@trov.com five bar foo",
    pattern: [
        String.any.key(name: "a"),
        42.key(name: "b"),
        [true, false].any.key(name: "c"),
        Bool.any.key(name: "d"),
        Int.any.key(name: "e"),
        String.matching(regex: "((?!\\s).)+@((?!\\s).)+\\.((?!\\s).)+").key(name: "f"),
        String.any.key(name: "g"),
        Tester.bar.key(name: "h"),
        Tester.any.key(name: "i")
    ]
)

let result = matcher.parse()!
print(try! result.value(for: "a"))
print(try! result.value(for: "b"))
print(try! result.value(for: "c"))
print(try! result.value(for: "d"))
print(try! result.value(for: "e"))
print(try! result.value(for: "f"))
print(try! result.value(for: "g"))
print(try! result.value(for: "h"))
print(try! result.value(for: "i"))
