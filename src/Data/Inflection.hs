module Data.Inflection
( Manifest(..)
, ManifestPlace(..)
, Express(..)
, MorphType(..)
, LexCat(..)
, InflectionMap(..)
, GramCatExpress(..)
, GramCatExpresses(..)
, gramCatExpressNull
, Gender(..)
, Animacy(..)
, Case(..)
, Number(..)
, Definiteness(..)
, Specificity(..)
, Topic(..)
, Person(..)
, Honorific(..)
, Polarity(..)
, Tense(..)
, Aspect(..)
, Mood(..)
, Voice(..)
, Evidentiality(..)
, Transitivity(..)
, Volition(..)
, GramCat(..)
) where

import ClassyPrelude

import Data.Phoneme
import Data.Other

-- Manifest (list of places) (list of stuff that manifests there)
data Manifest a = NoManifest | Manifest { getManPlaces :: [ManifestPlace], getManStuff :: [a] } deriving (Eq)

instance GramCat a => Show (Manifest a) where
  show NoManifest = ""
  show (Manifest _ []) = ""
  show (Manifest _ [x]) = unpack (name x)
  show (Manifest _ [x,y]) = unpack (name x ++ " and " ++ name y)
  show (Manifest _ (x:xs)) = unpack (intercalate ", " (map name xs) ++ ", and " ++ name x)

data ManifestPlace = ManifestPlace { getMPLC :: LexCat, getMTI :: [(MorphType, Int)], getAgr :: Maybe LexCat } deriving (Eq, Show)

data Express a  = NoExpress
                | Agree LexCat
                | Express { getExp :: a } deriving (Eq, Ord, Read)

instance GramCat a => Show (Express a) where
  show NoExpress = ""
  show (Agree lc) = "agree/w " ++ show lc
  show (Express x) = unpack $ name x

-- How the inflection manifests
data MorphType = Root | Particle | Prefix | Suffix | Transfix | CTransfix deriving (Eq, Enum, Ord, Read)

instance Show MorphType where
  show inflType = case inflType of Root     -> "root"
                                   Particle -> "particle"
                                   Prefix   -> "prefix"
                                   Suffix   -> "suffix"
                                   Transfix -> "vowel transfix"
                                   CTransfix-> "consonant transfix"

-- Lexical categories
data LexCat = Comp | Infl | Verb | Det | Noun | Adpo | Adj | Adv | Pron
            | Obj | Subj -- arguments for verbs
              deriving (Eq, Enum, Ord, Read)
instance Show LexCat where
  show lc = case lc of Comp -> "complementizer"
                       Infl -> "inflection"
                       Verb -> "verb"
                       Det  -> "determiner"
                       Noun -> "noun"
                       Adpo -> "adposition"
                       Adj  -> "adjective"
                       Adv  -> "adverb"
                       Pron -> "pronoun"
                       Obj  -> "object"
                       Subj -> "subject"

-- Inflection system map
-- This a map of how inflection works for the language
-- It records:
-- * which grammatical categories are expressed
-- * how they are expressed (particle/affix)
-- * how they are combined (like in fusional languages)
-- * on which parts of speech they show up (agreement possible)
data InflectionMap = InflectionMap
                      { getGenSys :: Manifest Gender
                      , getAniSys :: Manifest Animacy
                      , getCasSys :: Manifest Case
                      , getNumSys :: Manifest Number
                      , getDefSys :: Manifest Definiteness
                      , getSpeSys :: Manifest Specificity
                      , getTopSys :: Manifest Topic
                      , getPerSys :: Manifest Person
                      , getHonSys :: Manifest Honorific
                      , getPolSys :: Manifest Polarity
                      , getTenSys :: Manifest Tense
                      , getAspSys :: Manifest Aspect
                      , getMooSys :: Manifest Mood
                      , getVoiSys :: Manifest Voice
                      , getEviSys :: Manifest Evidentiality
                      , getTraSys :: Manifest Transitivity
                      , getVolSys :: Manifest Volition
                      }  deriving (Eq, Show)

data GramCatExpress = GramCatExpress
                      { getGen :: Express Gender
                      , getAni :: Express Animacy
                      , getCas :: Express Case
                      , getNum :: Express Number
                      , getDef :: Express Definiteness
                      , getSpe :: Express Specificity
                      , getTop :: Express Topic
                      , getPer :: Express Person
                      , getHon :: Express Honorific
                      , getPol :: Express Polarity
                      , getTen :: Express Tense
                      , getAsp :: Express Aspect
                      , getMoo :: Express Mood
                      , getVoi :: Express Voice
                      , getEvi :: Express Evidentiality
                      , getTra :: Express Transitivity
                      , getVol :: Express Volition
                      } deriving (Eq, Read)

