module Out.Roman
( romanizeWord
, romanizeSyllables
, romanizePhoneme
) where

import ClassyPrelude hiding (Word)

import Data.Text (toTitle)

import HelperFunctions

import Data.Language
import Data.Phoneme
import Data.Word
import Data.Inflection

import Out.IPA
import Out.Syllable

romanizeWord :: Language -> Word -> Text
romanizeWord lang (MorphemeS _ _ syllables) = toTitle $ romanizeSyllables lang syllables []
romanizeWord lang (MorphemeP _ _ phonemes)  = toTitle $ romanizePhonemes phonemes
romanizeWord lang (MorphemeC _ _ phonemess) = toTitle $ intercalate "–" (map romanizePhonemes phonemess)
romanizeWord lang (MorphemeV _ _ patts)     = toTitle $ intercalate "–" (map (romanizeSyllable lang) patts)
romanizeWord lang word = fromMaybe "!!ERROR!!" (toTitle <$> (romanizeSyllables lang <$> syllabifyWord lang word <*> return []))

romanizeSyllables :: Language -> [Syllable] -> [Phoneme] -> Text
romanizeSyllables lang [] [] = ""
romanizeSyllables lang [] [Vowel{}] = ""
romanizeSyllables lang [] [Diphthong{}] = ""
romanizeSyllables lang [] ps = romanizePhonemes ps
romanizeSyllables lang (s@(Syllable onset nucleus coda tone stress):ss) ps = f ++ n ++ l where
  f | (\case [Vowel{}] -> True; [Diphthong{}] -> True; _ -> False) ps && null onset = "\'"
    | (\case [Vowel{}] -> True; [Diphthong{}] -> True; _ -> False) ps = romanizePhonemes onset
    | otherwise = romanizePhonemes (ps ++ onset)

  n_ | length (getTones    lang) > 1 = romanizePhoneme nucleus ++ writeToneDiacritic tone
     | length (getStresses lang) > 1 = romanizePhoneme nucleus ++ writeStressDiacritic stress
     | otherwise = romanizePhoneme nucleus

  n | (\case Just 'e' -> True; _ -> False) (lastMay n_) = n_ ++ "\776"
    | otherwise = n_

  l | null coda = romanizeSyllables lang ss [nucleus]
    | otherwise = romanizeSyllables lang ss coda

romanizeSyllable :: Language -> Syllable -> Text
romanizeSyllable lang (Syllable onset nucleus coda tone stress) = out where
  out
    | length (getTones    lang) > 1 = romanizePhonemes onset ++ romanizePhoneme nucleus ++ writeToneDiacritic tone ++ romanizePhonemes coda
    | length (getStresses lang) > 1 = romanizePhonemes onset ++ romanizePhoneme nucleus ++ writeStressDiacritic stress ++ romanizePhonemes coda
    | otherwise = romanizePhonemes onset ++ romanizePhoneme nucleus ++ romanizePhonemes coda

romanizePhonemes :: [Phoneme] -> Text
romanizePhonemes ps = intercalate "\'" $ map (concatMap romanizePhoneme) $ groupBy (\x y -> not (isVowel x && isVowel y)) ps

