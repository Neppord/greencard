module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Game (start, tick)
import Util (doX)

main :: Effect Unit
main = do
    let numberOfDays = 20
    game <- start # doX numberOfDays \ d game -> do
      log $ "Day " <> show d
      log $ show game
      log ""
      tick game
    log $ "Day " <> show numberOfDays
    log $ show game
    log ""