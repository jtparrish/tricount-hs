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
  tcountH n = tcountR (LibVector.replicate n LibSet.empty)
  -- roll the update and looping
  tcountR a ((u, v):es) = LibSet.size (LibSet.intersection (a ! u) (a ! v)) + tcountR aUpdate es
    where
    -- A(v) <- A(v) U {u}
    aUpdate = a // [(v, LibSet.insert u (a ! v))]


