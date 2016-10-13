module PhonemeInventoryGen2
( makeConInventory
, makeVowInventory
) where

-- Import
import Prelude
import Data.RVar
import Data.Random.Extras

import PhonemeType2

-- Load from files
-- Nothing

-- Phoneme data
c = [ [Consonant BILABIAL NASAL VOICELESS "m̥",Consonant BILABIAL NASAL VOICED "m",Consonant LABIODENTAL NASAL VOICELESS "ɱ̊",Consonant LABIODENTAL NASAL VOICED "ɱ",Consonant DENTAL NASAL VOICELESS "n̪̊",Consonant DENTAL NASAL VOICED "n̪",Consonant ALVEOLAR NASAL VOICELESS "n̥",Consonant ALVEOLAR NASAL VOICED "n", Consonant PALATOALVEOLAR NASAL VOICELESS "n̠̊",Consonant PALATOALVEOLAR NASAL VOICED "n̠",Consonant RETROFLEX NASAL VOICELESS "ɳ̊",Consonant RETROFLEX NASAL VOICED "ɳ",Consonant ALVEOLOPALATAL NASAL VOICELESS "ɲ̟̊",Consonant ALVEOLOPALATAL NASAL VOICED "ɲ̟",Consonant PALATAL NASAL VOICELESS "ɲ̊",Consonant PALATAL NASAL VOICED "ɲ",Consonant VELAR NASAL VOICELESS "ŋ̊",Consonant VELAR NASAL VOICED "ŋ",Consonant UVULAR NASAL VOICELESS "ɴ̥",Consonant UVULAR NASAL VOICED "ɴ",Consonant PHARYNGEAL NASAL VOICELESS [],Consonant PHARYNGEAL NASAL VOICED [],Consonant GLOTTAL NASAL VOICELESS [],Consonant GLOTTAL NASAL VOICED []]
    , [Consonant BILABIAL STOP VOICELESS "p",Consonant BILABIAL STOP VOICED "b",Consonant LABIODENTAL STOP VOICELESS "p̪",Consonant LABIODENTAL STOP VOICED "b̪",Consonant DENTAL STOP VOICELESS "t̪",Consonant DENTAL STOP VOICED "d̪",Consonant ALVEOLAR STOP VOICELESS "t",Consonant ALVEOLAR STOP VOICED "d",Consonant PALATOALVEOLAR STOP VOICELESS "t̠",Consonant PALATOALVEOLAR STOP VOICED "d̠",Consonant RETROFLEX STOP VOICELESS "ʈ",Consonant RETROFLEX STOP VOICED "ɖ",Consonant ALVEOLOPALATAL STOP VOICELESS "c̟",Consonant ALVEOLOPALATAL STOP VOICED "ɟ̟",Consonant PALATAL STOP VOICELESS "c",Consonant PALATAL STOP VOICED "ɟ",Consonant VELAR STOP VOICELESS "k",Consonant VELAR STOP VOICED "ɡ",Consonant UVULAR STOP VOICELESS "q",Consonant UVULAR STOP VOICED "ɢ",Consonant PHARYNGEAL STOP VOICELESS "ʡ̥",Consonant PHARYNGEAL STOP VOICED "ʡ",Consonant GLOTTAL STOP VOICELESS "ʔ",Consonant GLOTTAL STOP VOICED []]
    , [Consonant BILABIAL AFFRICATE VOICELESS "p͡ɸ",Consonant BILABIAL AFFRICATE VOICED "b͡β",Consonant LABIODENTAL AFFRICATE VOICELESS "p̪͡f",Consonant LABIODENTAL AFFRICATE VOICED "b̪͡v",Consonant DENTAL AFFRICATE VOICELESS "t̪͡s̪",Consonant DENTAL AFFRICATE VOICED "d̪͡z̪",Consonant ALVEOLAR AFFRICATE VOICELESS "t͡s",Consonant ALVEOLAR AFFRICATE VOICED "d͡z",Consonant PALATOALVEOLAR AFFRICATE VOICELESS "t̠͡ʃ",Consonant PALATOALVEOLAR AFFRICATE VOICED "d̠͡ʒ",Consonant RETROFLEX AFFRICATE VOICELESS "ʈ͡ʂ",Consonant RETROFLEX AFFRICATE VOICED "ɖ͡ʐ",Consonant ALVEOLOPALATAL AFFRICATE VOICELESS "c̟͡ɕ",Consonant ALVEOLOPALATAL AFFRICATE VOICED "ɟ̟͡ʑ",Consonant PALATAL AFFRICATE VOICELESS "c͡ç",Consonant PALATAL AFFRICATE VOICED "ɟ͡ʝ",Consonant VELAR AFFRICATE VOICELESS "k͡x",Consonant VELAR AFFRICATE VOICED "ɡ͡ɣ",Consonant UVULAR AFFRICATE VOICELESS "q͡χ",Consonant UVULAR AFFRICATE VOICED "ɢ͡ʁ",Consonant PHARYNGEAL AFFRICATE VOICELESS "ʡ̥͡ħ",Consonant PHARYNGEAL AFFRICATE VOICED "ʡ͡ʕ",Consonant GLOTTAL AFFRICATE VOICELESS "ʔ͡h",Consonant GLOTTAL AFFRICATE VOICED []]
    , [Consonant BILABIAL FRICATIVE VOICELESS "ɸ",Consonant BILABIAL FRICATIVE VOICED "β",Consonant LABIODENTAL FRICATIVE VOICELESS "f",Consonant LABIODENTAL FRICATIVE VOICED "v",Consonant DENTAL FRICATIVE VOICELESS "s̪",Consonant DENTAL FRICATIVE VOICED "z̪",Consonant ALVEOLAR FRICATIVE VOICELESS "s",Consonant ALVEOLAR FRICATIVE VOICED "z",Consonant PALATOALVEOLAR FRICATIVE VOICELESS "ʃ",Consonant PALATOALVEOLAR FRICATIVE VOICED "ʒ",Consonant RETROFLEX FRICATIVE VOICELESS "ʂ",Consonant RETROFLEX FRICATIVE VOICED "ʐ",Consonant ALVEOLOPALATAL FRICATIVE VOICELESS "ɕ",Consonant ALVEOLOPALATAL FRICATIVE VOICED "ʑ",Consonant PALATAL FRICATIVE VOICELESS "ç",Consonant PALATAL FRICATIVE VOICED "ʝ",Consonant VELAR FRICATIVE VOICELESS "x",Consonant VELAR FRICATIVE VOICED "ɣ",Consonant UVULAR FRICATIVE VOICELESS "χ",Consonant UVULAR FRICATIVE VOICED "ʁ",Consonant PHARYNGEAL FRICATIVE VOICELESS "ħ",Consonant PHARYNGEAL FRICATIVE VOICED "ʕ",Consonant GLOTTAL FRICATIVE VOICELESS "h",Consonant GLOTTAL FRICATIVE VOICED "ɦ"]
    , [Consonant BILABIAL APPROXIMANT VOICELESS "ɸ̝",Consonant BILABIAL APPROXIMANT VOICED "β̞",Consonant LABIODENTAL APPROXIMANT VOICELESS "ʋ̥",Consonant LABIODENTAL APPROXIMANT VOICED "ʋ",Consonant DENTAL APPROXIMANT VOICELESS "ð̞̊ ",Consonant DENTAL APPROXIMANT VOICED "ð̞",Consonant ALVEOLAR APPROXIMANT VOICELESS "ɹ̊",Consonant ALVEOLAR APPROXIMANT VOICED "ɹ",Consonant PALATOALVEOLAR APPROXIMANT VOICELESS "ɹ̠̊",Consonant PALATOALVEOLAR APPROXIMANT VOICED "ɹ̠",Consonant RETROFLEX APPROXIMANT VOICELESS "ɻ̊",Consonant RETROFLEX APPROXIMANT VOICED "ɻ",Consonant ALVEOLOPALATAL APPROXIMANT VOICELESS "ɻ̠̊",Consonant ALVEOLOPALATAL APPROXIMANT VOICED "ɻ̠",Consonant PALATAL APPROXIMANT VOICELESS "j̊",Consonant PALATAL APPROXIMANT VOICED "j",Consonant VELAR APPROXIMANT VOICELESS "ɰ̊",Consonant VELAR APPROXIMANT VOICED "ɰ",Consonant UVULAR APPROXIMANT VOICELESS "ʁ̞̊ ",Consonant UVULAR APPROXIMANT VOICED "ʁ̞",Consonant PHARYNGEAL APPROXIMANT VOICELESS "ħ̞",Consonant PHARYNGEAL APPROXIMANT VOICED "ʕ̞",Consonant GLOTTAL APPROXIMANT VOICELESS "h̞",Consonant GLOTTAL APPROXIMANT VOICED "ɦ̞"]
    , [Consonant BILABIAL FLAP VOICELESS "ⱱ̟̊",Consonant BILABIAL FLAP VOICED "ⱱ̟",Consonant LABIODENTAL FLAP VOICELESS "ⱱ̥",Consonant LABIODENTAL FLAP VOICED "ⱱ",Consonant DENTAL FLAP VOICELESS "ɾ̪̊ ",Consonant DENTAL FLAP VOICED "ɾ̪",Consonant ALVEOLAR FLAP VOICELESS "ɾ̥",Consonant ALVEOLAR FLAP VOICED "ɾ",Consonant PALATOALVEOLAR FLAP VOICELESS "ɾ̠̊ ",Consonant PALATOALVEOLAR FLAP VOICED "ɾ̠",Consonant RETROFLEX FLAP VOICELESS "ɽ̊",Consonant RETROFLEX FLAP VOICED "ɽ",Consonant ALVEOLOPALATAL FLAP VOICELESS "ɽ̠̊",Consonant ALVEOLOPALATAL FLAP VOICED "ɽ̠",Consonant PALATAL FLAP VOICELESS "c̆",Consonant PALATAL FLAP VOICED "ɟ̆",Consonant VELAR FLAP VOICELESS [],Consonant VELAR FLAP VOICED [],Consonant UVULAR FLAP VOICELESS "q̆",Consonant UVULAR FLAP VOICED "ɢ̆",Consonant PHARYNGEAL FLAP VOICELESS [],Consonant PHARYNGEAL FLAP VOICED "ʡ̮",Consonant GLOTTAL FLAP VOICELESS [],Consonant GLOTTAL FLAP VOICED []]
    , [Consonant BILABIAL TRILL VOICELESS "ʙ̥",Consonant BILABIAL TRILL VOICED "ʙ",Consonant LABIODENTAL TRILL VOICELESS "ʙ̠̊ ",Consonant LABIODENTAL TRILL VOICED "ʙ̠",Consonant DENTAL TRILL VOICELESS "r̪̊ ",Consonant DENTAL TRILL VOICED "r̪",Consonant ALVEOLAR TRILL VOICELESS "r̥",Consonant ALVEOLAR TRILL VOICED "r",Consonant PALATOALVEOLAR TRILL VOICELESS "r̠̊ ",Consonant PALATOALVEOLAR TRILL VOICED "r̠",Consonant RETROFLEX TRILL VOICELESS "ɽ͡r̥",Consonant RETROFLEX TRILL VOICED "ɽ͡r",Consonant ALVEOLOPALATAL TRILL VOICELESS "ɽ̠̊͡r",Consonant ALVEOLOPALATAL TRILL VOICED "ɽ̠͡r",Consonant PALATAL TRILL VOICELESS "ɽ̠̠̊͡r",Consonant PALATAL TRILL VOICED "ɽ̠̠͡r",Consonant VELAR TRILL VOICELESS [],Consonant VELAR TRILL VOICED [],Consonant UVULAR TRILL VOICELESS "ʀ̥",Consonant UVULAR TRILL VOICED "ʀ",Consonant PHARYNGEAL TRILL VOICELESS "ʜ",Consonant PHARYNGEAL TRILL VOICED "ʢ",Consonant GLOTTAL TRILL VOICELESS [],Consonant GLOTTAL TRILL VOICED []]
    , [Consonant BILABIAL LAFFRICATE VOICELESS [],Consonant BILABIAL LAFFRICATE VOICED [],Consonant LABIODENTAL LAFFRICATE VOICELESS [],Consonant LABIODENTAL LAFFRICATE VOICED [],Consonant DENTAL LAFFRICATE VOICELESS "t̪͡ɬ̪̊",Consonant DENTAL LAFFRICATE VOICED "d̪͡ɮ̪",Consonant ALVEOLAR LAFFRICATE VOICELESS "t͡ɬ",Consonant ALVEOLAR LAFFRICATE VOICED "d͡ɮ",Consonant PALATOALVEOLAR LAFFRICATE VOICELESS "",Consonant PALATOALVEOLAR LAFFRICATE VOICED "d̠͡ɮ̠",Consonant RETROFLEX LAFFRICATE VOICELESS "ʈ͡ɭ̥˔",Consonant RETROFLEX LAFFRICATE VOICED "ɖ͡ɭ˔",Consonant ALVEOLOPALATAL LAFFRICATE VOICELESS "c̟͡ʎ̟̝̊",Consonant ALVEOLOPALATAL LAFFRICATE VOICED "ɟ̟͡ʎ̟̝",Consonant PALATAL LAFFRICATE VOICELESS "c͡ʎ̝̊",Consonant PALATAL LAFFRICATE VOICED "ɟ͡ʎ̝̊",Consonant VELAR LAFFRICATE VOICELESS "k͡ʟ̝̊",Consonant VELAR LAFFRICATE VOICED "ɡ͡ʟ̝",Consonant UVULAR LAFFRICATE VOICELESS "q͡ʟ̝̠̊",Consonant UVULAR LAFFRICATE VOICED "ɢ͡ʟ̝̠",Consonant PHARYNGEAL LAFFRICATE VOICELESS [],Consonant PHARYNGEAL LAFFRICATE VOICED [],Consonant GLOTTAL LAFFRICATE VOICELESS [],Consonant GLOTTAL LAFFRICATE VOICED []]
    , [Consonant BILABIAL LFRICATIVE VOICELESS [],Consonant BILABIAL LFRICATIVE VOICED [],Consonant LABIODENTAL LFRICATIVE VOICELESS [],Consonant LABIODENTAL LFRICATIVE VOICED [],Consonant DENTAL LFRICATIVE VOICELESS "ɬ̪̊",Consonant DENTAL LFRICATIVE VOICED "ɮ̪",Consonant ALVEOLAR LFRICATIVE VOICELESS "ɬ",Consonant ALVEOLAR LFRICATIVE VOICED "ɮ",Consonant PALATOALVEOLAR LFRICATIVE VOICELESS "ɬ̠",Consonant PALATOALVEOLAR LFRICATIVE VOICED "ɮ̠",Consonant RETROFLEX LFRICATIVE VOICELESS "ɭ̥˔",Consonant RETROFLEX LFRICATIVE VOICED "ɭ˔",Consonant ALVEOLOPALATAL LFRICATIVE VOICELESS "ʎ̟̝̊",Consonant ALVEOLOPALATAL LFRICATIVE VOICED "ʎ̟̝",Consonant PALATAL LFRICATIVE VOICELESS "ʎ̝̊",Consonant PALATAL LFRICATIVE VOICED "ʎ̝̊",Consonant VELAR LFRICATIVE VOICELESS "ʟ̝̊",Consonant VELAR LFRICATIVE VOICED "ʟ̝",Consonant UVULAR LFRICATIVE VOICELESS "ʟ̝̠̊",Consonant UVULAR LFRICATIVE VOICED "ʟ̝̠",Consonant PHARYNGEAL LFRICATIVE VOICELESS [],Consonant PHARYNGEAL LFRICATIVE VOICED [],Consonant GLOTTAL LFRICATIVE VOICELESS [],Consonant GLOTTAL LFRICATIVE VOICED []]
    , [Consonant BILABIAL LAPPROXIMANT VOICELESS [],Consonant BILABIAL LAPPROXIMANT VOICED [],Consonant LABIODENTAL LAPPROXIMANT VOICELESS [],Consonant LABIODENTAL LAPPROXIMANT VOICED [],Consonant DENTAL LAPPROXIMANT VOICELESS "l̪̊",Consonant DENTAL LAPPROXIMANT VOICED "l̪",Consonant ALVEOLAR LAPPROXIMANT VOICELESS "l̥",Consonant ALVEOLAR LAPPROXIMANT VOICED "l",Consonant PALATOALVEOLAR LAPPROXIMANT VOICELESS "l̠̊",Consonant PALATOALVEOLAR LAPPROXIMANT VOICED "l̠",Consonant RETROFLEX LAPPROXIMANT VOICELESS "ɭ̥",Consonant RETROFLEX LAPPROXIMANT VOICED "ɭ",Consonant ALVEOLOPALATAL LAPPROXIMANT VOICELESS "ʎ̟̊ ",Consonant ALVEOLOPALATAL LAPPROXIMANT VOICED "ʎ̟",Consonant PALATAL LAPPROXIMANT VOICELESS "ʎ̥",Consonant PALATAL LAPPROXIMANT VOICED "ʎ",Consonant VELAR LAPPROXIMANT VOICELESS "ʟ̥",Consonant VELAR LAPPROXIMANT VOICED "ʟ",Consonant UVULAR LAPPROXIMANT VOICELESS "ʟ̠̊",Consonant UVULAR LAPPROXIMANT VOICED "ʟ̠",Consonant PHARYNGEAL LAPPROXIMANT VOICELESS [],Consonant PHARYNGEAL LAPPROXIMANT VOICED [],Consonant GLOTTAL LAPPROXIMANT VOICELESS [],Consonant GLOTTAL LAPPROXIMANT VOICED []]
    , [Consonant BILABIAL LFLAP VOICELESS [],Consonant BILABIAL LFLAP VOICED [],Consonant LABIODENTAL LFLAP VOICELESS [],Consonant LABIODENTAL LFLAP VOICED [],Consonant DENTAL LFLAP VOICELESS "ɺ̪̊",Consonant DENTAL LFLAP VOICED "ɺ̪",Consonant ALVEOLAR LFLAP VOICELESS "ɺ̥",Consonant ALVEOLAR LFLAP VOICED "ɺ",Consonant PALATOALVEOLAR LFLAP VOICELESS "ɺ̠̊",Consonant PALATOALVEOLAR LFLAP VOICED "ɺ̠",Consonant RETROFLEX LFLAP VOICELESS "ɺ̢̊",Consonant RETROFLEX LFLAP VOICED "ɺ̢",Consonant ALVEOLOPALATAL LFLAP VOICELESS "ʎ̯̟̊",Consonant ALVEOLOPALATAL LFLAP VOICED "ʎ̯̟",Consonant PALATAL LFLAP VOICELESS "ʎ̯̊",Consonant PALATAL LFLAP VOICED "ʎ̯",Consonant VELAR LFLAP VOICELESS "ʟ̥̆",Consonant VELAR LFLAP VOICED "ʟ̆",Consonant UVULAR LFLAP VOICELESS "ʟ̠̆̊",Consonant UVULAR LFLAP VOICED "ʟ̠̆",Consonant PHARYNGEAL LFLAP VOICELESS [],Consonant PHARYNGEAL LFLAP VOICED [],Consonant GLOTTAL LFLAP VOICELESS [],Consonant GLOTTAL LFLAP VOICED []]
    ]

