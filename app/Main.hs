module Main where

import Data.Random.Extras
import Data.Random hiding (sample)
import Data.RVar

import PhonemeGen
import PhonotacticsGen
import WordGen
import Parse
import InflectionGen
import MorphologyGen
import GrammarGen
import Translate

main :: IO ()
main = do

  -- consonants
  places <- sampleRVar makePlaces
  manners <- sampleRVar makeManners
  phonations <- sampleRVar makePhonations
  inventoryC <- sampleRVar (makeConsonants places manners phonations)

  -- vowels
  heights <- sampleRVar makeHeights
  backs <- sampleRVar makeBacknesses
  rounds <- sampleRVar makeRoundedneses
  lengths <- sampleRVar makeLengths
  inventoryV <- sampleRVar (makeVowels heights backs rounds lengths)

  -- diphthongs
  inventoryD <- sampleRVar (makeDiphInventory 4 inventoryV)

  -- phonotactics
  sonHier <- sampleRVar (makeSonHier inventoryC)

  -- grammar
  grammar <- sampleRVar makeGrammar

  -- inflection / grammatical categories
  idata <- loadInputData
  (inflSys, numPerLexCat) <- sampleRVar (makeInflectionSystem idata)
  systems <- sampleRVar (mapM (makeLexicalInflection inventoryV sonHier inflSys) numPerLexCat)

  -- root morphemes
  mData <- loadMeaningData
  roots <- sampleRVar (makeDictionary mData (inventoryV ++ inventoryD) sonHier ((1, 4), (0, 2), (1, 3), (0, 2)))

  -- outputs
  writeFile "out/phonology.txt" $ "Phonology"
                               ++ parseConPhonemeInventory places manners phonations inventoryC
                               ++ parseVowPhonemeInventory heights backs rounds lengths inventoryV
                               ++ parseDiphPhonemeInventory inventoryD

  writeFile "out/phonotactics.txt" $ "Phonotactics"
                                  ++ parseSonHier (inventoryV ++ inventoryD) sonHier

  writeFile "out/inflection.txt" $ "Inflection"
                                ++ parseLCInflection inflSys
                                ++ concatMap (parseLexicalSystems inflSys) systems

  writeFile "out/grammar.txt" $ "Grammar\n"
                             ++ show grammar ++ "\n"
                             ++ parseParseTree sonHier roots grammar treeExample

  writeFile "out/lexicon.txt" $ "Lexicon"
                             ++ parseDictionary sonHier roots
