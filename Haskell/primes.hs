{- Task: a)

Write a function

factors :: Int -> [Int]

that computes a list of prime factors of an integer N ≥ 2, in ascending order:

> factors 180
[2,2,3,3,5]

Your function must run in O(sqrt(N)) in the worst case.

b)

Write a function

gap :: Int -> (Int, Int)

that takes an integer N ≥ 3 and computes the largest prime gap in the range 2 .. N. 
Specifically, the function should return a pair of consecutive primes (p, q) such 
that 2 ≤ p < q ≤ N and (q - p) is as large as possible. Because p and q are consecutive 
primes, all integers k in the range p < k < q must not be prime. If there are multiple 
prime gaps (p, q) of maximal size, return the one with the smallest value of p.

For example:

> gap 1000
(887,907)
-}

factors :: Int -> [Int]
factors n = factorize n 2

factorize :: Int -> Int -> [Int]
factorize n d
  | d * d > n = [n]
  | mod n d == 0 = d : factorize (div n d) d
  | otherwise = factorize n (d+1) 

isPrime :: Int -> Bool
isPrime x = factors x == [x]

gap :: Int -> (Int, Int)
gap n = findMaxGap primePairs (0, 0)
  where
    primes = filter isPrime [2..n]
    primePairs = zip primes (tail primes)

findMaxGap :: [(Int, Int)] -> (Int, Int) -> (Int, Int)
findMaxGap [] largestGap = largestGap
findMaxGap ((p, q) : restListe) (pMax, qMax)
    | (q-p) > (qMax-pMax) = findMaxGap restListe (p, q)
    | otherwise = findMaxGap restListe (pMax, qMax)

