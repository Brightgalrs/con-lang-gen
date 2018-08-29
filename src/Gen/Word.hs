{-# OPTIONS_GHC -Wall #-}
module Gen.Word
( makeDictionary
, someFunction
) where

import PClassyPrelude hiding (Word)

import Data.Phoneme
import Data.Inflection


-- Generates the full lexicon from the root dictionary and inflections
makeDictionary :: [(LexCat, [ManifestSystem], [ManifestSystem], [ManifestSystem])] -> [((String, LexCat), Morpheme)] -> [((String, LexCat), Word)]
makeDictionary mans rootDict = concatMap (makeRootWord mans) rootDict
  -- words from root dictionary x exponents
  -- words from particles
  -- words from multiple roots?
  -- we'll get there

-- take inflection morphemes from ManifestSystem's
makeRootWord :: [(LexCat, [ManifestSystem], [ManifestSystem], [ManifestSystem])] -> ((String, LexCat), Morpheme) -> [((String, LexCat), Word)]
makeRootWord mans ((str, lc), morph)
  | null foo  = [((str,lc),Word [morph])]
  | otherwise = (,) <$> [(str,lc)] <*> map Word wrds where
  foo = filter (\(x,_,_,_) -> x == lc) mans
  (_,_,pref,suff) = head foo
  wrds = (\x y z -> x ++ y ++ z) <$> prefCombos <*> [[morph]] <*> suffCombos
  prefCombos = someFunction $ map (map fst . manSysCombos) pref
  suffCombos = someFunction $ map (map fst . manSysCombos) suff

someFunction :: [[Morpheme]] -> [[Morpheme]]
someFunction input
  | null input = [[]]
  | otherwise  = (:) <$> head input <*> someFunction (tail input)
