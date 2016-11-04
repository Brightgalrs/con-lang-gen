module InflectionGen
( makeInflectionSystem
, loadInputData
) where

import Prelude hiding (Word)
import Data.RVar
import Data.Random.Extras
import Data.Random hiding (sample)
import Control.Monad
import Data.List

import PhonemeGen
import PhonemeData
import PhonotacticsGen
import OtherData
import InflectionData
import GrammarData

-- Input data
data InputData = InputData
    {
      inputGender        :: [[Gender]]
    , inputAnimacy       :: [[Animacy]]
    , inputCase          :: [[Case]]
    , inputNumber        :: [[Number]]
    , inputDefiniteness  :: [[Definiteness]]
    , inputSpecificity   :: [[Specificity]]
    , inputTopic         :: [[Topic]]
    , inputPerson        :: [[Person]]
    , inputHonorific     :: [[Honorific]]
    , inputPolarity      :: [[Polarity]]
    , inputTense         :: [[Tense]]
    , inputAspect        :: [[Aspect]]
    , inputMood          :: [[Mood]]
    , inputVoice         :: [[Voice]]
    , inputEvidentiality :: [[Evidentiality]]
    , inputTransitivity  :: [[Transitivity]]
    , inputVolition      :: [[Volition]]
    }

loadInputData :: IO InputData
loadInputData =
    InputData
        <$> readFeature "raw/grammatical categories/gender.txt"
        <*> readFeature "raw/grammatical categories/animacy.txt"
        <*> readFeature "raw/grammatical categories/case.txt"
        <*> readFeature "raw/grammatical categories/number.txt"
        <*> readFeature "raw/grammatical categories/definiteness.txt"
        <*> readFeature "raw/grammatical categories/specificity.txt"
        <*> readFeature "raw/grammatical categories/topic.txt"
        <*> readFeature "raw/grammatical categories/person.txt"
        <*> readFeature "raw/grammatical categories/honorific.txt"
        <*> readFeature "raw/grammatical categories/polarity.txt"
        <*> readFeature "raw/grammatical categories/tense.txt"
        <*> readFeature "raw/grammatical categories/aspect.txt"
        <*> readFeature "raw/grammatical categories/mood.txt"
        <*> readFeature "raw/grammatical categories/voice.txt"
        <*> readFeature "raw/grammatical categories/evidentiality.txt"
        <*> readFeature "raw/grammatical categories/transitivity.txt"
        <*> readFeature "raw/grammatical categories/volition.txt"

readFeature :: Read a => FilePath -> IO a
readFeature = fmap read . readFile

-- Create "inflection system"

makeInflectionSystem :: InputData -> RVar (InflectionSystem, [(LexCat, Int, Int)])
makeInflectionSystem idata = do
  (genSys, genNs) <- fooGender idata
  (aniSys, aniNs) <- fooAnimacy idata genNs
  (casSys, casNs) <- fooCase idata aniNs
  (numSys, numNs) <- fooNumber idata casNs
  (defSys, defNs) <- fooDefiniteness idata numNs
  (speSys, speNs) <- fooSpecificity idata defNs
  (topSys, topNs) <- fooTopic idata speNs
  (perSys, perNs) <- fooPerson idata topNs
  (honSys, honNs) <- fooHonorific idata perNs
  (polSys, polNs) <- fooPolarity idata honNs
  (tenSys, tenNs) <- fooTense idata polNs
  (aspSys, aspNs) <- fooAspect idata tenNs
  (mooSys, mooNs) <- fooMood idata aspNs
  (voiSys, voiNs) <- fooVoice idata mooNs
  (eviSys, eviNs) <- fooEvidentiality idata voiNs
  (traSys, traNs) <- fooTransitivity idata eviNs
  (volSys, volNs) <- fooVolition idata traNs
  return (InflectionSystem genSys aniSys casSys numSys defSys speSys topSys perSys honSys polSys tenSys aspSys mooSys voiSys eviSys traSys volSys, volNs)

