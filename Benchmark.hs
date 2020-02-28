module Benchmark where

import Criterion.Main
import Data.List
fact :: Integer -> Integer
fact n | n == 0 = 1 | n /= 0 = n * fact(n -1)

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)

sumDigits :: Int -> Int
sumDigits n | n <= 0 = 0 | n > 0 = n `mod` 10 + sumDigits (n `div` 10)

tri :: Int -> Int
tri n | n < 1 = 0 | n > 0 = tri(n - 1) + n

fibonacci :: Integer -> Integer
fibonacci n | n < 2 = n | n > 1 = fibonacci (n - 1) + fibonacci (n - 2)

replace :: String -> Char -> String -> String
replace xs c s = foldr go [] xs
  where go x acc = if x == c then acc ++ s else acc ++ [x]


contains :: String -> String -> Bool
contains key str  | null str = False | length str < length key = False | length str >= length key && take 2 str == key = True | length str >= length key && take 2 str /= key = contains key (drop 1 str)

lucky :: (Integral a) => a -> String
lucky 7 = "Lucky number seven!"
lucky x = "Sorry, you're out of luck, pal!"

sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe _ = "Not between 1 and 5"
removeNonUppercase :: String -> String
removeNonUppercase str = [c | c <- str, c `elem` ['A'..'Z']]



mergeSort :: (Ord a) => [a] -> [a]
mergeSort [] = []
mergeSort [a] = [a]
mergeSort a =
  merge (mergeSort left) (mergeSort right)
    where left = take (length a `div` 2) a
          right = drop (length a `div` 2) a
-- Expects a and b to already be sorted
merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] b = b
merge (a:as) (b:bs)
  | a < b     = a:merge as (b:bs)
  | otherwise = b:merge (a:as) bs





-- medianOfThree :: (Ord a) => [a] -> a
-- medianOfThree xs | (first' xs) > (last' xs) = first' xs | first' xs <= last' xs = last' xs



first' :: (Ord a, Num a, Eq a) => [a] -> a
first' [] = error "array is empty"
first' [a] = a
first'  (a:xs)= a

last' :: (Ord a, Num a, Eq a) => [a] -> a
last' [] = error "array is empty"
last' [a] = a
last' (a:xs) = a


patternMatchingTuple :: (a, b , c) -> a
patternMatchingTuple (x, _, _) = x

patternMatchingArray :: [a] -> a
patternMatchingArray (_:_:x:_) = x

length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs


sum' :: (Num a) => [a] -> a  
sum' [] = 0  
sum' (x:xs) = x + sum' xs  

initials :: String -> String -> String
initials "" "" = "cannot be empty of course"
initials "" _  = "firstname cannot be empty"
initials _  "" = "lastname cannot be empty"
initials firstname lastname = [f,i] ++ ". " ++ [l] ++ "."
          where (f:_:i:_) = firstname
                (l:a:_) = lastname




strangeThings :: (Ord a) => [a] -> [a]
strangeThings [] = []
strangeThings xs = xs


-- Tail [2,3,4]
-- Init [1,2,3]
-- remove all once
-- 2 and 3 occur 2 times so they stay
centerOfArray :: [a] -> [a]
centerOfArray l@(_:_:_:_) = centerOfArray $ tail $ init l
centerOfArray l           = l

middleNumber :: (Ord n) => n -> n -> n -> n 
middleNumber x y z
    | x > y = middleNumber y x z
    | y > z = middleNumber x z y
    | otherwise = y

medianOfThree :: (Ord a) => [a] -> a
medianOfThree [] = error "Need atleast one item"
medianOfThree [a] = a
medianOfThree [a,b] = a
medianOfThree array =  middleNumber start center end
                        where start = head array
                              center = head $ centerOfArray array
                              end = last array

quickSort3 :: (Ord a) => [a] -> [a]
quickSort3 [] = []
quickSort3 xs = quickSort3 lesser ++ sortedArray ++ quickSort3 greater 
      where
            pivot = medianOfThree xs
            sortedArray = [x | x <- xs, x == pivot]
            unsortedArray = [x | x <- xs, x /= pivot]
            lesser = filter (< pivot) unsortedArray
            greater = filter (>= pivot) unsortedArray


quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (p:xs) = quickSort lesser ++ [p] ++ quickSort greater
    where
        lesser = filter (< p) xs
        greater = filter (>= p) xs



-- -- Our benchmark harness.
main = do 
  let nArray = [1..999]
  let aArray =  "the quick brown fox jumps over the lazy dog"  
  defaultMain [
        bgroup "quickSort" [
          bench "Quicksort3 list of alpha enums " $ whnf quickSort3 aArray, 
          bench "Quicksort list of alpha enums " $ whnf quickSort aArray, 
          bench "Quicksort3 list of integer numbers " $ whnf quickSort3 nArray,
          bench "Quicksort list of integer numbers " $ whnf quickSort nArray,
          bench "Mergesort list of alpha enums" $whnf mergeSort aArray,
          bench "Mergesort list of integer numbers" $whnf mergeSort nArray
          ]]