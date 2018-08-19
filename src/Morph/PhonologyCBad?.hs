module Morph.PhonologyC
( morphPhonologyC
) where

import Data.RVar
import Data.Random.Extras
import Control.Monad
import Data.List

import HelperFunctions

import Data.Phoneme
import Data.Inflection
import Data.Other

import Gen.Phonology
import Gen.Phonotactics

morphPhonologyC :: Language -> RVar Language
morphPhonologyC lang = join $ choice [ morphPlace lang
                                     , morphManner lang
                                     ]

-- morph place of articulation
morphPlace :: Language -> RVar Language
morphPlace lang = do
  let (places,_,_,_) = getCMap lang
  let opts = [ (insertPlace LABIAL lang, LABIAL `notElem` places && BILABIAL `notElem` places)
             , (insertPlace LARYNGEAL lang, LARYNGEAL `notElem` places && GLOTTAL `notElem` places)
             , (insertPlace PALATAL lang, PALATAL `notElem` places && DORSAL `notElem` places)
             , (insertPlace VELAR lang, VELAR `notElem` places && DORSAL `notElem` places)
             , (insertPlace UVULAR lang, UVULAR `notElem` places && DORSAL `notElem` places)
             , (insertPlace ALVEOLOPALATAL lang, ALVEOLOPALATAL `notElem` places && PALATAL `elem` places)

             , (deletePlace LABIAL lang, LABIAL `elem` places)
             , (deletePlace LARYNGEAL lang, LARYNGEAL `elem` places)
             , (deletePlace PALATAL lang, PALATAL `elem` places && (VELAR `elem` places || UVULAR `elem` places) && ALVEOLOPALATAL `notElem` places)
             , (deletePlace VELAR lang, VELAR `elem` places && (PALATAL `elem` places || UVULAR `elem` places))
             , (deletePlace UVULAR lang, UVULAR `elem` places && (PALATAL `elem` places || VELAR `elem` places))
             , (deletePlace ALVEOLOPALATAL lang, ALVEOLOPALATAL `elem` places)

             , (splitPlace LABIAL [BILABIAL, LABIODENTAL] lang, LABIAL `elem` places)
             , (splitPlace CORONAL [DENTIALVEOLAR, RETROFLEX] lang, CORONAL `elem` places)
             , (splitPlace DENTIALVEOLAR [DENTAL, ALVEOLAR, POSTALVEOLAR] lang, DENTIALVEOLAR `elem` places)
             , (splitPlace DORSAL [VELAR, UVULAR] lang, DORSAL `elem` places)
             , (splitPlace DORSAL [PALATAL, UVULAR] lang, DORSAL `elem` places)
             , (splitPlace DORSAL [PALATAL, VELAR] lang, DORSAL `elem` places)
             , (splitPlace DORSAL [PALATAL, VELAR, UVULAR] lang, DORSAL `elem` places)
             , (splitPlace LARYNGEAL [EPIPHARYNGEAL, GLOTTAL] lang, LARYNGEAL `elem` places)
             , (splitPlace EPIPHARYNGEAL [PHARYNGEAL, EPIGLOTTAL] lang, EPIPHARYNGEAL `elem` places)

             , (mergePlace [BILABIAL, LABIODENTAL] LABIAL lang, BILABIAL `elem` places)
             , (mergePlace [DENTIALVEOLAR, RETROFLEX] CORONAL lang, CORONAL `elem` places)
             , (mergePlace [DENTAL, ALVEOLAR, POSTALVEOLAR] DENTIALVEOLAR lang, DENTAL `elem` places)
             , (mergePlace [VELAR, UVULAR] DORSAL lang, VELAR `elem` places && UVULAR `elem` places && PALATAL `notElem` places)
             , (mergePlace [PALATAL, UVULAR] DORSAL lang, PALATAL `elem` places && UVULAR `elem` places && VELAR `notElem` places && ALVEOLOPALATAL `notElem` places)
             , (mergePlace [PALATAL, VELAR] DORSAL lang, PALATAL `elem` places && VELAR `elem` places && UVULAR `notElem` places && ALVEOLOPALATAL `notElem` places)
             , (mergePlace [PALATAL, VELAR, UVULAR] DORSAL lang, PALATAL `elem` places && VELAR `elem` places && UVULAR `elem` places && ALVEOLOPALATAL `notElem` places)
             , (mergePlace [EPIPHARYNGEAL, GLOTTAL] LARYNGEAL lang, EPIPHARYNGEAL `elem` places)
             , (mergePlace [PHARYNGEAL, EPIGLOTTAL] EPIPHARYNGEAL lang, PHARYNGEAL `elem` places)
             ]
  -- choose which change to do
  join $ choice $ map fst (filter snd opts)

