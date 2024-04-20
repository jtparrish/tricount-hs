module Main (main) where

-- import Data.Aeson (Result (..))
import Data.Maybe (fromMaybe)
import Data.Semigroup ((<>))
import qualified Data.Text as DT
-- import Options.Applicative hiding (Success)
import System.Environment (lookupEnv)
-- import Text.PrettyPrint.Boxes hiding ((<>))
import Text.Read (readMaybe)
-- import TodoApp.Request (Task)
-- import qualified TodoApp.Request as TR

import Data.Graph as Graph


main :: IO ()
main = print "TODO"

tcount :: Graph.Graph -> Int
tcount g = 3


