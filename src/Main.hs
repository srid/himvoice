{-# LANGUAGE TypeApplications #-}

module Main where

import Main.Utf8 (withUtf8)
import Text.LaTeX

short :: LaTeX
short =
  documentclass [] article
    <> title "A short message"
    <> author "John Short"
    <> document (maketitle <> "This is all.")

main :: IO ()
main = do
  -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
  withUtf8 $ do
    renderFile "short.tex" short
