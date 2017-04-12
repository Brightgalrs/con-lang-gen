{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
module Out.Other
( parseSonHier
, parseCCs
, parseLanguageTreeN
) where

import ClassyPrelude

import Data.Other
import Data.Phoneme

import Out.Lexicon

-- Parse the sonority hierarchy
parseSonHier :: [Phoneme] -> [[Phoneme]] -> Text
parseSonHier vows cons = "\n\nSonority hierarchy: " ++ "\n/" ++ cListv ++ "/\n/" ++ intercalate "/\n/" cListc ++ "/\n" where
  fListv = map parsePhonemeIPA vows
  cListv = intercalate "/, /" fListv
  fListc = map (map parsePhonemeIPA) cons
  cListc = map (intercalate "/, /") fListc

parseCCs :: [[Phoneme]] -> [[Phoneme]] -> Text
parseCCs onsets codas = "\n\nValid onsets: " ++ "\n/" ++ intercalate "/\n/" oList ++ "/" ++ "\n\nValid codas: " ++ "\n/" ++ intercalate "/\n/" cList ++ "/\n" where
  oList = map (concatMap parsePhonemeIPA) onsets
  cList = map (concatMap parsePhonemeIPA) codas


-- Parse language branches into Newick format
parseLanguageTreeN :: LanguageBranch -> Text
parseLanguageTreeN tree = parseLanguageBranchN tree ++ ";"

parseLanguageBranchN :: LanguageBranch -> Text
parseLanguageBranchN (LanguageBranch lang [] n) = getName lang -- ++ ":" ++ show (fromIntegral n / 10)
parseLanguageBranchN (LanguageBranch lang branches n) = branchStuff ++ getName lang where -- ++ ":" ++ show (fromIntegral n / 10) where
  branchStuff = "(" ++ intercalate "," (map parseLanguageBranchN branches) ++ ")"