instance Show GramCatExpress where
  show (GramCatExpress gen ani cas num def spe top per hon pol ten asp moo voi evi tra vol) = "[" ++ intercalate ", " out ++ "]" where
    out = filter (not.null) [show gen, show ani, show cas, show num, show def, show spe, show top, show per, show hon, show pol, show ten, show asp, show moo, show voi, show evi, show tra, show vol]


gramCatExpressNull = GramCatExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress NoExpress
data GramCatExpresses = GramCatExpresses
                      { getGens :: [Express Gender]
                      , getAnis :: [Express Animacy]
                      , getCass :: [Express Case]
                      , getNums :: [Express Number]
                      , getDefs :: [Express Definiteness]
                      , getSpes :: [Express Specificity]
                      , getTops :: [Express Topic]
                      , getPers :: [Express Person]
                      , getHons :: [Express Honorific]
                      , getPols :: [Express Polarity]
                      , getTens :: [Express Tense]
                      , getAsps :: [Express Aspect]
                      , getMoos :: [Express Mood]
                      , getVois :: [Express Voice]
                      , getEvis :: [Express Evidentiality]
                      , getTras :: [Express Transitivity]
                      , getVols :: [Express Volition]
                      }  deriving (Eq, Show)



-- Grammatical categories
-- For nouns
data Gender        = UGEN | M | F | COM | N  deriving (Ord, Eq, Bounded, Read, Show)
data Animacy       = UANI | AN | HUM | NHUM | ZO | INAN deriving (Ord, Eq, Bounded, Read, Show)
data Case          = UCAS
                   | DIR | DIR2
                   | INTR | MTR | DTR | TR
                   | NOM | NOM2
                   | ACC | ACC2 | ACC3
                   | OBJ | OBJ2
                   | ERG | ERG2
                   | ABS | ABS2 | ABS3 | ABS4
                   | PEG | SEC | DAT

                   | PREP
                   | LAT | ELA | DEL | ABL | EXESS
                   | LOC
                   | SEP

                   | COMP | EQU | IDEN | ABE
                   | INS | COMIT | INSCOMIT | ORN | BEN
                   | CAUS | DISTR
                   | GEN | POSS | PART
                   | VOC deriving (Ord, Eq, Bounded, Read, Show)

-- "Case" signals what the attached word's function is in the phrase
-- The morpho-syntactic cases signal which verb argument they are
-- Genitive cases signal that a noun is modifying another noun
--   * Inalienable Possessive, Alienable Possessive, Possesed, Partitive
-- Prepositional case signals a relationship between a adposition and noun
--   * English's Oblique case is a merger Accusative and Prepositional, I think
--   * I suppose you would have either Prepostional case + actual prepositions OR a bunch of Location/Motion-related cases
--   * Although maybe both could work, and you would know which prepositions go with which NPs
-- Locative (at), Seperative (away), and Lative (to) cases
--   * These type of cases are really granular
--   * Do these represent VP-NP or VP-NP-NP relations?
--   * I suppose you'd have pairs of these working (Like Seperative and Lative) to show motion away from something to something else

