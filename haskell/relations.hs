{- HLINT ignore "Use camelCase" -}

{-Task: a) Write a function

is_equiv :: (a -> a -> Bool) -> [a] -> Bool

that determines whether a function is an equivalence relation on a given set of values:

> is_equiv (\x y -> x `mod` 5 == y `mod` 5) [1..30]
True
> is_equiv (<=) [1..30]
False
> is_equiv (\x y -> False) [1..3]
False
> is_equiv (\i j -> abs(i - j) <= 2) [1..20]
False

b) Write a function

classes :: (a -> a -> Bool) -> [a] -> [[a]]

that takes an equivalence relation R plus a set S of values, and returns a set of equivalence 
classes of S with respect to R:

> classes (\x y -> x `mod` 5 == y `mod` 5) [2, 7, 6, 100, 3, 4, 5, 8, 1]
[[6,1],[3,8],[100,5],[4],[2,7]]

You may return the equivalence classes in any order. The elements within each class may appear 
in any order as well.

c) The reflexive closure of a relation R is the smallest relation that contains R and is also 
reflexive. For example, the reflexive closure of the relation (<) is the relation (<=). 
The reflexive closure of (<=) is itself.

Write a function

reflexive_closure :: Eq a => (a -> a -> Bool) -> (a -> a -> Bool)

that takes a relation R and returns its reflexive closure:

> f = reflexive_closure (<)
> f 3 4
True
> f 4 4
True
-}
import Data.List

isReflex :: (a -> a -> Bool) -> [a] -> Bool
isReflex funct = all (\a -> funct a a)

isSymetric :: (a -> a -> Bool) -> [a] -> Bool
isSymetric funct xs = all (\x -> all (\y -> funct x y == funct y x) xs) xs

isTransitive :: (a -> a -> Bool) -> [a] -> Bool
isTransitive funct xs = all (\x -> all (\y -> all (\z -> not (funct x y && funct y z) || funct x z) xs) xs) xs

is_equiv :: (a -> a -> Bool) -> [a] -> Bool
is_equiv funct xs = isReflex funct xs && isSymetric funct xs && isTransitive funct xs

classes :: (a -> a -> Bool) -> [a] -> [[a]]
classes funct xs = map (\x -> filter (funct x) xs) (nubBy funct xs)

reflexive_closure :: Eq a => (a -> a -> Bool) -> (a -> a -> Bool)
reflexive_closure funct x y = funct x y || x == y 