-- these rules suck, need diacritics and a pool to pull from as needed
romanizePhoneme :: Phoneme -> Text
romanizePhoneme cns@(Consonant p m h a)
  -- Coarticulated
  | p == COARTICULATED BILABIAL VELAR && m == APPROXIMANT = "w"
  | (\case COARTICULATED{} -> True; _ -> False) p = romanizePhoneme (Consonant (getPlaceA p) m h a) ++ romanizePhoneme (Consonant (getPlaceB p) m h a)
  -- Airstream
  | m == CLICK && a == LINGUAL = writePhonemeIPA cns
  | a == EJECTIVE = romanizePhoneme (Consonant p m h PULMONIC) ++ "'"
  | a == IMPLOSIVE = romanizePhoneme (Consonant p m h PULMONIC)
  -- Phonation
  | h == ASPIRATED = romanizePhoneme (Consonant p m MODAL a) ++ "h"
  | h == BREATHY = romanizePhoneme (Consonant p m VOICELESS a)
  | h == SLACK = romanizePhoneme (Consonant p m VOICELESS a)
  | h == STIFF = romanizePhoneme (Consonant p m MODAL a)
  | h == CREAKY = romanizePhoneme (Consonant p m MODAL a)
  -- Places
  | p == INTERDENTAL = romanizePhoneme (Consonant DENTAL m h a)
  | p `elem` [LAMINALALVEOLAR, APICOALVEOLAR] = romanizePhoneme (Consonant ALVEOLAR m h a)
  | p == PALATOALVEOLAR = romanizePhoneme (Consonant POSTALVEOLAR m h a)
  | p == APICALRETROFLEX = romanizePhoneme (Consonant RETROFLEX m h a)
  | p == ALVEOLOPALATAL = romanizePhoneme (Consonant PALATAL m h a)
  -- Specific stuff
  | p == BILABIAL && m == NASAL && h == MODAL = "m"
  | p `elem` [DENTIALVEOLAR, ALVEOLAR] && m == NASAL && h == MODAL = "n"
  | p == VELAR && m == NASAL && h == MODAL = "ng"
  | p `elem` [BILABIAL, LABIODENTAL] && m == STOP && h == VOICELESS = "p"
  | p `elem` [BILABIAL, LABIODENTAL] && m == STOP && h == MODAL = "b"
  | p `elem` [DENTIALVEOLAR, ALVEOLAR] && m == STOP && h == VOICELESS = "t"
  | p `elem` [DENTIALVEOLAR, ALVEOLAR] && m == STOP && h == MODAL = "d"
  | p == VELAR && m == STOP && h == VOICELESS = "k"
  | p == VELAR && m == STOP && h == MODAL = "g"
  | p == LABIODENTAL && m `elem`  [FRICATIVE, SILIBANT] && h == VOICELESS = "f"
  | p == LABIODENTAL && m `elem`  [FRICATIVE, SILIBANT] && h == MODAL = "v"
  | p == DENTAL && m `elem`  [FRICATIVE, SILIBANT] && h `elem` [MODAL, VOICELESS] = "th"
  | p `elem`[DENTIALVEOLAR, ALVEOLAR] && m `elem` [FRICATIVE, SILIBANT] && h == VOICELESS = "s"
  | p `elem`[DENTIALVEOLAR, ALVEOLAR] && m `elem` [FRICATIVE, SILIBANT] && h == MODAL = "z"
  | p == POSTALVEOLAR && m `elem` [FRICATIVE, SILIBANT] && h == VOICELESS = "sh"
  | p == POSTALVEOLAR && m `elem` [FRICATIVE, SILIBANT] && h == MODAL = "zh"
  | p == GLOTTAL && m == FRICATIVE && h == VOICELESS = "h"
  | p `elem`[DENTIALVEOLAR, ALVEOLAR] && m `elem` [SAFFRICATE, AFFRICATE] && h == VOICELESS = "ts"
  | p == POSTALVEOLAR && m `elem` [SAFFRICATE, AFFRICATE] && h == VOICELESS = "ch"
  | p == POSTALVEOLAR && m `elem` [SAFFRICATE, AFFRICATE] && h == MODAL = "j"
  | p `elem`[DENTIALVEOLAR, ALVEOLAR] && m `elem` [APPROXIMANT, TRILL] && h == MODAL = "r"
  | p `elem`[DENTIALVEOLAR, ALVEOLAR] && m == LAPPROXIMANT && h == MODAL = "l"
  | p `elem` [ALVEOLOPALATAL, PALATAL] && m == APPROXIMANT = "y"
  | p == VELAR && m == APPROXIMANT = "w"
  | ((p <= PALATAL || p == UVULAR) && m == APPROXIMANT) || ((p <= PALATAL || p == UVULAR) && m `elem` [APPROXIMANT, TRILL, FLAP] ) = "r"
  | m `elem` [LAPPROXIMANT, LFRICATIVE, LAFFRICATE, LFLAP] = "l"
  | p `elem` [UVULAR, PHARYNGEAL, EPIPHARYNGEAL, EPIGLOTTAL] && m == STOP = "g"
  | p `elem` [PHARYNGEAL, EPIPHARYNGEAL, EPIGLOTTAL, GLOTTAL] = "h"
  -- Last resort
  | m == NASAL = "n"
  | p == VELAR && m == STOP = "k"
  | m == AFFRICATE = romanizePhoneme (Consonant p STOP h a) ++ romanizePhoneme (Consonant p FRICATIVE h a)
  | m == SAFFRICATE = romanizePhoneme (Consonant p STOP h a) ++ romanizePhoneme (Consonant p SILIBANT h a)
  | p == PALATAL = romanizePhoneme (Consonant VELAR m h a)
  | p == VELAR = romanizePhoneme (Consonant UVULAR m h a)
  | p == RETROFLEX = romanizePhoneme (Consonant ALVEOLAR m h a)
  | p == DENTAL = romanizePhoneme (Consonant ALVEOLAR m h a)
  -- Otherwise "h"
  | otherwise = "h"

