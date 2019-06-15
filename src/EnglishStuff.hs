module EnglishStuff
( englishLanguage
, englishGrammar
, englishInflection
, englishManifest
) where

import ClassyPrelude

import Data.Phoneme
import Data.Word
import Data.Grammar
import Data.Inflection
import Data.Language

-- this needs a rework to work with the new word/morpheme system

englishLanguage = Language { getName = "English"
                           , getNameMod = ("","")
                           , getCInv = mempty
                           , getVInv = mempty
                           , getDInv = mempty
                           , getCMap = ([], [], [], [])
                           , getVMap = ([], [], [], [])
                           , getTones = []
                           , getStresses = []
                           , getSonHier = 0
                           , getOnsetCCs = mempty
                           , getNuclei = mempty
                           , getCodaCCs = mempty
                           , getInflMap = englishInflection
                           , getInflMorphemes = [] -- shouldn't be empty
                           , getLemmaMorphemes = [] -- shouldn't be empty
                           , getDerivMorphemes = [] -- shouldn't be empty
                           , getCompoundMorphemes = [] -- shouldn't be empty
                           , getPronouns = []
                           , getRootMorphemes = []
                           , getGrammar = englishGrammar
                           , getWriting = ([], [], [])
                           , getRules = []
                           }

englishGrammar :: Grammar
englishGrammar = Grammar SubInitial ObjFinal CompFinal NoVtoIMove OblAffixHop NoNullSub OptTopic NoNullTop NoTopMark OblItoCMove OblWHMove PiedPipe OblQuesInv

englishInflection :: InflectionMap
englishInflection = InflectionMap
                      { getGenSys = Manifest [ManifestPlace Pron [(Suffix, 1)] Nothing] [M, F, N]
                      , getAniSys = Manifest [ManifestPlace Pron [(Suffix, 1)] Nothing] [AN, INAN]
                      , getCasSys = Manifest [ManifestPlace Pron [(Suffix, 1)] Nothing, ManifestPlace Noun [(Suffix, 1)] Nothing] [NOM, ACC, GEN]
                      , getNumSys = Manifest [ManifestPlace Verb [(Suffix, 1)] Nothing, ManifestPlace Noun [(Suffix, 1), (Particle, 1)] Nothing] [SG, PL]
                      , getDefSys = Manifest [ManifestPlace Noun [(Particle, 1)] Nothing] [DEF, INDF]
                      , getSpeSys = Manifest [ManifestPlace Noun [(Particle, 2)] Nothing] [SPEC, NSPEC] -- "fake"
                      , getTopSys = Manifest [ManifestPlace Noun [(Suffix, 2)] Nothing] [TOP, NTOP] --"fake"
                      , getPerSys = Manifest [ManifestPlace Pron [(Suffix, 1)] Nothing, ManifestPlace Noun [(Suffix, 1)] Nothing] [FIRST, SECOND, THIRD]
                      , getHonSys = NoManifest
                      , getPolSys = Manifest [ManifestPlace Verb [(Particle, 1)] Nothing] [AFF, NEG]
                      , getTenSys = Manifest [ManifestPlace Verb [(Suffix, 1)] Nothing] [PST, PRS, FUT, PSTPER, PRSPER, FUTPER]
                      , getAspSys = Manifest [ManifestPlace Verb [(Particle, 2), (Suffix, 1)] Nothing] [NNPROG, PROG]
                      , getMooSys = Manifest [ManifestPlace Verb [(Particle, 2), (Suffix, 1)] Nothing] [IND, SBJV, COND, IMP]
                      , getVoiSys = Manifest [ManifestPlace Verb [(Particle, 1), (Suffix, 1)] Nothing] [ACTIVE, PASSIVE]
                      , getEviSys = NoManifest
                      , getTraSys = NoManifest
                      , getVolSys = Manifest [ManifestPlace Verb [(Particle, 3)] Nothing] [VOL, NVOL] --"fake"
                      }

englishManifest :: [(LexCat, [(LexCat, MorphType, [(Text, GramCatExpress)])], [(LexCat, MorphType, [(Text, GramCatExpress)])], [(LexCat, MorphType, [(Text, GramCatExpress)])])]
englishManifest = [eVerbInfl, eNounInfl, ePronInfl]

eVerbInfl :: (LexCat, [(LexCat, MorphType, [(Text, GramCatExpress)])], [(LexCat, MorphType, [(Text, GramCatExpress)])], [(LexCat, MorphType, [(Text, GramCatExpress)])])
eVerbInfl = (Verb, [eVerbParticle1, eVerbParticle2],[],[eVerbSuffix1])