-- General cases:
-- Morphosyntactic cases (NP-VP) showing theta roles
-- Genitive (NP-NP cases) showing relations
-- Seperative, Locative, Lative (VP-NP cases) showing a motion relative to a thing
-- Prepositional (PP-NP cases) showing that the noun is what the preposition is talking about
-- Partitive? (DP-NP case?)
{-
data Case = CaseGroup Text [Case]
          | Case Text

cases = [ Case "ELA"
        , Case "DEL"
        , Case "ABL"
        , Case "EXESS"
        , CaseGroup "LAT" [Case "ELA", Case "DEL", Case "ABL", Case "EXESS"]
        ]


-- Returns the arguments that each Morphosyntactic Case applies to
getCases c = case c of INTR  -> [Subj]
                       ERG2  -> [Agen]
                       ACC2  -> [Obj]
                       PEG   -> [Don]
                       SEC   -> [Them]
                       DAT   -> [Rec]

                       NOM2  -> [Subj, Agen]
                       ABS2  -> [Subj, Obj]
                       ERG   -> [Agen, Don]
                       ACC3  -> [Obj, Rec]
                       ACC   -> [Obj, Them]

                       MTR   -> [Agen, Obj]
                       OBJ2  -> [Them, Rec]

                       NOM   -> [Subj, Agen, Don]
                       ABS3  -> [Subj, Obj, Rec]

                       ABS4  -> [Subj, Obj, Them]

                       DTR   -> [Don, Them, Rec]

                       DIR2  -> [Subj, Agen, Obj]
                       OBJ   -> [Obj, Them, Rec]

                       ABS   -> [Subj, Obj, Them, Rec]

                       TR    -> [Agen, Obj, Don, Them, Rec]

                       DIR   -> [Subj, Agen, Obj, Don, Them, Rec]


                       --          Subj
                       --     Agent   Object
                       -- Donor   Theme   Recipient

-- Just a bunch of likely alignments
data Alignment = Alignment Text [Case]
alignment = [ Alignment "Nominative-objective" [NOM, OBJ]
            , Alignment "Nominative-accusative (Secundative)" [NOM, SEC, ACC3]
            , Alignment "Nominative-accusative (Indirective)" [NOM, ACC, DAT]
            , Alignment "Ergative-absolutive" [ERG, ABS]
            , Alignment "Ergative-absolutive (Secundative)" [ERG, SEC, ABS3]
            , Alignment "Ergative-absolutive (Indirective)" [ERG, SEC, ABS4, DAT]
            , Alignment "Transitive" [INTR, TR]
            , Alignment "Mono-Ditransitive" [INTR, MTR, DTR]
            , Alignment "Tripartite" [INTR, ERG, OBJ]
            , Alignment "Quadpartite (Secundative)" [INTR, ERG, SEC, ACC3]
            , Alignment "Quadpartite (Indirective)" [INTR, ERG, ACC, DAT]
            , Alignment "Hexpartite" [INTR, ERG2, OBJ, PEG, SEC, DAT]
            , Alignment "Direct" [DIR]
            , Alignment "Ditransitive" [DIR2, DTR]
            ]
-}

data Number        = UNUM | SG | DU | TRI | PA | PL deriving (Ord, Eq, Bounded, Read, Show)
data Definiteness  = UDEF | DEF | INDF deriving (Ord, Eq, Bounded, Read, Show)
data Specificity   = USPE | SPEC | NSPEC deriving (Ord, Eq, Bounded, Read, Show)
data Topic         = UTOP | TOP | NTOP deriving (Ord, Eq, Bounded, Read, Show)
data Person        = UPER | FIRST | FSTINCL | FSTEXCL | SECOND | THIRD | THRDPROX | THRDOBV deriving (Ord, Eq, Bounded, Read, Show)
-- For nouns and verbs
data Honorific     = UHON | FAM | NEU | FORM deriving (Ord, Eq, Bounded, Read, Show)
data Polarity      = UPOL | AFF | NEG deriving (Ord, Eq, Bounded, Read, Show)
-- For verbs
data Tense         = UTEN | PST | PRS | FUT
                   | APRS | APST
                   | AFUT | AFUT1 | AFUT2 | AFUT3
                   | PPRS | PFUT
                   | PPST | PPST1 | PPST2 | PPST3
                   | PSTPER | PRSPER | FUTPER deriving (Ord, Eq, Bounded, Read, Show)
data Aspect        = UASP | NNPROG | PFV | IPFV | HAB | CONT | NPROG | PROG deriving (Ord, Eq, Bounded, Read, Show)
data Mood          = UMOO | IND | IRR | DEO | IMP | JUS | OPT | EPIS | SBJV | POT | COND deriving (Ord, Eq, Bounded, Read, Show)
data Voice         = UVOI | ACTIVE | MIDDLE | PASSIVE deriving (Ord, Eq, Bounded, Read, Show)
data Evidentiality = UEVI | EXP | VIS | NVIS | AUD | INFER | REP | HSY | QUO | ASS deriving (Ord, Eq, Bounded, Read, Show)
data Transitivity  = UTRA | NTRANS | TRANS | MTRANS | DITRANS deriving (Ord, Eq, Bounded, Read, Show)
data Volition      = UVOL | VOL | NVOL deriving (Ord, Eq, Bounded, Read, Show)


-- GramCat
class (Show a) => GramCat a where
  gloss, name :: a -> Text
  gloss = tshow

instance GramCat Gender where
  name gen = case gen of UGEN -> "unknown gender"
                         M    -> "masculine"
                         F    -> "feminine"
                         COM  -> "common"
                         N    -> "neuter"

instance GramCat Animacy where
  name ani = case ani of UANI -> "unknown animacy"
                         AN   -> "animate"
                         HUM  -> "human"
                         NHUM -> "non-human"
                         ZO   -> "animal"
                         INAN -> "inanimate"

