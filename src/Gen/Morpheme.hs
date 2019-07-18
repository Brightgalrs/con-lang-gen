module Gen.Morpheme
( makeRootMorphemes
, makeMorphemeSyllables
, makeMorphemeConsonants
, makeInflectionMorphemes
, cleanInflectionSys
, makeMorphemeVowels
, pickLemmaMorphemes
, makeDerivationMorphemes
, makeCompoundMorphemes
, makePronouns
) where

import ClassyPrelude hiding (Word, (\\))

import Data.RVar
import Data.Random.Extras
import Data.Random hiding (sample)
import Data.List ((\\))
import GHC.Exts (groupWith)

import Data.Language
import Data.Phoneme
import Data.Word
import Data.Inflection
import Data.Other

import Gen.ParseTree (generateInflection)
import Latex.Sentence (compareInfl)

import LoadStuff
import HelperFunctions

-- Generate Root Morphemes
makeRootMorphemes :: MeaningData -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float -> [(LexCat, Int, Int)] -> RVar [Morpheme]
makeRootMorphemes mData onsets nucs codas tones set zipfParameter numPerLC =
  mapM (\x -> makeRootMorphemes_ x onsets nucs codas tones set zipfParameter numPerLC) (inputRoots mData)

makeRootMorphemes_ :: Meaning -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float -> [(LexCat, Int, Int)] -> RVar Morpheme
makeRootMorphemes_ mean onsets nucs codas tones set zipfParameter numPerLC = out where
  f = fromMaybe (getLC mean, 0, 0) $ find (\(lc,_,_) -> getLC mean == lc) numPerLC
  i = (\(_,x,_) -> x) f
  j = (\(_,_,x) -> x) f
  out
    | i > 0 = MorphemeC mean Root <$> makeMorphemeConsonants onsets set zipfParameter
    | j > 0 = MorphemeV mean Root <$> makeMorphemeVowels onsets nucs codas tones set zipfParameter
    | otherwise = MorphemeS mean Root <$> makeMorphemeSyllables onsets nucs codas tones set zipfParameter

-- Generate a root morpheme given vowels, consonant clusters, and some settings
makeMorphemeSyllables :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float -> RVar [Syllable]
makeMorphemeSyllables onsets nucs codas tones (ns,xs) zipfParameter = do
  -- decide how many syllables in the morpheme
  s <- triangle ns xs
  syllables <- replicateM s (makeMorphemeSyllable onsets nucs codas tones zipfParameter)

  -- assign stress
  assignStress syllables

makeMorphemeSyllable :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> Float -> RVar Syllable
makeMorphemeSyllable onsets nucs codas tones zipfParameter = do
  onset  <- fromMaybe [] <$> zipfChoice zipfParameter onsets
  nuclei <- fromMaybe Blank <$> zipfChoice zipfParameter nucs
  coda   <- fromMaybe [] <$> zipfChoice zipfParameter codas
  tone   <- fromMaybe NONET <$> safeChoice2 tones
  return $ Syllable onset nuclei coda tone NONES

assignStress :: [Syllable] -> RVar [Syllable]
assignStress [] = return []
assignStress [syll] = return [syll] -- no stress on single syllable words
assignStress sylls@[_, _] = do
    i <- uniform 0 1
    return $ foobar i sylls (\x -> x{getStress = PRIMARYS})
assignStress sylls = do
  let inds = [0..(length sylls - 1)]
  (inds_, prim) <- fromMaybe (return ([], 0)) (choiceExtract inds)
  (_, secon) <- fromMaybe (return ([], 0)) (choiceExtract inds_)
  let sylls_ = foobar prim sylls (\x -> x{getStress = PRIMARYS})
  let syllsN = foobar secon sylls_ (\x -> x{getStress = SECONDARYS})
  return syllsN

-- Applies a function to the n-th element of a list, and then returns the list
-- It's hard to believe this doesn't exist already
foobar :: Int -> [a] -> (a -> a) -> [a]
foobar n xs f
  | n >= length xs = xs
  | otherwise =  a ++ [f b] ++ bs where
  (a,b:bs) = splitAt n xs

