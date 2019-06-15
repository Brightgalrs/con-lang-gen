module Gen.WritingSystem
( generateWritingSystem
, generateAlphabet
, generateSyllabary
, makeAllSyllables
, generateLogography
) where

import ClassyPrelude
import Data.RVar
import Data.Random.Extras

import Data.Phoneme
import Data.Word
import Data.Other
import Data.Inflection

--pick writing systems
generateWritingSystem :: [Phoneme] -> [Syllable] -> [Morpheme] -> RVar ([(Phoneme, Int)], [(Syllable, Int)], [(Morpheme, Int)])
generateWritingSystem phonemes [] morphs = choice [ (generateAlphabet phonemes, [], [])
                                                  --, ([], [], generateLogography morphs 983040)
                                                  ]
generateWritingSystem phonemes sylls morphs = choice [ (generateAlphabet phonemes, [], [])
                                                     --, ([], generateSyllabary sylls 983040, [])
                                                     --, ([], [], generateLogography morphs 983040)
                                                     ]

-- generate an alphabet based on phonemes
-- monographs/digraphs allowed (not yet)
-- includes abjads and abugidas (not yet)
generateAlphabet :: [Phoneme] -> [(Phoneme, Int)]
generateAlphabet phonemes = zip phonemes [983040..]


-- generates a "true" syllabary
-- need "false" syllabary later
generateSyllabary :: [Syllable] -> Int -> [(Syllable, Int)]
generateSyllabary sylls n = zip sylls [n..]


-- make all syllables
makeAllSyllables :: [[Phoneme]] -> [Phoneme] -> [[Phoneme]] -> [Tone] -> [Stress] -> [Syllable]
makeAllSyllables onsets nucleuss codas tones stresses = Syllable <$> onsets <*> nucleuss <*> codas <*> tones <*> stresses


-- generate logographs, one for each lexicon entry, inflection entry
-- maybe two/three/four for each lexicon entry? related too much to morphology and therefore semantics
generateLogography :: [Morpheme] -> Int -> [(Morpheme, Int)]
generateLogography morphs n = zip morphs [n..]