eNounInfl = (Noun, [eNounParticle1],[],[eNounSuffix1])
ePronInfl = (Pron, [ePronParticle1],[],[])

ePronParticle1 :: (LexCat, MorphType, [(Text, GramCatExpress)])
ePronParticle1 = (Pron, Particle, [ ( "he", GramCatExpress (Express M) (Express AN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "him", GramCatExpress (Express M) (Express AN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "his", GramCatExpress (Express M) (Express AN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "she", GramCatExpress (Express F) (Express AN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "her", GramCatExpress (Express F) (Express AN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "her", GramCatExpress (Express F) (Express AN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "they", GramCatExpress (Express N) (Express AN) (Express NOM) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "them", GramCatExpress (Express N) (Express AN) (Express ACC) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "their", GramCatExpress (Express N) (Express AN) (Express GEN) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "they", GramCatExpress (Express N) (Express AN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "them", GramCatExpress (Express N) (Express AN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "their", GramCatExpress (Express N) (Express AN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "it", GramCatExpress (Express N) (Express INAN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "it", GramCatExpress (Express N) (Express INAN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "its", GramCatExpress (Express N) (Express INAN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "they", GramCatExpress (Express N) (Express INAN) (Express NOM) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "them", GramCatExpress (Express N) (Express INAN) (Express ACC) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "their", GramCatExpress (Express N) (Express INAN) (Express GEN) (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "you", GramCatExpress (Express N) (Express AN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "you", GramCatExpress (Express N) (Express AN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "your", GramCatExpress (Express N) (Express AN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "you", GramCatExpress (Express N) (Express AN) (Express NOM) (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "you", GramCatExpress (Express N) (Express AN) (Express ACC) (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "your", GramCatExpress (Express N) (Express AN) (Express GEN) (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "I", GramCatExpress (Express N) (Express AN) (Express NOM) (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "me", GramCatExpress (Express N) (Express AN) (Express ACC) (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "my", GramCatExpress (Express N) (Express AN) (Express GEN) (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "we", GramCatExpress (Express N) (Express AN) (Express NOM) (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "us", GramCatExpress (Express N) (Express AN) (Express ACC) (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               , ( "our", GramCatExpress (Express N) (Express AN) (Express GEN) (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                               ])

eVerbParticle2 = (Verb, Particle, [ ( "not", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express NEG) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                , ( "", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express AFF) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                ])

eVerbParticle3 = (Verb, Particle, [ ( "(on purpose)", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express VOL) )
                                , ( "(accidentally)", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express NVOL) )
                                ])

eNounParticle1 = (Noun, Particle, [ ( "the", GramCatExpress NoExpress NoExpress NoExpress (Express SG) (Express DEF) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                , ( "the", GramCatExpress NoExpress NoExpress NoExpress (Express PL) (Express DEF) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                , ( "a", GramCatExpress NoExpress NoExpress NoExpress (Express SG) (Express INDF) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) (Express INDF) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                ])

eNounParticle2 = (Noun, Particle, [ ( "(specific)", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express SPEC) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                , ( "(nonspecific)", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express NSPEC) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                                ])

eNounSuffix1 = (Noun, Suffix, [ ( "s", GramCatExpress NoExpress NoExpress (Express NOM) (Express PL) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "", GramCatExpress NoExpress NoExpress (Express NOM) (Express SG) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "s", GramCatExpress NoExpress NoExpress (Express ACC) (Express PL) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "", GramCatExpress NoExpress NoExpress (Express ACC) (Express SG) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "s\'", GramCatExpress NoExpress NoExpress (Express GEN) (Express PL) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "\'s", GramCatExpress NoExpress NoExpress (Express GEN) (Express SG) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            ])

eNounSuffix2 = (Noun, Suffix, [ ( "", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express TOP) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            , ( "", GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress (Express NTOP) NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress )
                            ])

eVerbParticle1 = (Verb, Particle, [ ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "has", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "will have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "have", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               , ( "had", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                               ])

eVerbSuffix1 =(Verb, Suffix, [ ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "s", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express IND) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PST) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRS) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUT) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express SG) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express THIRD) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express SECOND) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PSTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express PRSPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           , ( "ed", GramCatExpress NoExpress NoExpress NoExpress (Express PL) NoExpress NoExpress NoExpress (Express FIRST) NoExpress NoExpress (Express FUTPER) (Express NNPROG) (Express SBJV) (Express ACTIVE) NoExpress NoExpress NoExpress )
                           ])