-- insert a place of articulation
insertPlace :: Place -> Language -> RVar Language
insertPlace plc lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- insert <place> into places
  let placesN = plc : places
  -- keep exeptions the same?
  let exceptionsN = exceptions
  -- new consonant map
  let cMapN = (placesN, manners, phonations, exceptionsN)
  -- make new consonants
  let cons = makeConsonants placesN manners phonations exceptionsN
  -- randomy sub in <place> consonants into vocab?
  let l = length cons
  rootsN <- mapM (\(x, Morpheme y) -> (,) x <$> (Morpheme <$> mapM (\z -> join $ choice_ z <$> subPlaceIn plc cons z <*> return l) y)) roots
  -- same with inflection
  manSyssN <- mapM (\(ManifestSystem x y z) -> ManifestSystem x y <$> mapM (\(Morpheme w, v) -> (,) <$> (Morpheme <$> mapM (\j -> join $ choice_ j <$> subPlaceIn plc cons j <*> return l) w) <*> return v) z) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

subPlaceIn :: Place -> [Phoneme] -> Phoneme -> RVar Phoneme
subPlaceIn plc cons (Consonant p m h)
  | Consonant p m h `elem` cons = return $ Consonant p m h
  | otherwise = choice $ filter (\x -> cplace x == plc) cons
subPlaceIn _ _ x = return x

-- delete a place of articulation
deletePlace :: Place -> Language -> RVar Language
deletePlace plc lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- delete <place> from places
  let placesN = filter (/= plc) places
  -- update exceptions
  let exceptionsN = filter (\x -> cplace x /= plc) exceptions
  -- new consonant map
  let cMapN = (placesN, manners, phonations, exceptionsN)
  -- make new consonants
  let cons = makeConsonants placesN manners phonations exceptionsN
  -- randomy sub in <place> consonants
  rootsN <- mapM (\(x, Morpheme y) -> (,) x <$> (Morpheme <$> mapM (subPlaceOut plc cons) y)) roots
  -- same with inflection
  manSyssN <- mapM (\(ManifestSystem x y z) -> ManifestSystem x y <$> mapM (\(Morpheme w, v) -> (,) <$> (Morpheme <$> mapM (subPlaceOut plc cons) w) <*> return v) z) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

-- used for deleting places
subPlaceOut :: Place -> [Phoneme] -> Phoneme -> RVar Phoneme
subPlaceOut plc cons (Consonant p m h)
  | plc == p = choice cons
  | otherwise = return (Consonant p m h)
subPlaceOut _ _ x = return x

-- split a place of articulation
splitPlace :: Place -> [Place] -> Language -> RVar Language
splitPlace fromPlc toPlcs lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- split a place
  let placesN = toPlcs ++ filter (/= fromPlc) places
  -- update exceptions
  let exceptionsN = concatMap (\x -> if cplace x == fromPlc then map (\y -> x{cplace = y}) toPlcs else [x]) exceptions
  -- new consonant map
  let cMapN = (placesN, manners, phonations, exceptionsN)
  -- randomy replace "fromPlc" consonants
  rootsN <- mapM (\(x, Morpheme y) -> (,) x <$> (Morpheme <$> mapM (splitPlaceUp fromPlc toPlcs) y)) roots
  -- same with inflection
  manSyssN <- mapM (\(ManifestSystem x y z) -> ManifestSystem x y <$> mapM (\(Morpheme w, v) -> (,) <$> (Morpheme <$> mapM (splitPlaceUp fromPlc toPlcs) w) <*> return v) z) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

