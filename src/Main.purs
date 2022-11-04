module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

data Growth = Dead | Growth Int
data PlantState = Germenation | Flower | Fruit

type CardEffect =  Plant -> Plant

type Card =
    { growth :: Growth
    , effect :: CardEffect
    }


newtype Seed = Seed
    { germenation :: Int
    , flower :: Int
    , fruit :: Int
    }

newtype Plant = Plant
    { cards :: Array Card
    , genome :: Array Card
    , seed :: Seed
    , state :: PlantState
    , timeLeft :: Int
    }


main :: Effect Unit
main = do
  log "🍝"
