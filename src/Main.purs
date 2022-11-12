module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Game (start, tick)
import Util (doX)
import Control.Monad.Writer.Trans (runWriterT)
import Data.Tuple (fst)

main :: Effect Unit
main = do
    let numberOfDays = 20
    game <- start # doX numberOfDays \ d game -> do
      log $ "Day " <> show d
      log $ show game
      log ""
      fst <$> runWriterT (tick game)
    log $ "Day " <> show (numberOfDays + 1)
    log $ show game
    log ""