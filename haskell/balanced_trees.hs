{-Task: We can represent a binary search tree in Haskell using this datatype:

data Tree = Nil | Node Tree Int Tree
  deriving (Eq, Ord, Show)

Important: In your solution you must use this definition in its exact form, 
including the deriving clause.

For the purpose of this exercise, we will say that a binary tree is balanced 
if the following property holds for every node: The number of nodes in the left 
subtree and the number of nodes in the right subtree differ by at most 1.

Write a function allBalanced :: Int -> [Tree] that takes an integer N and 
returns a list of all possible balanced binary search trees containing each 
of the integers 1, 2, ... N exactly once. The trees in your list may appear 
in any order.-}

data Tree = Nil | Node Tree Int Tree
  deriving (Eq, Ord, Show)

allBalanced :: Int -> [Tree]
allBalanced 0 = [Nil]
allBalanced n = buildTrees 1 n

buildTrees :: Int -> Int -> [Tree]
buildTrees min max
    | min > max = [Nil]
    | otherwise = [ Node l rootVal r | leftSize <- leftSizes,
                                       let rootVal = min + leftSize,
                                       l <- buildTrees min (rootVal - 1),
                                       r <- buildTrees (rootVal + 1) max ]
      where
        n = max - min + 1
        c = n - 1
        leftSizes = if even c then [c `div` 2] else [c `div` 2, (c `div` 2) + 1]