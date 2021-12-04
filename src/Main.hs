{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Data.Matrix
import qualified Data.Matrix as M
import Main.Utf8 (withUtf8)
import System.Which (staticWhich)
import Text.LaTeX
import Text.LaTeX.Packages.Inputenc
import UnliftIO.Process (callProcess)

pdflatex :: FilePath
pdflatex = $(staticWhich "pdflatex")

example :: Monad m => LaTeXT m ()
example = do
  documentclass [] article
  usepackage [utf8] inputenc
  author "John Doe"
  title "Invoice"
  document $ do
    maketitle
    -- Table from a simple matrix
    center $
      matrixTabular (fmap textbf ["x", "y", "z"]) $
        M.fromList 3 3 [(1 :: Int) ..]
    -- Table from a matrix calculated in-place
    center $
      matrixTabular (fmap textbf ["Number", "Square root"]) $
        matrix 9 2 $ \(i, j) -> if j == 1 then I i else R $ sqrt $ fromIntegral i

data Number = R Double | I Int

instance Texy Number where
  texy (R x) = texy x
  texy (I i) = texy i

main :: IO ()
main = do
  -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
  withUtf8 $ do
    renderFile "example.tex" =<< execLaTeXT example
    callProcess pdflatex ["example.tex"]
