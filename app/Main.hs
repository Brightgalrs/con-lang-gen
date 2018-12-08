module Main where

import ClassyPrelude

import Data.Text.IO (getLine)
import Data.Random
import System.Random
import System.Directory

import LoadStuff

import Data.Language

import Gen.LanguageTree

import Out.Language

main :: IO ()
main = do
  -- seed
  input <- putStr "Enter seed: " *> getLine
  let seed = hashWithSalt 1 input
  setStdGen $ mkStdGen seed

  exist <- doesPathExist $ unpack $ "out/" ++ tshow seed
  if exist then putStrLn "Language family already generated" *> main else do
    idata <- loadInputData
    mData <- loadMeaningData
    tree <- newSample $ makeLanguageTree idata mData
    writeLanguageTree seed tree

-- special sampleRVar that allows seeds
newSample :: RVar a -> IO a
newSample i = do
  g1 <- getStdGen
  let out = sampleState i g1
  setStdGen $ snd out
  return $ fst out