-- Generate Semitic Root
makeMorphemeConsonants :: [ConsCluster] -> (Int, Int) ->Float ->  RVar [[Phoneme]]
makeMorphemeConsonants conclusts (ns, xs) zipfParameter = do
  r <- triangle (max 1 (ns-1)) (xs-1)
  replicateM r (fromMaybe [] <$> zipfChoice zipfParameter conclusts) -- should be hyperparameter

-- Generate Inflectional Morphemes
makeInflectionMorphemes :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> InflectionMap -> (LexCat, Int, Int, Int, Int, Int) -> (Int, Int) -> Float -> RVar [Morpheme]
makeInflectionMorphemes onsets nucs codas tones inflMap (lc, i, j, k, l, m) set zipfParameter =
  concat <$> mapM (\(mt,x) -> makeExponentSystems lc mt x onsets nucs codas tones inflMap set zipfParameter) [(Particle,i), (Prefix,j), (Suffix,k), (Transfix,l), (CTransfix,m)]


makeExponentSystems :: LexCat -> MorphType -> Int -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> InflectionMap -> (Int, Int) -> Float -> RVar [Morpheme]
makeExponentSystems _ _ 0 _ _ _ _ _ _ _ = return []
makeExponentSystems lc morphType i onsets nucs codas tones inflMap set zipfParameter = (++) <$> makeExponentSystems lc morphType (i-1) onsets nucs codas tones inflMap set zipfParameter <*> makeExponentSystem lc morphType i onsets nucs codas tones inflMap set zipfParameter

makeExponentSystem :: LexCat -> MorphType -> Int -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> InflectionMap -> (Int, Int) -> Float -> RVar [Morpheme]
makeExponentSystem lc Transfix i onsets nucs codas tones inflMap set zipfParameter = do
  let combos = makeCombos $ cleanInflectionSys inflMap lc Transfix i
  roots <- replicateM (length combos) (makeMorphemeVowels onsets nucs codas tones set zipfParameter)
  let morphs = zipWith (\x y -> MorphemeV x Transfix y) (InflMeaning lc i <$> combos) roots
  return morphs
makeExponentSystem lc CTransfix i onsets nucs codas tones inflMap set zipfParameter = do
  let combos = makeCombos $ cleanInflectionSys inflMap lc CTransfix i
  roots <- replicateM (length combos) (makeMorphemeConsonants onsets set zipfParameter)
  let morphs = zipWith (\x y -> MorphemeC x CTransfix y) (InflMeaning lc i <$> combos) roots
  return morphs
makeExponentSystem lc morphType i onsets nucs codas tones inflMap (ns,xs) zipfParameter = do
  let combos = makeCombos $ cleanInflectionSys inflMap lc morphType i
  roots <- replicateM (length combos) (makeMorphemeSyllables onsets nucs codas tones (ns,ns) zipfParameter) -- pick minimum
  let morphs = zipWith (\x y -> MorphemeS x morphType y) (InflMeaning lc i <$> combos) roots
  return morphs

-- For a given LexCat, MorphType, and Int, return the grammatical categories expressed there
-- Based on the InflectionMap
cleanInflectionSys :: InflectionMap -> LexCat -> MorphType -> Int -> GramCatExpresses
-- ([Express Gender], [Express Animacy], [Express Case], [Express Number], [Express Definiteness], [Express Specificity], [Express Topic], [Express Person], [Express Honorific], [Express Polarity], [Express Tense], [Express Aspect], [Express Mood], [Express Voice], [Express Evidentiality], [Express Transitivity], [Express Volition])
cleanInflectionSys inflMap lc mt i = GramCatExpresses gens anis cass nums defs spes tops pers hons pols tens asps moos vois evis tras vols where
  gens = cleanSys (getGenSys inflMap) lc mt i
  anis = cleanSys (getAniSys inflMap) lc mt i
  cass = cleanSys (getCasSys inflMap) lc mt i
  nums = cleanSys (getNumSys inflMap) lc mt i
  defs = cleanSys (getDefSys inflMap) lc mt i
  spes = cleanSys (getSpeSys inflMap) lc mt i
  tops = cleanSys (getTopSys inflMap) lc mt i
  pers = cleanSys (getPerSys inflMap) lc mt i
  hons = cleanSys (getHonSys inflMap) lc mt i
  pols = cleanSys (getPolSys inflMap) lc mt i
  tens = cleanSys (getTenSys inflMap) lc mt i
  asps = cleanSys (getAspSys inflMap) lc mt i
  moos = cleanSys (getMooSys inflMap) lc mt i
  vois = cleanSys (getVoiSys inflMap) lc mt i
  evis = cleanSys (getEviSys inflMap) lc mt i
  tras = cleanSys (getTraSys inflMap) lc mt i
  vols = cleanSys (getVolSys inflMap) lc mt i

  cleanSys :: Manifest a -> LexCat -> MorphType -> Int -> [Express a]
  cleanSys NoManifest _ _ _ = [NoExpress]
  cleanSys (Manifest t x) lc mt i = out where
    found = find (\(ManifestPlace a b _) ->  a == lc && any (\(c,d) -> c == mt && d == i) b) t
    agr = join $ getAgr <$> found
    out
      | isNothing found = [NoExpress]
      -- | isJust agr = [fromMaybe NoExpress (Agree <$> agr)]
      | otherwise = map Express x