romanizePhoneme (Vowel h b r l)
  -- Specific stuff
  | h == NEAROPEN && b == FRONT && r == UNROUNDED = "a"
  | h == CLOSEMID && b == FRONT && r == UNROUNDED = "e"
  | h == CLOSE && b == FRONT && r == UNROUNDED = "e"
  | h == NEARCLOSE && b == NEARFRONT && r == UNROUNDED = "i"
  | h == OPEN && b == BACK && r == ROUNDED = "o"
  | h == CLOSE && b == BACK && r == ROUNDED && l == LONG = "o"
  | h == OPENMID && b == BACK && r == ROUNDED = "u"
  -- Length
  | l == LONG = romanizePhoneme (Vowel h b r NORMAL) ++ romanizePhoneme (Vowel h b r NORMAL)
  | l == SHORT = romanizePhoneme (Vowel h b r NORMAL)
  -- Last resort
  | h `elem` [NEARCLOSE, CLOSEMID, MID, OPENMID] && b == BACK = "o"
  | h `elem` [CLOSEMID, MID, OPENMID] && b == FRONT = "e"
  | h `elem` [OPENMID, NEAROPEN, OPEN] = "a"
  | h `elem` [CLOSE, NEARCLOSE] && b `elem` [FRONT, NEARFRONT] = "i"
  | h `elem` [CLOSE, NEARCLOSE] && b `elem` [BACK, NEARBACK, CENTRAL] = "o"
  | h `elem` [CLOSEMID, MID, OPENMID] && b `elem` [CENTRAL, NEARFRONT, NEARBACK] = "u"
  -- Otherwise "u"
  | otherwise = "u"

romanizePhoneme (Diphthong h b r h2 b2 r2 l) = romanizePhoneme (Vowel h b r l) ++ romanizePhoneme (Vowel h2 b2 r2 l)
romanizePhoneme Blank = ""

-- Tone diacritics
writeToneDiacritic :: Tone -> Text
writeToneDiacritic t
  | t == NONET = ""
  | t == TOPT = "\779"
  | t == HIGHT = "\769"
  | t == MIDT = "\772"
  | t == LOWT = "\768"
  | t == BOTTOMT = "\783"
  | t == FALLT = "\770"
  | t == HFALLT = "\7623"
  | t == LFALLT = "\7622"
  | t == RISET = "\780"
  | t == HRISET = "\7620"
  | t == LRISET = "\7621"
  | t == DIPT = "\7625"
  | t == PEAKT = "\7624"

-- Stress diacritics
writeStressDiacritic :: Stress -> Text
writeStressDiacritic s
  | s == NONES = ""
  | s == PRIMARYS = "\769"
  | s == SECONDARYS = "\779"
