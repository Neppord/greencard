module Main where

import Prelude

import Control.Monad.Writer.Trans (runWriterT)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Game (start, tick)
import Render (render)
import Util (doEvery)

main :: Effect Unit
main = do
    render start []
    start # doEvery 500 \ game -> do
      Tuple game' events <- runWriterT (tick game)
      render game' events
      pure game'