instance GramCat Case where
  name cas = case cas of UCAS -> "unknown case"
                         ACC  -> "accusative"
                         ACC2 -> "accusative"
                         ACC3 -> "accusative"
                         ERG  -> "ergative"
                         ERG2 -> "ergative"
                         PEG  -> "pegative"
                         DAT  -> "dative"
                         SEC  -> "secundative"
                         NOM  -> "nominative"
                         NOM2 -> "nominative"
                         ABS  -> "absolutive"
                         ABS2 -> "absolutive"
                         ABS3 -> "absolutive"
                         ABS4 -> "absolutive"
                         INTR -> "intransitive"
                         MTR  -> "monotransitive"
                         DTR  -> "ditransitive"
                         TR   -> "transitive"
                         DIR  -> "directive"
                         DIR2 -> "directive"
                         OBJ  -> "objective"
                         PREP -> "prepositional"

instance GramCat Number where
  name num = case num of UNUM -> "unknown number"
                         SG   -> "singular"
                         DU   -> "dual"
                         TRI  -> "trial"
                         PA   -> "paucal"
                         PL   -> "plural"

instance GramCat Definiteness where
  name def = case def of UDEF -> "unknown definiteness"
                         DEF  -> "definite"
                         INDF -> "indefinite"

instance GramCat Specificity where
  name spe = case spe of USPE  -> "unknown specificity"
                         SPEC  -> "specific"
                         NSPEC -> "nonspecific"

instance GramCat Topic where
  name top = case top of UTOP -> "unknown topic"
                         TOP  -> "topic"
                         NTOP -> "not topic"

instance GramCat Person where
  name per = case per of UPER     -> "unknown person"
                         FIRST    -> "first"
                         FSTINCL  -> "first inclusive"
                         FSTEXCL  -> "first exclusive"
                         SECOND   -> "second"
                         THIRD    -> "third"
                         THRDPROX -> "proximate"
                         THRDOBV  -> "obviative"

instance GramCat Honorific where
  name hon = case hon of UHON  -> "unknown honorific"
                         FAM   -> "informal"
                         NEU   -> "neutral"
                         FORM  -> "formal"

instance GramCat Polarity where
  name pol = case pol of UPOL -> "unknown polarity"
                         AFF  -> "affirmative"
                         NEG  -> "negative"

instance GramCat Tense where
  name ten = case ten of UTEN   -> "unknown tense"
                         PST    -> "simple past"
                         PRS    -> "simple present"
                         FUT    -> "simple future"
                         APRS   -> "anterior present"
                         APST   -> "anterior past"
                         AFUT   -> "anterior future"
                         AFUT1  -> "anterior future"
                         AFUT2  -> "anterior future"
                         AFUT3  -> "anterior future"
                         PPRS   -> "posterior present"
                         PFUT   -> "posterior future"
                         PPST   -> "posterior past"
                         PPST1  -> "posterior past"
                         PPST2  -> "posterior past"
                         PPST3  -> "posterior past"
                         PSTPER -> "past perfect"
                         PRSPER -> "present perfect"
                         FUTPER -> "future perfect"

instance GramCat Aspect where
  name asp = case asp of UASP   -> "unknown aspect"
                         NNPROG -> "not progressive"
                         PFV    -> "perfective"
                         IPFV   -> "imperfective"
                         HAB    -> "habitual"
                         CONT   -> "continuous"
                         NPROG  -> "non-progressive"
                         PROG   -> "progressive"


instance GramCat Mood where
  name moo = case moo of UMOO -> "unknown mood"
                         IND  -> "indicative"
                         IRR  -> "irrealis"
                         DEO  -> "deontic"
                         IMP  -> "imperative"
                         JUS  -> "jussive"
                         OPT  -> "optative"
                         EPIS -> "epistemic"
                         SBJV -> "subjunctive"
                         POT  -> "potential"
                         COND -> "conditional"

instance GramCat Voice where
  name voi = case voi of UVOI    -> "unknown voice"
                         ACTIVE  -> "active"
                         MIDDLE  -> "middle"
                         PASSIVE -> "passive"

instance GramCat Evidentiality where
  name evi = case evi of UEVI  -> "unknown evidentiality"
                         EXP   -> "witness"
                         VIS   -> "visual"
                         NVIS  -> "non-visual"
                         AUD   -> "auditory"
                         INFER -> "inferential"
                         REP   -> "reportative"
                         HSY   -> "hearsay"
                         QUO   -> "quotative"
                         ASS   -> "assumed"

instance GramCat Transitivity where
  name tra = case tra of UTRA    -> "unknown transitivity"
                         NTRANS  -> "intransitive"
                         TRANS   -> "transitive"
                         MTRANS  -> "monotransitive"
                         DITRANS -> "ditransitive"

instance GramCat Volition where
  name vol = case vol of UVOL -> "unknown volition"
                         VOL  -> "intended"
                         NVOL -> "unintended"