cleanInflectionSys2 :: InflectionMap -> LexCat -> GramCatExpresses
-- ([Express Gender], [Express Animacy], [Express Case], [Express Number], [Express Definiteness], [Express Specificity], [Express Topic], [Express Person], [Express Honorific], [Express Polarity], [Express Tense], [Express Aspect], [Express Mood], [Express Voice], [Express Evidentiality], [Express Transitivity], [Express Volition])
cleanInflectionSys2 inflMap lc  = GramCatExpresses gens anis cass nums defs spes tops pers hons pols tens asps moos vois evis tras vols where
  gens = cleanSys2 (getGenSys inflMap) lc
  anis = cleanSys2 (getAniSys inflMap) lc
  cass = cleanSys2 (getCasSys inflMap) lc
  nums = cleanSys2 (getNumSys inflMap) lc
  defs = cleanSys2 (getDefSys inflMap) lc
  spes = cleanSys2 (getSpeSys inflMap) lc
  tops = cleanSys2 (getTopSys inflMap) lc
  pers = cleanSys2 (getPerSys inflMap) lc
  hons = cleanSys2 (getHonSys inflMap) lc
  pols = cleanSys2 (getPolSys inflMap) lc
  tens = cleanSys2 (getTenSys inflMap) lc
  asps = cleanSys2 (getAspSys inflMap) lc
  moos = cleanSys2 (getMooSys inflMap) lc
  vois = cleanSys2 (getVoiSys inflMap) lc
  evis = cleanSys2 (getEviSys inflMap) lc
  tras = cleanSys2 (getTraSys inflMap) lc
  vols = cleanSys2 (getVolSys inflMap) lc

  cleanSys2 :: Manifest a -> LexCat -> [Express a]
  cleanSys2 NoManifest _  = [NoExpress]
  cleanSys2 (Manifest t x) lc = out where
    found = find (\(ManifestPlace a _ _) ->  a == lc) t
    out
      | isNothing found = [NoExpress]
      | otherwise = map Express x

makeCombos :: GramCatExpresses -> [GramCatExpress]
makeCombos (GramCatExpresses gens anis cass nums defs spes tops pers hons pols tens asps moos vois evis tras vols) = GramCatExpress <$> gens <*> anis <*> cass <*> nums <*> defs <*> spes <*> tops <*> pers <*> hons <*> pols <*> tens <*> asps <*> moos <*> vois <*> evis <*> tras <*> vols

-- Generate Transfix, which go between the consonants of a Consonantal Root
makeMorphemeVowels :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float ->RVar [Syllable]
makeMorphemeVowels onsets nucs codas tones (ns,xs) zipfParameter = do
  p <- triangle (max ns 2) xs
  patterns <- replicateM p (makeMorphemeVowels_ onsets nucs codas tones zipfParameter)
  assignStress patterns

makeMorphemeVowels_ :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> Float -> RVar Syllable
makeMorphemeVowels_ onsets nucs codas tones zipfParameter = do
  --onset <- fromMaybe [] <$> zipfChoice zipfParameter onsets
  nuclei <- fromMaybe Blank <$> zipfChoice zipfParameter nucs
  --coda <- fromMaybe [] <$> zipfChoice zipfParameter codas
  tone   <- choice tones
  return $ Syllable [] nuclei [] tone NONES