v = [ [Vowel CLOSE BACK UNROUNDED "i",Vowel CLOSE BACK UNROUNDED "y",Vowel CLOSE NEARBACK UNROUNDED "ɪ̝",Vowel CLOSE NEARBACK UNROUNDED "ʏ̝",Vowel CLOSE CENTRAL UNROUNDED "ɨ",Vowel CLOSE CENTRAL UNROUNDED "ʉ",Vowel CLOSE NEARFRONT UNROUNDED "ɯ̟",Vowel CLOSE NEARFRONT UNROUNDED "ʊ̝",Vowel CLOSE FRONT UNROUNDED "ɯ",Vowel CLOSE FRONT UNROUNDED "u"]
    , [Vowel NEARCLOSE BACK UNROUNDED "ɪ̟",Vowel NEARCLOSE BACK UNROUNDED "ʏ̟",Vowel NEARCLOSE NEARBACK UNROUNDED "ɪ",Vowel NEARCLOSE NEARBACK UNROUNDED "ʏ",Vowel NEARCLOSE CENTRAL UNROUNDED "ɪ̈",Vowel NEARCLOSE CENTRAL UNROUNDED "ʊ̈",Vowel NEARCLOSE NEARFRONT UNROUNDED "ɯ̽",Vowel NEARCLOSE NEARFRONT UNROUNDED "ʊ",Vowel NEARCLOSE FRONT UNROUNDED "ɯ̞",Vowel NEARCLOSE FRONT UNROUNDED "ʊ̠"]
    , [Vowel CLOSEMID BACK UNROUNDED "e",Vowel CLOSEMID BACK UNROUNDED "ø",Vowel CLOSEMID NEARBACK UNROUNDED "ë",Vowel CLOSEMID NEARBACK UNROUNDED "ø̈",Vowel CLOSEMID CENTRAL UNROUNDED "ɘ",Vowel CLOSEMID CENTRAL UNROUNDED "ɵ",Vowel CLOSEMID NEARFRONT UNROUNDED "ɤ̈",Vowel CLOSEMID NEARFRONT UNROUNDED "ö",Vowel CLOSEMID FRONT UNROUNDED "ɤ",Vowel CLOSEMID FRONT UNROUNDED "o"]
    , [Vowel MID BACK UNROUNDED "e̞",Vowel MID BACK UNROUNDED "ø̞",Vowel MID NEARBACK UNROUNDED "ë̞",Vowel MID NEARBACK UNROUNDED "ø̞̈",Vowel MID CENTRAL UNROUNDED "ə",Vowel MID CENTRAL UNROUNDED "ɵ̞",Vowel MID NEARFRONT UNROUNDED "ɤ̞̈",Vowel MID NEARFRONT UNROUNDED "ö̞",Vowel MID FRONT UNROUNDED "ɤ̞",Vowel MID FRONT UNROUNDED "o̞"]
    , [Vowel OPENMID BACK UNROUNDED "ɛ",Vowel OPENMID BACK UNROUNDED "œ",Vowel OPENMID NEARBACK UNROUNDED "ɛ̈",Vowel OPENMID NEARBACK UNROUNDED "œ̈",Vowel OPENMID CENTRAL UNROUNDED "ɜ",Vowel OPENMID CENTRAL UNROUNDED "ɞ",Vowel OPENMID NEARFRONT UNROUNDED "ʌ̈",Vowel OPENMID NEARFRONT UNROUNDED "ɔ̈",Vowel OPENMID FRONT UNROUNDED "ʌ",Vowel OPENMID FRONT UNROUNDED "ɔ"]
    , [Vowel NEAROPEN BACK UNROUNDED "æ",Vowel NEAROPEN BACK UNROUNDED "œ̞",Vowel NEAROPEN NEARBACK UNROUNDED "a̽",Vowel NEAROPEN NEARBACK UNROUNDED "ɶ̽",Vowel NEAROPEN CENTRAL UNROUNDED "ɐ",Vowel NEAROPEN CENTRAL UNROUNDED "ɞ̞",Vowel NEAROPEN NEARFRONT UNROUNDED "ɑ̽",Vowel NEAROPEN NEARFRONT UNROUNDED "ɒ̽",Vowel NEAROPEN FRONT UNROUNDED "ʌ̞",Vowel NEAROPEN FRONT UNROUNDED "ɔ̞"]
    , [Vowel OPEN BACK UNROUNDED "a",Vowel OPEN BACK UNROUNDED "ɶ",Vowel OPEN NEARBACK UNROUNDED "a̠",Vowel OPEN NEARBACK UNROUNDED "ɶ̠",Vowel OPEN CENTRAL UNROUNDED "ä",Vowel OPEN CENTRAL UNROUNDED "ɒ̈",Vowel OPEN NEARFRONT UNROUNDED "ɑ̟",Vowel OPEN NEARFRONT UNROUNDED "ɒ̟",Vowel OPEN FRONT UNROUNDED "ɑ",Vowel OPEN FRONT UNROUNDED "ɒ"]
    ]

-- Naive: Pick random phoneme inventory
makeConInventory :: Int -> RVar [Phone]
makeConInventory n = sample n $ filter (not . null . csymbol) $ concat c

makeVowInventory :: Int -> RVar [Phone]
makeVowInventory n = sample n $ filter (not . null . vsymbol) $ concat v

-- Minimum: Picks rows and contrasts and stuff
-- Consonants:
-- * pick 2 - 3 places or manners, fill out >75% of the rows/columns
-- * remove 1 - 2 phonemes randomly
-- * voicing...
-- Vowels:
-- *Pick between several presets depending on n
-- *Diphthongs

-- Great: Realistic inventory output?