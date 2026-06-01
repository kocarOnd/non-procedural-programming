{-Task:write a Haskell function

googolMod :: Integer -> Integer -> Integer

such that (googolMod n k) returns the value of

10^(10^n) mod k

You may assume that 0 <= n < 1000 and that 0 < k < 100.

Example:

> googolMod 100 47
9
-}

expMod :: Integer -> Integer -> Integer -> Integer
expMod b e m
  | e == 0    = 1
  | even e    = expMod ((b * b) `mod` m) (e `div` 2) m -- We divide the exponent by 2
  | otherwise = (b * expMod b (e - 1) m) `mod` m -- We substract 1 from the exponent

googolMod :: Integer -> Integer -> Integer
googolMod e = expMod 10 (10 ^ e)