-- This picks the inflectional morphemes for the dictionary form of words
pickLemmaMorphemes :: [Morpheme] -> LexCat -> RVar [Morpheme]
pickLemmaMorphemes inflMorphs lc = out where
  inflMorphs_ = filter (\m -> getLC (getMeaning m) == lc) inflMorphs
  inflGroups = groupWith (\m -> (getMorphType m,getOrder $ getMeaning m)) inflMorphs_
  out | null inflGroups = return []
      | otherwise = mapM choice inflGroups

-- Derivational Morphology
makeDerivationMorphemes :: MeaningData -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float -> RVar [Morpheme]
makeDerivationMorphemes mData onsets nucs codas tones set zipfParameter = mapM (\d -> MorphemeS d Suffix <$> makeMorphemeSyllables onsets nucs codas tones set zipfParameter) (inputDerivs mData)

-- Compound Morphology
makeCompoundMorphemes :: MeaningData -> [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> (Int, Int) -> Float -> RVar [Morpheme]
makeCompoundMorphemes mData onsets nucs codas tones set zipfParameter = mapM (\d -> MorphemeS d Suffix <$> makeMorphemeSyllables onsets nucs codas tones set zipfParameter) (inputCompounds mData)

-- Pronouns
-- Need to make Pronoun Roots with GCE's that compliment the already-generated Pron inflections
-- "Fill in" the gaps that were skipped in Gen.Inflection
-- so cleanInflectionSys on Noun
-- then cleanInflectionSys on Pron
-- see where Pron is lacking, create the combos
-- CTransfix if at least 1 Transfix inflection
-- Transfix if at least 1 CTransfix
-- Root otherwise
makePronouns :: [ConsCluster] -> [Phoneme] -> [ConsCluster] -> [Tone] -> InflectionMap -> (Int, Int) -> Float -> (Int, Int) -> RVar [Morpheme]
makePronouns onsets nucs codas tones inflMap set zipfParameter (i,j) = do
  let combos = makeCombos $ subtractGCEs (cleanInflectionSys2 inflMap Noun) (cleanInflectionSys2 inflMap Pron)
  roots1 <- replicateM (length combos) (makeMorphemeVowels onsets nucs codas tones set zipfParameter)
  roots2 <- replicateM (length combos) (makeMorphemeConsonants onsets set zipfParameter)
  roots3 <- replicateM (length combos) (makeMorphemeSyllables onsets nucs codas tones set zipfParameter)
  let morphs | i == 1 = zipWith (\x y -> MorphemeC x Root y) (Meaning Pron "Pron" <$> combos) roots2
             | j == 1 = zipWith (\x y -> MorphemeV x Root y) (Meaning Pron "Pron" <$> combos) roots1
             | otherwise = zipWith (\x y -> MorphemeS x Root y) (Meaning Pron "Pron" <$> combos) roots3
  return morphs


subtractGCEs :: GramCatExpresses -> GramCatExpresses -> GramCatExpresses
subtractGCEs (GramCatExpresses gens1 anis1 cass1 nums1 defs1 spes1 tops1 pers1 hons1 pols1 tens1 asps1 moos1 vois1 evis1 tras1 vols1)
  (GramCatExpresses gens2 anis2 cass2 nums2 defs2 spes2 tops2 pers2 hons2 pols2 tens2 asps2 moos2 vois2 evis2 tras2 vols2) =
    GramCatExpresses (subtactGC gens1 gens2)
                     (subtactGC anis1 anis2)
                     (subtactGC cass1 cass2)
                     (subtactGC nums1 nums2)
                     (subtactGC defs1 defs2)
                     (subtactGC spes1 spes2)
                     (subtactGC tops1 tops2)
                     (subtactGC pers1 pers2)
                     (subtactGC hons1 hons2)
                     (subtactGC pols1 pols2)
                     (subtactGC tens1 tens2)
                     (subtactGC asps1 asps2)
                     (subtactGC moos1 moos2)
                     (subtactGC vois1 vois2)
                     (subtactGC evis1 evis2)
                     (subtactGC tras1 tras2)
                     (subtactGC vols1 vols2)

subtactGC :: Eq a => [Express a] -> [Express a] -> [Express a]
subtactGC gc1 gc2
  | null (gc1 \\ gc2)= [NoExpress]
  | otherwise = gc1 \\ gc2