bar :: [(LexCat, Int, Int)] -> [(LexCat, ManifestType, Int)] -> [LexCat] -> RVar ([(LexCat, ManifestType, Int)], [(LexCat, Int, Int)])
bar ks ts [] = return (ts,ks)
bar ks ts lcs = do
  (newt, newks) <- rab ks (head lcs)
  bar newks (newt : ts) (tail lcs)

rab :: [(LexCat, Int, Int)] -> LexCat -> RVar ((LexCat, ManifestType, Int), [(LexCat, Int, Int)])
rab lcs lc2 = join out where
    (fu, ba) = partition (\(c, _, _) -> c == lc2) lcs
    shit
      | null fu = (lc2, 0, 0)
      | otherwise = head fu
    (lc, part, aff) = shit

    out = choice [ do
                   i <- uniform 1 (part+1)
                   return ((lc, Particle, i), (lc, max i part, aff) : ba)
                 , do
                   j <- uniform 1 (aff+1)
                   return ((lc, Affix, j), (lc, part, max j aff) : ba)
                 ]

fooGender :: InputData -> RVar (Manifest [Gender], [(LexCat, Int, Int)])
fooGender idata = do
  gens <- makeGenders idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ks) <- bar [] [] cats
  choice [(NoManifest, []), (Manifest ts gens, ks)]

fooAnimacy :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Animacy], [(LexCat, Int, Int)])
fooAnimacy idata genNs = do
  anis <- makeAnimacies idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar genNs [] cats
  choice [(NoManifest, genNs), (Manifest ts anis, ns)]

fooCase :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Case], [(LexCat, Int, Int)])
fooCase idata aniNs = do
  cass <- makeCases idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar aniNs [] cats
  choice [(NoManifest, aniNs), (Manifest ts cass, ns)]

fooNumber :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Number], [(LexCat, Int, Int)])
fooNumber idata casNs = do
  nums <- makeNumbers idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar casNs [] cats
  choice [(NoManifest, casNs), (Manifest ts nums, ns)]

fooDefiniteness :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Definiteness], [(LexCat, Int, Int)])
fooDefiniteness idata numNs = do
  defs <- makeDefinitenesses idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar numNs [] cats
  choice [(NoManifest, numNs), (Manifest ts defs, ns)]

fooSpecificity :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Specificity], [(LexCat, Int, Int)])
fooSpecificity idata defNs = do
  spes <- makeSpecificities idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar defNs [] cats
  choice [(NoManifest, defNs), (Manifest ts spes, ns)]

fooTopic :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Topic], [(LexCat, Int, Int)])
fooTopic idata speNs = do
  tops <- makeTopics idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar speNs [] cats
  choice [(NoManifest, speNs), (Manifest ts tops, ns)]

fooPerson :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Person], [(LexCat, Int, Int)])
fooPerson idata topNs = do
  pers <- makePersons idata
  i <- uniform 0 3
  cats <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  (ts, ns) <- bar topNs [] cats
  choice [(NoManifest, topNs), (Manifest ts pers, ns)]

fooHonorific :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Honorific], [(LexCat, Int, Int)])
fooHonorific idata perNs = do
  hons <- makeHonorifics idata
  i <- uniform 0 3
  cats1 <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  j <- uniform 0 4
  cats2 <- (:) Verb <$> sample j [Adv, Adpo, Obj, Subj]
  k <- uniform 1 2
  norv <- sample k [cats1, cats2]
  let cats = head norv `union` last norv
  (ts, ns) <- bar perNs [] cats
  choice [(NoManifest, perNs), (Manifest ts hons, ns)]

fooPolarity :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Polarity], [(LexCat, Int, Int)])
fooPolarity idata honNs = do
  pols <- makePolarities idata
  i <- uniform 0 3
  cats1 <- (++) [Obj, Subj] <$> sample i [Adj, Adpo, Verb]
  j <- uniform 0 4
  cats2 <- (:) Verb <$> sample j [Adv, Adpo, Obj, Subj]
  k <- uniform 1 2
  norv <- sample k [cats1, cats2]
  let cats = head norv `union` last norv
  (ts, ns) <- bar honNs [] cats
  choice [(NoManifest, honNs), (Manifest ts pols, ns)]

