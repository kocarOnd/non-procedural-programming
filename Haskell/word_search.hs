{- Task: Write a function that searches for words in a grid of letters.

Your function should have this signature:

search :: [String] -> [String] -> [Int]

The first argument is a list of strings representing successive rows of the grid. 
All strings in the list will have the same length. The second argument is a list 
of words to search for.

Each word might appear in the grid one time, multiple times, or not at all. Words 
may appear either horizontally or vertically. A horizontal word may go from left 
to right, or right to left. Similarly, a vertical word may go upwards or downwards.

Your search should be case-insensitive: the word 'potato' may match the grid letters 
'PoTaTO'.

Your function should return a list of integers representing the number of times that 
each word appears in the grid.-}

import Data.List
import Data.Char (toLower)

wordLineCount :: String -> String -> Int
wordLineCount word line = length (filter (isPrefixOf word) (tails line))

wordGridCount :: String -> [String] -> Int
wordGridCount word grid = n
    where
        horizontalCount = sum (map (wordLineCount word) grid)
        reversedHorizontalCount = sum (map (wordLineCount (reverse word)) grid)
        n = horizontalCount + reversedHorizontalCount


search :: [String] -> [String] -> [Int]
search grid strings = counts
    where
        normalisedGrid = map (map toLower) grid
        normalisedStrings = map (map toLower) strings
        horizontalCounts = map (`wordGridCount` normalisedGrid) normalisedStrings
        transposedGrid = transpose normalisedGrid
        verticalCounts = map (`wordGridCount` transposedGrid) normalisedStrings
        counts = zipWith (+) horizontalCounts verticalCounts