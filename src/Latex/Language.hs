module Latex.Language
( writeLatex
) where

import ClassyPrelude hiding ((<>))
import Text.LaTeX
import Text.LaTeX.Packages.Trees.Qtree
import Text.LaTeX.Packages.Graphicx
import Text.LaTeX.Packages.Lscape
import Text.LaTeX.Packages.Hyperref

import Gen.Phonotactics
import Gen.ParseTree

import Data.Language
import Data.Inflection

import Latex.Phonology
import Latex.Inflection


-- Puts together a LaTeX (.tex) document, to be written out as a PDF
-- One PDF per language family
-- Each language gets a chapter

writeLatex :: LanguageBranch -> IO ()
writeLatex langFam = renderFile (unpack ("out/" ++ getName (getLanguage langFam) ++ " language family/latex_output.tex")) (makeLatex langFam)


makeLatex :: LanguageBranch -> LaTeX
makeLatex langFam = makePreamble langFam
                 <> document (makeBody langFam)


makePreamble :: LanguageBranch -> LaTeX
makePreamble (LanguageBranch lang _ _) = documentclass ["hidelinks"] report
                 -- packages
                 <> usepackage [] lscape
                 <> usepackage [] "pdflscape"
                 <> usepackage [] hyperref
                 <> usepackage [] "forest"
                 <> usepackage [] "adjustbox"
                 <> usepackage [] "calc"
                 <> usepackage [] "multirow"
                 <> usepackage [] "fontspec"
                 <> usepackage [] "ctable" -- need to implement (for footnotes)
                 -- font
                 <> raw "\\setmainfont{Doulos SIL Compact}"
                 -- author,title,etc.
                 <> author (raw "Generated By ConLangGen")
                 <> title ("Description of the " ++ raw (getName lang) ++ " Language Family")
                 -- macros
                 <> raw "\\newcommand*\\rot{\\rotatebox{90}}"


makeBody :: LanguageBranch -> LaTeX
makeBody langFam = maketitle
                -- toc, need tof/tot
                <> tableofcontents
                <> newpage
                -- tree
                <> raw ("\\def\\phylotree{" ++ "\\begin{forest}for tree={text width=4cm, text badly centered}" ++ makeLanguageTree_ langFam ++ "\\end{forest}" ++ "}")
                <> raw "\\newlength{\\phylotreeheight}"
                <> raw "\\setlength{\\phylotreeheight}{\\heightof{\\phylotree}}"
                <> raw "\\newlength{\\phylotreewidth}"
                <> raw "\\setlength{\\phylotreewidth}{\\widthof{\\phylotree}}"
                <> raw "\\ifdim\\phylotreeheight>\\phylotreewidth"
                    ++ figure Nothing (
                      raw "\\adjustbox{fbox,max width=\\textwidth,max height=\\textheight,keepaspectratio,center,valign=m}{"
                      ++ raw "\\phylotree"
                      ++ raw "}"
                      <> caption ( raw ("Phylogenetic Tree of the " ++ getName (getLanguage langFam) ++ " Language Family"))
                      )
                  ++ raw "\\else"
                    ++ Text.LaTeX.Packages.Lscape.landscape ( figure Nothing (
                      raw "\\adjustbox{fbox,max width=\\textheight,max height=\\textwidth,keepaspectratio,center,valign=m}{"
                      ++ raw "\\phylotree"
                      ++ raw "}"
                      <> caption ( raw ("Phylogenetic Tree of the " ++ getName (getLanguage langFam) ++ " Language Family"))
                      ) )
                  ++ raw "\\fi"
                -- chapters
                <> makeChapters "" langFam

makeLanguageTree :: LanguageBranch -> Tree LaTeX
makeLanguageTree (LanguageBranch lang [] _) = Text.LaTeX.Packages.Trees.Qtree.Leaf $ textbf $ nameref $ createLabel $ unpack ("ch:" ++ getFullName lang)
makeLanguageTree (LanguageBranch lang langs _) = Node (Just $ textbf $ nameref $ createLabel $ unpack ("ch:" ++ getFullName lang))
                                                 (map makeLanguageTree langs)

makeLanguageTree_ :: LanguageBranch -> Text
makeLanguageTree_ (LanguageBranch lang [] _) = "[" ++ "\\nameref{ch:" ++ getFullName lang ++ "}" ++ "]"
makeLanguageTree_ (LanguageBranch lang langs _) = "[" ++ "\\nameref{ch:" ++ getFullName lang ++ "}" ++ concatMap makeLanguageTree_ langs ++ "]"


makeChapters :: Text -> LanguageBranch -> LaTeX
makeChapters parent (LanguageBranch lang langs _) = chapter (raw $ getFullName lang)
                                          <> label (raw ("ch:" ++ getFullName lang))
                                          <> section (raw "Diachronic Analysis")
                                            <> raw (getFullName lang ++ " is a descendent of " ++ parent ++ ".")
                                            <> subsection (raw "Phonological Changes")
                                              <> verbatim (fromMaybe "There are no notable phonological changes." (tshow <$> headMay (getRules lang)))
                                          <> writeLatexPhonology lang
                                          <> section (raw "Phonotactics")
                                            <> raw "Phonotactic description here"
                                          <> section (raw "Grammar")
                                            <> raw "Grammar description here, including sentence examples"
                                          <> writeLatexInflection lang
                                          <> section (raw "Word Formation")
                                            <> subsection (raw "Derivational Morphology")
                                              <> raw "Derivational morphology description here"
                                            <> subsection (raw "Compounding")
                                              <> raw "Compounding description here"
                                          <> section (raw "Lexicon")
                                            <> raw "Full lexicon here"
                                          <> section (raw "Writing System")
                                            <> raw "Writing system description here"
                                          <> mconcat (map (makeChapters $ getFullName lang) langs)


-- Language's name including modifiers like West, Archaic, etc.
getFullName :: Language -> Text
getFullName lang = fst (getNameMod lang) ++ snd (getNameMod lang) ++ getName lang