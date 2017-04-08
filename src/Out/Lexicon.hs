module Out.Lexicon
( parseDictionary
, parseWordIPA
, parseMorphemeIPA
, parsePhonemeIPA
, parseRootDictionary
, parseSyllableIPA
, parseLC
) where

import Prelude hiding (Word)
import Data.List
import Control.Arrow
import GHC.Exts hiding (Word)

import Data.Phoneme
import Data.Inflection
import Data.Other

import Out.Roman
import Out.Syllable
import Out.IPA

-- Parse list of roots to string
parseRootDictionary :: [[Phoneme]] -> [((String, LexCat), Morpheme)] -> String
parseRootDictionary sonHier pairs = "\n" ++ intercalate "\n" (map (parseRootDictionaryEntry sonHier) (reduceHomophones2 pairs))

reduceHomophones2 :: [((String, LexCat), Morpheme)] -> [([(String, LexCat)], Morpheme)]
reduceHomophones2 pairs = map (second head . unzip) (groupWith snd (sortWith snd pairs))

parseRootDictionaryEntry :: [[Phoneme]] -> ([(String, LexCat)], Morpheme) -> String
parseRootDictionaryEntry sonHier (means, morph) = romanizeMorpheme morph ++ " (" ++ parseMorphemeIPA sonHier morph ++ ")" ++ concatMap (\(str, lc) -> "\n\t" ++ parseLC lc ++ " " ++ str) means

-- Parse list of words to string
parseDictionary :: [[Phoneme]] -> [((String, LexCat), Word)] -> String
parseDictionary sonHier pairs = "\n" ++ intercalate "\n" (map (parseDictionaryEntry sonHier) (reduceHomophones pairs))

reduceHomophones :: [((String, LexCat), Word)] -> [([(String, LexCat)], Word)]
reduceHomophones pairs = map (second head . unzip) (groupWith snd (sortWith snd pairs))

parseDictionaryEntry :: [[Phoneme]] -> ([(String, LexCat)], Word) -> String
parseDictionaryEntry sonHier (means, wrd) = romanizeWord wrd ++ " (" ++ parseWordIPA sonHier wrd ++ ")" ++ concatMap (\(str, lc) -> "\n\t" ++ parseLC lc ++ " " ++ str) means

parseLC :: LexCat -> String
parseLC lc
  | lc == Verb = "v."
  | lc == Noun = "n."
  | lc == Adj  = "adj."
  | lc == Adv  = "adv."
  | lc == Adpo = "p."

-- Parse Word to string
parseWordIPA :: [[Phoneme]] -> Word -> String
parseWordIPA sonHier word = "/" ++ intercalate "." (map parseSyllableIPA sylls) ++ "/" where
  (SyllWord sylls) = syllabifyWord sonHier word

-- Parse Morpheme to string (used in exponent table too)
parseMorphemeIPA :: [[Phoneme]] -> Morpheme -> String
parseMorphemeIPA sonHier morph = "/" ++ intercalate "." (map parseSyllableIPA sylls) ++ "/" where
  (SyllWord sylls) = syllabifyMorpheme sonHier morph

-- Parse Syllable to string
parseSyllableIPA :: Syllable -> String
parseSyllableIPA (Syllable onset (Consonant a b c) coda) = concatMap parsePhonemeIPA onset ++ parsePhonemeIPA (Consonant a b c) ++ "\809" ++ concatMap parsePhonemeIPA coda
parseSyllableIPA (Syllable onset nucleus coda) = concatMap parsePhonemeIPA onset ++ parsePhonemeIPA nucleus ++ concatMap parsePhonemeIPA coda