-- used for splitting
splitPlaceUp :: Place -> [Place] -> Phoneme -> RVar Phoneme
splitPlaceUp fromPlc toPlcs (Consonant p m h)
  | p == fromPlc = choice (map (\x -> Consonant x m h) toPlcs)
  | otherwise = return (Consonant p m h)
splitPlaceUp _ _ x = return x

-- merge two or more places of articulation
mergePlace :: [Place] -> Place -> Language -> RVar Language
mergePlace fromPlcs toPlc lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- merge places
  let placesN = toPlc : filter (`notElem` fromPlcs) places
  -- update exceptions
  let exceptionsN = exceptUpdate fromPlcs toPlc exceptions
  -- new consonant map
  let cMapN = (placesN, manners, phonations, exceptionsN)
  --then for any phonemes with "fromPlcs" places replace with "toPlc"
  let rootsN = map (\(x, Morpheme y) -> (,) x (Morpheme $ map (mergePlaceDown fromPlcs toPlc) y)) roots
  -- same with inflection
  let manSyssN = map (\(ManifestSystem x y z) -> ManifestSystem x y (map (\(Morpheme w, v) -> (,) (Morpheme $ map (mergePlaceDown fromPlcs toPlc) w) v) z)) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

-- used for merging
mergePlaceDown :: [Place] -> Place -> Phoneme -> Phoneme
mergePlaceDown fromPlcs toPlc (Consonant p m h)
  | p `elem` fromPlcs = Consonant toPlc m h
  | otherwise = Consonant p m h
mergePlaceDown _ _ x = x

-- used for merging places
exceptUpdate :: [Place] -> Place -> [Phoneme] -> [Phoneme]
exceptUpdate _ _ [] = []
exceptUpdate fromPlcs toPlc e
  | cplace (head e) `elem` fromPlcs
    && all (\p -> (head e){cplace = p} `elem` tail e) (filter (/= cplace (head e)) fromPlcs) =
      (head e){cplace = toPlc} : exceptUpdate fromPlcs toPlc (filter (\x -> x `notElem` map (\p -> (head e){cplace = p}) (filter (/= cplace (head e)) fromPlcs)) (tail e))
  | otherwise = head e : exceptUpdate fromPlcs toPlc (tail e)


-- morph manner of articulation
morphManner :: Language -> RVar Language
morphManner lang = do
  let (_,manners,_,_) = getCMap lang
  let opts = [ (insertManner NASAL lang, NASAL `notElem` manners)
             , (insertManner FLAP lang, FLAP `notElem` manners)
             , (insertManner LFLAP lang, LFLAP `notElem` manners && FLAP `elem` manners)
             , (insertManner FRICATIVE lang, FRICATIVE `notElem` manners)
             , (insertManner AFFRICATE lang, AFFRICATE `notElem` manners && FRICATIVE `elem` manners)
             , (insertManner SILIBANT lang, SILIBANT `notElem` manners && FRICATIVE `elem` manners)
             , (insertManner LFRICATIVE lang, LFRICATIVE `notElem` manners && FRICATIVE `elem` manners)
             , (insertManner LAFFRICATE lang, LAFFRICATE `notElem` manners && AFFRICATE `elem` manners)
             , (insertManner SAFFRICATE lang, SAFFRICATE `notElem` manners && AFFRICATE `elem` manners)
             , (insertManner APPROXIMANT lang, APPROXIMANT `notElem` manners)
             , (insertManner LAPPROXIMANT lang, LAPPROXIMANT `notElem` manners && APPROXIMANT `elem` manners)
             , (insertManner TRILL lang, TRILL `notElem` manners)

             , (deleteManner NASAL lang, NASAL `elem` manners)
             , (deleteManner FLAP lang, FLAP `elem` manners && LFLAP `notElem` manners)
             , (deleteManner LFLAP lang, LFLAP `elem` manners)
             , (deleteManner FRICATIVE lang, FRICATIVE `elem` manners && all (`notElem` manners) [AFFRICATE, SILIBANT, LFRICATIVE])
             , (deleteManner AFFRICATE lang, AFFRICATE `elem` manners && all (`notElem` manners) [LAFFRICATE, SAFFRICATE])
             , (deleteManner SILIBANT lang, SILIBANT `elem` manners)
             , (deleteManner LFRICATIVE lang, LFRICATIVE `elem` manners)
             , (deleteManner LAFFRICATE lang, LAFFRICATE `elem` manners)
             , (deleteManner SAFFRICATE lang, SAFFRICATE `elem` manners)
             , (deleteManner APPROXIMANT lang, APPROXIMANT `elem` manners && LAPPROXIMANT `notElem` manners)
             , (deleteManner LAPPROXIMANT lang, LAPPROXIMANT `elem` manners)
             , (deleteManner TRILL lang, TRILL `elem` manners)
             --, (splitManner , )
             --, (mergeManner , )
             ]
  -- choose which change to do
  join $ choice $ map fst (filter snd opts)


