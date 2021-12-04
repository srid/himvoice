{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Main.Utf8 (withUtf8)
import System.Which (staticWhich)
import Text.LaTeX
import UnliftIO.Process (callProcess)

pdflatex :: FilePath
pdflatex = $(staticWhich "pdflatex")

example :: LaTeX
example =
  documentclass [] article
    <> title "A short message"
    <> author "Srid"
    <> document (maketitle <> "This is all.")

main :: IO ()
main = do
  -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
  withUtf8 $ do
    renderFile "example.tex" example
    callProcess pdflatex ["example.tex"]
