module Main where

import Data.List

main :: IO ()
main = do
  let unusedVar = 42
  putStrLn "Hello"

addNumbers x = x + 10 -- Missing type signature

someFunction = do
  -- Will trigger formatting issues
  let y = 10 -- Bad spacing
  print y0 -- Bad spacing
  print y
data Person = Person String Int -- No record syntax, HLint might suggest using it
data Person = Person String Int -- No record syntax, HLint might suggest using it
