module Main where

import Prelude

import Control.Monad.Writer.Trans (runWriterT)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Game (start, tick)
import Render (render)
import Util (doXEvery)

main :: Effect Unit
main = do
    let numberOfDays = 100
    render start []
    start # doXEvery 500 numberOfDays \ d game -> do
      log $ "Day " <> show d
      log $ show game
      log ""
      Tuple game' events <- runWriterT (tick game)
      render game' events
      pure game'