fooTense :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Tense], [(LexCat, Int, Int)])
fooTense idata polNs = do
  tens <- makeTenses idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar polNs [] cats
  choice [(NoManifest, polNs), (Manifest ts tens, ns)]

fooAspect :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Aspect], [(LexCat, Int, Int)])
fooAspect idata tenNs = do
  asps <- makeAspects idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar tenNs [] cats
  choice [(NoManifest, tenNs), (Manifest ts asps, ns)]

fooMood :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Mood], [(LexCat, Int, Int)])
fooMood idata aspNs = do
  moos <- makeMoods idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar aspNs [] cats
  choice [(NoManifest, aspNs), (Manifest ts moos, ns)]

fooVoice :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Voice], [(LexCat, Int, Int)])
fooVoice idata mooNs = do
  vois <- makeVoices idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar mooNs [] cats
  choice [(NoManifest, mooNs), (Manifest ts vois, ns)]

fooEvidentiality :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Evidentiality], [(LexCat, Int, Int)])
fooEvidentiality idata voiNs = do
  evis <- makeEvidentialities idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar voiNs [] cats
  choice [(NoManifest, voiNs), (Manifest ts evis, ns)]

fooTransitivity :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Transitivity], [(LexCat, Int, Int)])
fooTransitivity idata eviNs = do
  tras <- makeTransitivities idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar eviNs [] cats
  choice [(NoManifest, eviNs), (Manifest ts tras, ns)]

fooVolition :: InputData -> [(LexCat, Int, Int)] -> RVar (Manifest [Volition], [(LexCat, Int, Int)])
fooVolition idata traNs = do
  vols <- makeVolitions idata
  i <- uniform 0 3
  cats <- (:) Verb <$> sample i [Adv, Adpo, Obj, Subj]
  (ts, ns) <- bar traNs [] cats
  choice [(NoManifest, traNs), (Manifest ts vols, ns)]

-- Will expand these eventually
makeGenders :: InputData -> RVar [Gender]
makeGenders idata = choice $ inputGender idata

makeAnimacies :: InputData -> RVar [Animacy]
makeAnimacies idata = choice $ inputAnimacy idata

makeCases :: InputData -> RVar [Case]
makeCases idata = choice $ inputCase idata

makeNumbers :: InputData -> RVar [Number]
makeNumbers idata = choice $ inputNumber idata

makeDefinitenesses :: InputData -> RVar [Definiteness]
makeDefinitenesses idata = choice $ inputDefiniteness idata

makeSpecificities ::  InputData -> RVar [Specificity]
makeSpecificities idata = choice $ inputSpecificity idata

makeTopics :: InputData -> RVar [Topic]
makeTopics idata = choice $ inputTopic idata

makePersons :: InputData -> RVar [Person]
makePersons idata = choice $ inputPerson idata

makeHonorifics :: InputData -> RVar [Honorific]
makeHonorifics idata = choice $ inputHonorific idata

makePolarities :: InputData -> RVar [Polarity]
makePolarities idata = choice $ inputPolarity idata

makeTenses :: InputData -> RVar [Tense]
makeTenses idata = choice $ inputTense idata

makeAspects :: InputData -> RVar [Aspect]
makeAspects idata = choice $ inputAspect idata

makeMoods :: InputData -> RVar [Mood]
makeMoods idata = choice $ inputMood idata

makeVoices :: InputData -> RVar [Voice]
makeVoices idata = choice $ inputVoice idata

makeEvidentialities :: InputData -> RVar [Evidentiality]
makeEvidentialities idata = choice $ inputEvidentiality idata

makeTransitivities :: InputData -> RVar [Transitivity]
makeTransitivities idata = choice $ inputTransitivity idata

makeVolitions :: InputData -> RVar [Volition]
makeVolitions idata = choice $ inputVolition idata
