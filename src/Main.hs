module Main (main) where

-- import Data.Aeson (Result (..))
import Data.Maybe (fromMaybe)
import Data.Semigroup ((<>))
-- import qualified Data.Text as DT
-- import Options.Applicative hiding (Success)
import System.Environment (lookupEnv)
-- import Text.PrettyPrint.Boxes hiding ((<>))
import Text.Read (readMaybe)
-- import TodoApp.Request (Task)
-- import qualified TodoApp.Request as TR

import Algebra.Graph as LibGraph
import Algebra.Graph (Graph)

import Data.Vector as LibVector
import Data.Vector (Vector)
import Data.Set as LibSet
import Data.Set (Set)

import Data.List as LibList

-- ** allowed by PatternSynonyms
pattern GEmpty = LibGraph.Empty
-- apparently point free not allowed
pattern GVertex x = LibGraph.Vertex x
pattern GOverlay g1 g2 = LibGraph.Overlay g1 g2
pattern GConnect g1 g2 = LibGraph.Connect g1 g2
-- **

main :: IO ()
main = print "TODO"

-- int graph so we can use them as indices
tcount :: Graph Int -> Int
tcount g = tcountH (LibGraph.vertexCount g) (LibGraph.edgeList g)
  where
  -- set up the data for recursion (vector of sets)
  -- forall v in V : A(v) <- NullSet
  tcountH :: Int -> [(Int, Int)] -> Int 
  tcountH n = tcountR (LibVector.replicate n LibSet.empty)
  -- forall (u, v) in E : (...)
  -- NOTE: u < v by graph construction (we only store one direction)
  tcountR :: Vector (Set Int) -> [(Int, Int)] -> Int
  tcountR a es = let (ct, _aFinal) = LibList.foldl' update (0, a) es in ct
  -- forall w in A(u) ^ A(v) : T <- T + 1
  update :: (Int, Vector (Set Int)) -> (Int, Int) -> (Int, Vector (Set Int))
  update (res, a) (u, v) = (res + LibSet.size (LibSet.intersection (a ! u) (a ! v)), aUpdate)
    where
    -- A(v) <- A(v) U {u}
    aUpdate = a // [(v, LibSet.insert u (a ! v))]