-- insert a manner of articulation
insertManner :: Manner -> Language -> RVar Language
insertManner man lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- insert <place> into places
  let mannersN = man : manners
  -- keep exeptions the same?
  let exceptionsN = exceptions
  -- new consonant map
  let cMapN = (places, mannersN, phonations, exceptionsN)
  -- make new consonants
  let cons = makeConsonants places mannersN phonations exceptionsN
  -- randomy sub in <place> consonants into vocab?
  let l = length cons
  rootsN <- mapM (\(x, Morpheme y) -> (,) x <$> (Morpheme <$> mapM (\z -> join $ choice_ z <$> subMannerIn man cons z <*> return l) y)) roots
  -- same with inflection
  manSyssN <- mapM (\(ManifestSystem x y z) -> ManifestSystem x y <$> mapM (\(Morpheme w, v) -> (,) <$> (Morpheme <$> mapM (\j -> join $ choice_ j <$> subMannerIn man cons j <*> return l) w) <*> return v) z) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

subMannerIn :: Manner -> [Phoneme] -> Phoneme -> RVar Phoneme
subMannerIn man cons (Consonant p m h)
  | Consonant p m h `elem` cons = return $ Consonant p m h
  | otherwise = choice $ filter (\x -> cmanner x == man) cons
subMannerIn _ _ x = return x

-- delete a manner of articulation
deleteManner :: Manner -> Language -> RVar Language
deleteManner man lang = do
  let (places, manners, phonations, exceptions) = getCMap lang
  let roots = getRoots lang
  let manSyss = getManSyss lang

  -- delete <place> from places
  let mannersN = filter (/= man) manners
  -- update exceptions
  let exceptionsN = filter (\x -> cmanner x /= man) exceptions
  -- new consonant map
  let cMapN = (places, mannersN, phonations, exceptionsN)
  -- make new consonants
  let cons = makeConsonants places mannersN phonations exceptionsN
  -- randomy sub in <place> consonants
  rootsN <- mapM (\(x, Morpheme y) -> (,) x <$> (Morpheme <$> mapM (subMannerOut man cons) y)) roots
  -- same with inflection
  manSyssN <- mapM (\(ManifestSystem x y z) -> ManifestSystem x y <$> mapM (\(Morpheme w, v) -> (,) <$> (Morpheme <$> mapM (subMannerOut man cons) w) <*> return v) z) manSyss

  return lang{getCMap = cMapN, getRoots = rootsN, getManSyss = manSyssN}

-- used for deleting manners
subMannerOut :: Manner -> [Phoneme] -> Phoneme -> RVar Phoneme
subMannerOut man cons (Consonant p m h)
  | man == m = choice cons
  | otherwise = return (Consonant p m h)
subMannerOut _ _ x = return x
