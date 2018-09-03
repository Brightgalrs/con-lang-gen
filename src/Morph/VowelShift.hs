module Morph.VowelShift
( vowelShift
) where

import ClassyPrelude

import Data.RVar
import Data.Random.Extras
--import Data.List ((\\))

import Data.Language
import Data.Phoneme
import Data.Inflection

-- Vowel shifts
-- Shifts all vowels around a "loop"
-- Doesn't take into account vowel length or tone
-- Makes a loop of either all rounded or unrounded vowels, never any "crossover"
-- Limited to manner and place
vowelShift :: Language -> RVar Language
vowelShift lang = do
  --let (heights, backs, _, _, _) = getVMap lang
  let vowels = ordNub $ map (\(Vowel h b _ _) -> (h,b)) (getVInv lang)
  startPoint <- choice vowels
  loop <- makeVowelLoop startPoint vowels []
  let langN = shiftVowels loop lang
  return $ trace (show loop) langN

shiftVowels :: [(Height, Backness)] -> Language -> Language
shiftVowels loop lang = lang{getRoots = rootsN, getManSyss = manSyssN} where
  roots = getRoots lang
  manSyss = getManSyss lang
  rootsN = map (\(x, SyllWord y) -> (,) x (SyllWord (map (shiftSyll loop) y))) roots
  manSyssN = map (\(ManifestSystem x y z) -> ManifestSystem x y (map (\(SyllWord w, v) -> (,) (SyllWord (map (shiftSyll loop) w)) v) z)) manSyss

shiftSyll :: [(Height, Backness)] -> Syllable -> Syllable
shiftSyll loop (Syllable onset nuc coda t) = Syllable onsetN nucN codaN t where
  onsetN = map (shiftVowel loop) onset
  nucN = shiftVowel loop nuc
  codaN = map (shiftVowel loop) coda

shiftVowel :: [(Height, Backness)] -> Phoneme -> Phoneme
shiftVowel _ x@Consonant{} = x
shiftVowel _ x@Diphthong{} = x
shiftVowel loop vowel = case dropWhile (/= (getHeight vowel, getBackness vowel)) loop of
  (_:next:_)  -> vowel{getHeight = fst next, getBackness = snd next}
  [_]         -> vowel{getHeight = fst (unsafeHead loop), getBackness = snd (unsafeHead loop)}
  []          -> vowel

makeVowelLoop :: (Height, Backness) -> [(Height, Backness)] -> [(Height, Backness)] -> RVar [(Height, Backness)]
makeVowelLoop start vowels [] = do
  let noStartVowels = vowels \\ [start] --saves us from having no loop
  let next = minimumByMay (comparing (vowelDistance start)) noStartVowels
  makeVowelLoop start vowels $ fromMaybe [] ((:[]) <$> next)
makeVowelLoop start vowels loop
  | start == unsafeHead loop = return loop
  | otherwise = do
  let uniqueVowels = vowels \\ loop
  let next = minimumByMay (comparing (vowelDistance (unsafeHead loop))) uniqueVowels --it's this part that prevents unround-round crossover in the loop
  makeVowelLoop start vowels $ fromMaybe [] ((:loop) <$> next)


-- manhattan distance on height and backness
vowelDistance :: (Height, Backness) -> (Height, Backness) -> Int
vowelDistance (h1,b1) (h2,b2) = abs (fromEnum h1 - fromEnum h2)
                                    + abs (fromEnum b1 - fromEnum b2)
                                  --  + 3 * abs (fromEnum r1 - fromEnum r2)

{- holding off on this, exploring sound changes...
-- merging/splitting vowel heights
morphHeight :: Language -> RVar Language
morphHeight lang = do
  let (heights,_,_,_,_) = getVMap lang
  let opts = [ (splitHeight MID [CLOSE, OPEN] lang, [MID] == heights)
             , (splitHeight MID [CLOSE, MID, OPEN] lang, [MID] == heights)
             , (splitHeight MID [CLOSEMID, OPENMID] lang, [MID] == heights)
             , (splitHeight MID [CLOSEMID, MID, OPENMID] lang, [MID] == heights)

             , (mergeHeight [NASAL] MID lang, NASAL `notElem` manners)

-- merging/splitting vowel backnesses
morphBackness :: Language -> RVar Language
morphBackness lang = do
  let (_,backs,_,_,_) = getVMap lang
  let opts = [ (insertManner NASAL lang, NASAL `notElem` manners)
             ,
             ]
-}
