// nef:begin:hidden
import Foundation
// nef:end
/*:
 ```Haskell
 type Writer a = (a, String)
 ```
 */
typealias Writer<A> = (A, String)
 /*:
 ................
 ```Haskell
 a -> Writer b
 ```
 ```swift
 func f<A, B>(_ a: A) -> Writer<B>
 ```
 ................
 ```Haskell
 (>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
 ```
 ```swift
 func andThen<A, B, C>(_ f: @escaping (A) -> Writer<B>,
                       _ g: @escaping (B) -> Writer<C>) -> (A) -> Writer<C>
 ```
 ................
 ```Haskell
 m1 >=> m2 = \x ->
     let (y, s1) = m1 x
         (z, s2) = m2 y
     in (z, s1 ++ s2)
 ```
 */
func andThen<A, B, C>(_ m1: @escaping (A) -> Writer<B>,
                      _ m2: @escaping (B) -> Writer<C>) -> (A) -> Writer<C> {
    { x in
        let (y, s1) = m1(x)
        let (z, s2) = m2(y)
        return (z, s1 + s2)
    }
}
 /*:
 ................
 ```Haskell
 return :: a -> Writer a
 return x = (x, "")
 ```
 */
func pure<A>(_ x : A) -> Writer<A> {
    return (x, "")
}
 /*:
 ................
 ```Haskell
 upCase :: String -> Writer String
 upCase s = (map toUpper s, "upCase ")
 ```
 */
func upCase(_ s: String) -> Writer<String> {
    (s.uppercased(), "upCase ")
}
 /*:
 ................
 ```Haskell
 toWords :: String -> Writer [String]
 toWords s = (words s, "toWords ")
 ```
 */
func toWords(_ s: String) -> Writer<[String]> {
    (s.components(separatedBy: " "), "toWords ")
}
 /*:
 ................
 ```Haskell
 process :: String -> Writer [String]
 process = upCase >=> toWords
 ```
 */
 let process: (String) -> Writer<[String]> = andThen(upCase, toWords)
 /*:
 ................
 */
